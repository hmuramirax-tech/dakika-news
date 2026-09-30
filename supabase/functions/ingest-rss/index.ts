// Supabase Edge Function: RSS Ingestion
// Fetches articles from configured RSS feeds and stores them in Supabase

import { serve } from 'https://deno.land/std@0.168.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';
import { parse } from 'https://esm.sh/rss-parser@3.12.0';

const SUPABASE_URL = Deno.env.get('SUPABASE_URL')!;
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!;

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', {
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'POST',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization',
      },
    });
  }

  try {
    const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

    // Get all active sources with RSS feeds
    const { data: sources, error: sourcesError } = await supabase
      .from('sources')
      .select('*')
      .eq('is_active', true)
      .not('rss_feed_url', 'is', null);

    if (sourcesError) throw sourcesError;

    const results = {
      total: sources.length,
      ingested: 0,
      duplicates: 0,
      errors: 0,
      details: [] as any[],
    };

    for (const source of sources) {
      try {
        const feed = await parse(source.rss_feed_url);
        let sourceIngested = 0;
        let sourceDuplicates = 0;

        for (const item of feed.items.slice(0, 20)) {
          // Check for duplicates
          const { data: existing } = await supabase
            .from('articles')
            .select('id')
            .eq('source_id', source.id)
            .eq('external_id', item.guid || item.link)
            .maybeSingle();

          if (existing) {
            sourceDuplicates++;
            continue;
          }

          // Insert new article
          const { error: insertError } = await supabase.from('articles').insert({
            source_id: source.id,
            external_id: item.guid || item.link,
            title: item.title || 'Untitled',
            content: item['content:encoded'] || item.content || item.summary || '',
            url: item.link,
            image_url: extractImage(item),
            language: source.language,
            status: 'pending',
            published_at: item.pubDate ? new Date(item.pubDate) : new Date(),
          });

          if (!insertError) {
            sourceIngested++;
          }
        }

        results.ingested += sourceIngested;
        results.duplicates += sourceDuplicates;
        results.details.push({
          source: source.name,
          ingested: sourceIngested,
          duplicates: sourceDuplicates,
        });
      } catch (error) {
        results.errors++;
        results.details.push({
          source: source.name,
          error: error.message,
        });
      }
    }

    return new Response(JSON.stringify(results), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });
  } catch (error) {
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500, headers: { 'Content-Type': 'application/json' } }
    );
  }
});

function extractImage(item: any): string | null {
  // Try various RSS image formats
  if (item.enclosure?.url) return item.enclosure.url;
  if (item['media:content']?.url) return item['media:content'].url;
  if (item['media:thumbnail']?.url) return item['media:thumbnail'].url;

  // Try to extract from content
  const content = item['content:encoded'] || item.content || '';
  const imgMatch = content.match(/<img[^>]+src="([^"]+)"/);
  if (imgMatch) return imgMatch[1];

  return null;
}
