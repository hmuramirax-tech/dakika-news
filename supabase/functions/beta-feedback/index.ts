// Supabase Edge Function: Beta Feedback
// Collects feedback from beta users via in-app submissions

import { serve } from 'https://deno.land/std@0.168.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

const SUPABASE_URL = Deno.env.get('SUPABASE_URL')!;
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!;

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', {
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'POST, GET',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization',
      },
    });
  }

  try {
    const url = new URL(req.url);
    const action = url.searchParams.get('action') || 'submit';

    const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

    switch (action) {
      case 'submit':
        return await submitFeedback(supabase, req);
      case 'list':
        return await listFeedback(supabase, url);
      case 'stats':
        return await getFeedbackStats(supabase);
      default:
        return new Response(
          JSON.stringify({ error: 'Unknown action' }),
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

async function submitFeedback(supabase: any, req: Request) {
  const { userId, type, rating, message, screen } = await req.json();

  if (!userId || !type) {
    return new Response(
      JSON.stringify({ error: 'Missing required fields' }),
      { status: 400, headers: { 'Content-Type': 'application/json' } }
    );
  }

  const { data, error } = await supabase
    .from('beta_feedback')
    .insert({
      user_id: userId,
      type, // 'bug', 'feature', 'general'
      rating, // 1-5
      message,
      screen,
      status: 'new',
      created_at: new Date().toISOString(),
    })
    .select()
    .single();

  if (error) throw error;

  return new Response(
    JSON.stringify({ success: true, feedback: data }),
    { status: 200, headers: { 'Content-Type': 'application/json' } }
  );
}

async function listFeedback(supabase: any, url: URL) {
  const status = url.searchParams.get('status') || 'all';
  const type = url.searchParams.get('type') || 'all';
  const limit = parseInt(url.searchParams.get('limit') || '50');

  let query = supabase
    .from('beta_feedback')
    .select('*, profiles(display_name, phone)')
    .order('created_at', { ascending: false })
    .limit(limit);

  if (status !== 'all') {
    query = query.eq('status', status);
  }

  if (type !== 'all') {
    query = query.eq('type', type);
  }

  const { data, error } = await query;

  if (error) throw error;

  return new Response(
    JSON.stringify({ success: true, feedback: data }),
    { status: 200, headers: { 'Content-Type': 'application/json' } }
  );
}

async function getFeedbackStats(supabase: any) {
  const { count: total } = await supabase
    .from('beta_feedback')
    .select('id', { count: 'exact', head: true });

  const { count: bugs } = await supabase
    .from('beta_feedback')
    .select('id', { count: 'exact', head: true })
    .eq('type', 'bug');

  const { count: features } = await supabase
    .from('beta_feedback')
    .select('id', { count: 'exact', head: true })
    .eq('type', 'feature');

  const { count: newFeedback } = await supabase
    .from('beta_feedback')
    .select('id', { count: 'exact', head: true })
    .eq('status', 'new');

  const { count: resolved } = await supabase
    .from('beta_feedback')
    .select('id', { count: 'exact', head: true })
    .eq('status', 'resolved');

  return new Response(
    JSON.stringify({
      success: true,
      stats: {
        total,
        bugs,
        features,
        new: newFeedback,
        resolved,
      },
    }),
    { status: 200, headers: { 'Content-Type': 'application/json' } }
  );
}
