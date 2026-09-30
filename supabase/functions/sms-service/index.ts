// Supabase Edge Function: SMS News Service
// Provides SMS-based news digest for feature phone users
// Accessible via shortcode with carrier billing

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
    const { phoneNumber, command } = await req.json();

    if (!phoneNumber || !command) {
      return new Response(
        JSON.stringify({ error: 'Missing required fields: phoneNumber, command' }),
        { status: 400, headers: { 'Content-Type': 'application/json' } }
      );
    }

    const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

    switch (command.toUpperCase()) {
      case 'NEWS':
        return await sendNewsDigest(supabase, phoneNumber);
      case 'STOP':
        return await unsubscribe(supabase, phoneNumber);
      case 'START':
        return await subscribe(supabase, phoneNumber);
      default:
        return new Response(
          JSON.stringify({ error: 'Unknown command. Send NEWS for digest, STOP to unsubscribe.' }),
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

async function sendNewsDigest(supabase: any, phoneNumber: string) {
  // Get top 5 recent published articles
  const { data: articles, error } = await supabase
    .from('articles')
    .select('title, summary, sources(name)')
    .eq('status', 'published')
    .order('published_at', { ascending: false })
    .limit(5);

  if (error) throw error;

  // Format SMS message (max 160 chars per SMS, up to 5 stories)
  let message = 'DAKIKA Digest:\n\n';
  for (let i = 0; i < articles.length; i++) {
    const article = articles[i];
    const line = `${i + 1}. ${article.title}\n`;
    if (message.length + line.length > 800) break; // Keep under 5 SMS
    message += line;
  }

  message += '\nReply STOP to unsubscribe.';

  // TODO: Send via SMS gateway (Twilio, Africa's Talking, etc.)
  // For now, return the message that would be sent
  return new Response(
    JSON.stringify({
      success: true,
      phoneNumber,
      message,
      storyCount: articles.length,
      smsCount: Math.ceil(message.length / 160),
    }),
    { status: 200, headers: { 'Content-Type': 'application/json' } }
  );
}

async function subscribe(supabase: any, phoneNumber: string) {
  await supabase.from('sms_subscribers').upsert({
    phone_number: phoneNumber,
    is_subscribed: true,
    subscribed_at: new Date().toISOString(),
  });

  return new Response(
    JSON.stringify({
      success: true,
      message: 'Subscribed to DAKIKA SMS. Send NEWS for daily digest.',
    }),
    { status: 200, headers: { 'Content-Type': 'application/json' } }
  );
}

async function unsubscribe(supabase: any, phoneNumber: string) {
  await supabase
    .from('sms_subscribers')
    .update({ is_subscribed: false, unsubscribed_at: new Date().toISOString() })
    .eq('phone_number', phoneNumber);

  return new Response(
    JSON.stringify({
      success: true,
      message: 'Unsubscribed from OneNews SMS.',
    }),
    { status: 200, headers: { 'Content-Type': 'application/json' } }
  );
}
