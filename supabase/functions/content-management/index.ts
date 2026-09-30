// Supabase Edge Function: Content Management
// Admin endpoint for managing articles, sources, and categories

import { serve } from 'https://deno.land/std@0.168.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

const SUPABASE_URL = Deno.env.get('SUPABASE_URL')!;
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!;

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', {
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'POST, GET, PUT, DELETE',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization',
      },
    });
  }

  try {
    const url = new URL(req.url);
    const action = url.searchParams.get('action') || 'list';
    const contentType = url.searchParams.get('type') || 'articles';

    const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

    switch (contentType) {
      case 'articles':
        return await handleArticles(supabase, action, req, url);
      case 'sources':
        return await handleSources(supabase, action, req, url);
      case 'categories':
        return await handleCategories(supabase, action, req, url);
      default:
        return new Response(
          JSON.stringify({ error: 'Invalid content type' }),
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

async function handleArticles(supabase: any, action: string, req: Request, url: URL) {
  switch (action) {
    case 'list': {
      const status = url.searchParams.get('status') || 'published';
      const limit = parseInt(url.searchParams.get('limit') || '50');
      const offset = parseInt(url.searchParams.get('offset') || '0');

      const { data, error } = await supabase
        .from('articles')
        .select('*, sources(name), categories(name)')
        .eq('status', status)
        .order('created_at', { ascending: false })
        .range(offset, offset + limit - 1);

      if (error) throw error;
      return new Response(JSON.stringify({ success: true, articles: data }), {
        status: 200,
        headers: { 'Content-Type': 'application/json' },
      });
    }

    case 'update': {
      const { articleId, updates } = await req.json();
      const { error } = await supabase
        .from('articles')
        .update({ ...updates, updated_at: new Date().toISOString() })
        .eq('id', articleId);

      if (error) throw error;
      return new Response(JSON.stringify({ success: true }), {
        status: 200,
        headers: { 'Content-Type': 'application/json' },
      });
    }

    case 'delete': {
      const articleId = url.searchParams.get('articleId');
      const { error } = await supabase.from('articles').delete().eq('id', articleId);
      if (error) throw error;
      return new Response(JSON.stringify({ success: true }), {
        status: 200,
        headers: { 'Content-Type': 'application/json' },
      });
    }

    default:
      return new Response(JSON.stringify({ error: 'Unknown action' }), {
        status: 400,
        headers: { 'Content-Type': 'application/json' },
      });
  }
}

async function handleSources(supabase: any, action: string, req: Request, url: URL) {
  switch (action) {
    case 'list': {
      const { data, error } = await supabase
        .from('sources')
        .select('*')
        .order('name');

      if (error) throw error;
      return new Response(JSON.stringify({ success: true, sources: data }), {
        status: 200,
        headers: { 'Content-Type': 'application/json' },
      });
    }

    case 'add': {
      const { name, url, rssFeedUrl, language, credibilityScore } = await req.json();
      const { data, error } = await supabase
        .from('sources')
        .insert({ name, url, rss_feed_url: rssFeedUrl, language, credibility_score: credibilityScore })
        .select()
        .single();

      if (error) throw error;
      return new Response(JSON.stringify({ success: true, source: data }), {
        status: 200,
        headers: { 'Content-Type': 'application/json' },
      });
    }

    case 'update': {
      const sourceId = url.searchParams.get('sourceId');
      const updates = await req.json();
      const { error } = await supabase
        .from('sources')
        .update(updates)
        .eq('id', sourceId);

      if (error) throw error;
      return new Response(JSON.stringify({ success: true }), {
        status: 200,
        headers: { 'Content-Type': 'application/json' },
      });
    }

    case 'toggle': {
      const sourceId = url.searchParams.get('sourceId');
      const { data: source } = await supabase
        .from('sources')
        .select('is_active')
        .eq('id', sourceId)
        .single();

      const { error } = await supabase
        .from('sources')
        .update({ is_active: !source.is_active })
        .eq('id', sourceId);

      if (error) throw error;
      return new Response(JSON.stringify({ success: true }), {
        status: 200,
        headers: { 'Content-Type': 'application/json' },
      });
    }

    default:
      return new Response(JSON.stringify({ error: 'Unknown action' }), {
        status: 400,
        headers: { 'Content-Type': 'application/json' },
      });
  }
}

async function handleCategories(supabase: any, action: string, req: Request, url: URL) {
  switch (action) {
    case 'list': {
      const { data, error } = await supabase
        .from('categories')
        .select('*')
        .order('sort_order');

      if (error) throw error;
      return new Response(JSON.stringify({ success: true, categories: data }), {
        status: 200,
        headers: { 'Content-Type': 'application/json' },
      });
    }

    case 'add': {
      const { name, nameEn, nameRw, nameSw, icon, color, sortOrder } = await req.json();
      const { data, error } = await supabase
        .from('categories')
        .insert({ name, name_en: nameEn, name_rw: nameRw, name_sw: nameSw, icon, color, sort_order: sortOrder })
        .select()
        .single();

      if (error) throw error;
      return new Response(JSON.stringify({ success: true, category: data }), {
        status: 200,
        headers: { 'Content-Type': 'application/json' },
      });
    }

    case 'update': {
      const categoryId = url.searchParams.get('categoryId');
      const updates = await req.json();
      const { error } = await supabase
        .from('categories')
        .update(updates)
        .eq('id', categoryId);

      if (error) throw error;
      return new Response(JSON.stringify({ success: true }), {
        status: 200,
        headers: { 'Content-Type': 'application/json' },
      });
    }

    default:
      return new Response(JSON.stringify({ error: 'Unknown action' }), {
        status: 400,
        headers: { 'Content-Type': 'application/json' },
      });
  }
}
