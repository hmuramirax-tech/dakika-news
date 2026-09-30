// Supabase Edge Function: Scheduled Tasks
// Runs daily to ingest articles, generate digests, and send notifications
// Configure in Supabase Dashboard → Edge Functions → Cron

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
    const { task } = await req.json();
    const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

    switch (task) {
      case 'ingest':
        return await ingestArticles(supabase);
      case 'summarize':
        return await summarizePendingArticles(supabase);
      case 'digest':
        return await generateDailyDigests(supabase);
      case 'cleanup':
        return return await cleanupOldData(supabase);
      default:
        return new Response(
          JSON.stringify({ error: 'Unknown task' }),
          { status: 400, headers: { 'Content-Type': 'application/json' } }
        );
    }
  } catch (error) {
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500, headers: { 'Content-Type': 'application/json' } }
    );
  }
});

async function ingestArticles(supabase: any) {
  // Call the ingest-rss function
  const response = await fetch(`${SUPABASE_URL}/functions/v1/ingest-rss`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${SUPABASE_SERVICE_ROLE_KEY}`,
    },
  });

  const result = await response.json();
  return new Response(JSON.stringify(result), {
    status: 200,
    headers: { 'Content-Type': 'application/json' },
  });
}

async function summarizePendingArticles(supabase: any) {
  // Get articles pending summarization
  const { data: articles, error } = await supabase
    .from('articles')
    .select('id, title, content, language')
    .eq('status', 'pending')
    .limit(50);

  if (error) throw error;

  let summarized = 0;
  for (const article of articles) {
    // Call summarize function for each article
    await fetch(`${SUPABASE_URL}/functions/v1/summarize`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${SUPABASE_SERVICE_ROLE_KEY}`,
      },
      body: JSON.stringify({
        articleId: article.id,
        title: article.title,
        content: article.content,
        language: article.language,
      }),
    });
    summarized++;
  }

  return new Response(
    JSON.stringify({ success: true, summarized }),
    { status: 200, headers: { 'Content-Type': 'application/json' } }
  );
}

async function generateDailyDigests(supabase: any) {
  const today = new Date().toISOString().split('T')[0];
  const periods = ['morning', 'afternoon', 'evening'];

  for (const period of periods) {
    await fetch(`${SUPABASE_URL}/functions/v1/generate-digest`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${SUPABASE_SERVICE_ROLE_KEY}`,
      },
      body: JSON.stringify({ date: today, period }),
    });
  }

  return new Response(
    JSON.stringify({ success: true, periods }),
    { status: 200, headers: { 'Content-Type': 'application/json' } }
  );
}

async function cleanupOldData(supabase: any) {
  // Delete articles older than 90 days
  const cutoffDate = new Date(Date.now() - 90 * 24 * 60 * 60 * 1000).toISOString();

  const { error } = await supabase
    .from('articles')
    .delete()
    .lt('published_at', cutoffDate)
    .eq('status', 'rejected');

  if (error) throw error;

  // Delete old analytics events (keep 90 days)
  await supabase
    .from('analytics_events')
    .delete()
    .lt('created_at', cutoffDate);

  return new Response(
    JSON.stringify({ success: true }),
    { status: 200, headers: { 'Content-Type': 'application/json' } }
  );
}
