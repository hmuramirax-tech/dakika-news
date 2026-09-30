// Supabase Edge Function: Payment Callback
// Handles payment provider webhooks and updates subscription status

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
    const { provider, transactionId, status, phoneNumber, amount } = await req.json();

    if (!provider || !transactionId || !status) {
      return new Response(
        JSON.stringify({ error: 'Missing required fields' }),
        { status: 400, headers: { 'Content-Type': 'application/json' } }
      );
    }

    const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

    // Find user by phone number
    const { data: profile, error: profileError } = await supabase
      .from('profiles')
      .select('id')
      .eq('phone', phoneNumber)
      .maybeSingle();

    if (profileError) throw profileError;

    if (!profile) {
      return new Response(
        JSON.stringify({ error: 'User not found' }),
        { status: 404, headers: { 'Content-Type': 'application/json' } }
      );
    }

    const userId = profile.id;

    if (status === 'success') {
      // Create or update subscription
      const { error: subError } = await supabase.from('subscriptions').upsert({
        user_id: userId,
        tier: 'premium',
        provider: provider,
        provider_subscription_id: transactionId,
        start_date: new Date().toISOString(),
        end_date: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toISOString(), // 30 days
        payment_status: 'active',
        auto_renew: true,
      });

      if (subError) throw subError;

      // Update user profile
      await supabase
        .from('profiles')
        .update({ subscription_tier: 'premium' })
        .eq('id', userId);

      // Track analytics
      await supabase.from('analytics_events').insert({
        user_id: userId,
        event_name: 'payment',
        event_data: {
          provider,
          status: 'success',
          amount,
          transaction_id: transactionId,
        },
      });
    } else {
      // Payment failed
      await supabase.from('analytics_events').insert({
        user_id: userId,
        event_name: 'payment',
        event_data: {
          provider,
          status: 'failed',
          amount,
          transaction_id: transactionId,
        },
      });
    }

    return new Response(
      JSON.stringify({
        success: true,
        status,
        userId,
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
