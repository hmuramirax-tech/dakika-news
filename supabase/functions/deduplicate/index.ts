// Supabase Edge Function: Content Deduplication
// Detects and merges duplicate stories from multiple sources
// Uses title similarity (85% threshold per BR-007)

import { serve } from 'https://deno.land/std@0.168.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

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

    // Get recent published articles (last 48 hours)
    const twoDaysAgo = new Date(Date.now() - 48 * 60 * 60 * 1000).toISOString();
    const { data: articles, error } = await supabase
      .from('articles')
      .select('id, title, source_id, url, published_at, status')
      .eq('status', 'published')
      .gte('published_at', twoDaysAgo)
      .order('published_at', { ascending: false });

    if (error) throw error;

    const duplicates = [];
    const merged = [];

    for (let i = 0; i < articles.length; i++) {
      for (let j = i + 1; j < articles.length; j++) {
        const similarity = calculateSimilarity(articles[i].title, articles[j].title);

        if (similarity >= 0.85) {
          // Duplicate detected — keep the earlier one as primary
          const primary = articles[i].published_at <= articles[j].published_at ? articles[i] : articles[j];
          const secondary = articles[i].published_at <= articles[j].published_at ? articles[j] : articles[i];

          duplicates.push({
            primary: primary.id,
            secondary: secondary.id,
            similarity: similarity.toFixed(2),
            title: primary.title,
          });

          // Mark secondary as duplicate (soft delete by changing status)
          await supabase
            .from('articles')
            .update({ status: 'duplicate', updated_at: new Date().toISOString() })
            .eq('id', secondary.id);

          merged.push(secondary.id);
        }
      }
    }

    return new Response(
      JSON.stringify({
        success: true,
        scanned: articles.length,
        duplicatesFound: duplicates.length,
        duplicates,
        merged,
      }),
      { status: 200, headers: { 'Content-Type': 'application/json' } }
    );
  } catch (error) {
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500, headers: { 'Content-Type': 'application/json' } }
    );
  }
});

/**
 * Calculate Jaccard similarity between two strings.
 * Uses word-level comparison for better accuracy with news headlines.
 */
function calculateSimilarity(str1: string, str2: string): number {
  const words1 = new Set(str1.toLowerCase().split(/\s+/).filter(w => w.length > 2));
  const words2 = new Set(str2.toLowerCase().split(/\s+/).filter(w => w.length > 2));

  if (words1.size === 0 || words2.size === 0) return 0;

  const intersection = new Set([...words1].filter(w => words2.has(w)));
  const union = new Set([...words1, ...words2]);

  return intersection.size / union.size;
}
