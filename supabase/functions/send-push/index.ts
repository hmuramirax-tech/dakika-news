// Supabase Edge Function: Send Push Notification
// Sends push notifications to users via FCM for breaking news

import { serve } from 'https://deno.land/std@0.168.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

const SUPABASE_URL = Deno.env.get('SUPABASE_URL')!;
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!;
const FCM_SERVER_KEY = Deno.env.get('FCM_SERVER_KEY')!;

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
    const { articleId, title, body, topic } = await req.json();

    if (!title || !body) {
      return new Response(
        JSON.stringify({ error: 'Missing required fields: title, body' }),
        { status: 400, headers: { 'Content-Type': 'application/json' } }
      );
    }

    // Send to topic (breaking_news or daily_digest)
    const targetTopic = topic || 'breaking_news';

    const response = await fetch('https://fcm.googleapis.com/fcm/send', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `key=${FCM_SERVER_KEY}`,
      },
      body: JSON.stringify({
        to: `/topics/${targetTopic}`,
        notification: {
          title,
          body,
          icon: 'ic_launcher',
          color: '#1B7A3D',
        },
        data: {
          article_id: articleId || '',
          type: targetTopic,
          click_action: 'FLUTTER_NOTIFICATION_CLICK',
        },
        priority: 'high',
      }),
    });

    if (!response.ok) {
      throw new Error(`FCM error: ${response.status}`);
    }

    const result = await response.json();

    return new Response(
      JSON.stringify({
        success: true,
        topic: targetTopic,
        messageId: result.message_id,
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
