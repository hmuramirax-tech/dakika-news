// Supabase Edge Function: Content Categorization
// Uses AI to automatically categorize articles into predefined categories

import { serve } from 'https://deno.land/std@0.168.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

const OPENAI_API_KEY = Deno.env.get('OPENAI_API_KEY')!;
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
    const { articleId, title, content } = await req.json();

    if (!articleId || !title || !content) {
      return new Response(
        JSON.stringify({ error: 'Missing required fields: articleId, title, content' }),
        { status: 400, headers: { 'Content-Type': 'application/json' } }
      );
    }

    // Get all active categories
    const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);
    const { data: categories, error: catError } = await supabase
      .from('categories')
      .select('id, name, name_en')
      .eq('is_active', true);

    if (catError) throw catError;

    // Use AI to categorize
    const categoryId = await categorizeArticle(title, content, categories);

    // Update article with category
    const { error: updateError } = await supabase
      .from('articles')
      .update({ category_id: categoryId, updated_at: new Date().toISOString() })
      .eq('id', articleId);

    if (updateError) throw updateError;

    return new Response(
      JSON.stringify({
        success: true,
        articleId,
        categoryId,
        categoryName: categories.find((c: any) => c.id === categoryId)?.name_en,
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

async function categorizeArticle(
  title: string,
  content: string,
  categories: any[]
): Promise<string> {
  const categoryList = categories.map((c: any) => c.name_en).join(', ');

  const response = await fetch('https://api.openai.com/v1/chat/completions', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${OPENAI_API_KEY}`,
    },
    body: JSON.stringify({
      model: 'gpt-4o-mini',
      messages: [
        {
          role: 'system',
          content: `You are a news categorizer. Categorize the article into exactly one of these categories: ${categoryList}. Respond with ONLY the category name, nothing else.`,
        },
        {
          role: 'user',
          content: `Title: ${title}\n\nContent: ${content.substring(0, 2000)}`,
        },
      ],
      max_tokens: 20,
      temperature: 0.1,
    }),
  });

  if (!response.ok) {
    throw new Error(`OpenAI API error: ${response.status}`);
  }

  const data = await response.json();
  const categoryName = data.choices[0].message.content.trim().toLowerCase();

  // Find matching category
  const matched = categories.find(
    (c: any) => c.name_en.toLowerCase() === categoryName
  );

  return matched?.id || categories[0]?.id; // Default to first category if no match
}
