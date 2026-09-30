// Supabase Edge Function: Editor Review Queue
// Allows human editors to review, edit, approve, or reject AI-generated summaries

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
    const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);
    const url = new URL(req.url);
    const action = url.searchParams.get('action') || 'list';

    switch (action) {
      case 'list':
        return await listPending(supabase);
      case 'approve':
        return await approveArticle(supabase, req);
      case 'reject':
        return await rejectArticle(supabase, req);
      case 'edit':
        return await editArticle(supabase, req);
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

async function listPending(supabase: any) {
  const { data: articles, error } = await supabase
    .from('articles')
    .select('*, sources(name), categories(name)')
    .in('status', ['pending', 'review'])
    .order('created_at', { ascending: false })
    .limit(50);

  if (error) throw error;

  return new Response(
    JSON.stringify({ success: true, articles }),
    { status: 200, headers: { 'Content-Type': 'application/json' } }
  );
}

async function approveArticle(supabase: any, req: Request) {
  const { articleId, editorId } = await req.json();

  const { error } = await supabase
    .from('articles')
    .update({ status: 'published', updated_at: new Date().toISOString() })
    .eq('id', articleId);

  if (error) throw error;

  // Log editor action
  await supabase.from('editor_actions').insert({
    editor_id: editorId,
    article_id: articleId,
    action: 'approve',
  });

  return new Response(
    JSON.stringify({ success: true, message: 'Article approved' }),
    { status: 200, headers: { 'Content-Type': 'application/json' } }
  );
}

async function rejectArticle(supabase: any, req: Request) {
  const { articleId, editorId, reason } = await req.json();

  const { error } = await supabase
    .from('articles')
    .update({ status: 'rejected', updated_at: new Date().toISOString() })
    .eq('id', articleId);

  if (error) throw error;

  // Log editor action
  await supabase.from('editor_actions').insert({
    editor_id: editorId,
    article_id: articleId,
    action: 'reject',
    notes: reason,
  });

  return new Response(
    JSON.stringify({ success: true, message: 'Article rejected' }),
    { status: 200, headers: { 'Content-Type': 'application/json' } }
  );
}

async function editArticle(supabase: any, req: Request) {
  const { articleId, editorId, summary, categoryId } = await req.json();

  const updates: any = { updated_at: new Date().toISOString() };
  if (summary) updates.summary = summary;
  if (categoryId) updates.category_id = categoryId;
  updates.status = 'published';

  const { error } = await supabase
    .from('articles')
    .update(updates)
    .eq('id', articleId);

  if (error) throw error;

  // Log editor action
  await supabase.from('editor_actions').insert({
    editor_id: editorId,
    article_id: articleId,
    action: 'edit',
    new_value: { summary, categoryId },
  });

  return new Response(
    JSON.stringify({ success: true, message: 'Article updated' }),
    { status: 200, headers: { 'Content-Type': 'application/json' } }
  );
}
