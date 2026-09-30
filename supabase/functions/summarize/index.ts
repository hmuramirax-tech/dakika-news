// Supabase Edge Function: AI Summarization
// Called by the backend pipeline to generate 40-80 word summaries

import { serve } from 'https://deno.land/std@0.168.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

const OPENAI_API_KEY = Deno.env.get('OPENAI_API_KEY')!;
const SUPABASE_URL = Deno.env.get('SUPABASE_URL')!;
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!;

serve(async (req) => {
  // Handle CORS
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
    const { articleId, title, content, language = 'en' } = await req.json();

    if (!articleId || !title || !content) {
      return new Response(
        JSON.stringify({ error: 'Missing required fields: articleId, title, content' }),
        { status: 400, headers: { 'Content-Type': 'application/json' } }
      );
    }

    // Call OpenAI API for summarization
    const summary = await generateSummary(title, content, language);

    // Calculate confidence score (simplified — in production, use model confidence)
    const confidenceScore = calculateConfidence(summary, content);

    // Update the article in Supabase
    const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);
    const { error } = await supabase
      .from('articles')
      .update({
        summary,
        confidence_score: confidenceScore,
        status: confidenceScore < 0.7 ? 'review' : 'published',
        updated_at: new Date().toISOString(),
      })
      .eq('id', articleId);

    if (error) {
      throw error;
    }

    return new Response(
      JSON.stringify({
        success: true,
        articleId,
        summary,
        confidenceScore,
        status: confidenceScore < 0.7 ? 'review' : 'published',
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

async function generateSummary(
  title: string,
  content: string,
  language: string
): Promise<string> {
  const languagePrompt = {
    en: 'Summarize in English',
    rw: 'Summarize in Kinyarwanda',
    sw: 'Summarize in Swahili',
  }[language] || 'Summarize in English';

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
          content: `You are a news summarizer. ${languagePrompt}. Create a concise summary of 40-80 words. Include the most important facts, figures, and context. Do not add commentary or opinion.`,
        },
        {
          role: 'user',
          content: `Title: ${title}\n\nContent: ${content.substring(0, 8000)}`,
        },
      ],
      max_tokens: 150,
      temperature: 0.3,
    }),
  });

  if (!response.ok) {
    throw new Error(`OpenAI API error: ${response.status}`);
  }

  const data = await response.json();
  return data.choices[0].message.content.trim();
}

function calculateConfidence(summary: string, content: string): number {
  // Simplified confidence calculation
  // In production, use model logprobs or a separate quality model
  const summaryWords = summary.split(' ').length;
  const contentWords = content.split(' ').length;

  if (summaryWords < 20) return 0.5;
  if (summaryWords > 100) return 0.6;
  if (contentWords < 50) return 0.4;

  // Check for key elements
  const hasNumbers = /\d+/.test(summary);
  const hasQuotes = /["']/.test(summary);
  const hasNames = /[A-Z][a-z]+/.test(summary);

  let score = 0.75;
  if (hasNumbers) score += 0.05;
  if (hasQuotes) score += 0.05;
  if (hasNames) score += 0.05;

  return Math.min(score, 0.95);
}
