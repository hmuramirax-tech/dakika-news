// Supabase Edge Function: Generate Daily Digest
// Selects top stories and creates a digest for the specified period

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
    const { date, period, storyCount = 12 } = await req.json();

    if (!date || !period) {
      return new Response(
        JSON.stringify({ error: 'Missing required fields: date, period' }),
        { status: 400, headers: { 'Content-Type': 'application/json' } }
      );
    }

    const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

    // Get top stories for the digest
    // Priority: high confidence, recent, diverse categories
    const { data: stories, error: storiesError } = await supabase
      .from('articles')
      .select('id, title, category_id, published_at, confidence_score')
      .eq('status', 'published')
      .gte('published_at', new Date(new Date(date).getTime() - 24 * 60 * 60 * 1000).toISOString())
      .order('confidence_score', { ascending: false })
      .order('published_at', { ascending: false })
      .limit(storyCount * 2); // Get extra for diversity filtering

    if (storiesError) throw storiesError;

    // Ensure category diversity — max 3 stories per category
    const categoryCounts: Record<string, number> = {};
    const selectedStories: string[] = [];

    for (const story of stories) {
      const cat = story.category_id || 'general';
      if (!categoryCounts[cat]) categoryCounts[cat] = 0;

      if (categoryCounts[cat] < 3) {
        selectedStories.push(story.id);
        categoryCounts[cat]++;
      }

      if (selectedStories.length >= storyCount) break;
    }

    // Create or update digest
    const { data: digest, error: digestError } = await supabase
      .from('digests')
      .upsert({
        date,
        period,
        title: `${period.charAt(0).toUpperCase() + period.slice(1)} Digest — ${formatDate(date)}`,
        story_ids: selectedStories,
      })
      .select()
      .single();

    if (digestError) throw digestError;

    return new Response(
      JSON.stringify({
        success: true,
        digest,
        storyCount: selectedStories.length,
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

function formatDate(dateStr: string): string {
  const date = new Date(dateStr);
  return date.toLocaleDateString('en-US', {
    weekday: 'long',
    month: 'long',
    day: 'numeric',
  });
}
