// Supabase Edge Function: Process Payment
// Initiates mobile money payment via MTN MoMo or Airtel Money

import { serve } from 'https://deno.land/std@0.168.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

const SUPABASE_URL = Deno.env.get('SUPABASE_URL')!;
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!;
const MTN_MOMO_API_KEY = Deno.env.get('MTN_MOMO_API_KEY')!;
const AIRTEL_MONEY_API_KEY = Deno.env.get('AIRTEL_MONEY_API_KEY')!;

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
    const { provider, phoneNumber, amount, currency } = await req.json();

    if (!provider || !phoneNumber || !amount) {
      return new Response(
        JSON.stringify({ error: 'Missing required fields' }),
        { status: 400, headers: { 'Content-Type': 'application/json' } }
      );
    }

    const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

    // Get user by phone number
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

    // Create pending subscription
    const { data: subscription, error: subError } = await supabase
      .from('subscriptions')
      .insert({
        user_id: profile.id,
        tier: 'premium',
        provider: provider,
        start_date: new Date().toISOString(),
        end_date: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toISOString(),
        payment_status: 'pending',
        auto_renew: true,
      })
      .select()
      .single();

    if (subError) throw subError;

    // Initiate payment with provider
    let paymentResult;
    if (provider === 'mtn_momo') {
      paymentResult = await initiateMTNMoMo(phoneNumber, amount, currency);
    } else if (provider === 'airtel_money') {
      paymentResult = await initiateAirtelMoney(phoneNumber, amount, currency);
    } else {
      return new Response(
        JSON.stringify({ error: 'Unsupported provider' }),
        { status: 400, headers: { 'Content-Type': 'application/json' } }
      );
    }

    // Update subscription with transaction ID
    await supabase
      .from('subscriptions')
      .update({ provider_subscription_id: paymentResult.transactionId })
      .eq('id', subscription.id);

    return new Response(
      JSON.stringify({
        success: true,
        transactionId: paymentResult.transactionId,
        status: paymentResult.status,
        message: 'Payment initiated. Please check your phone to confirm.',
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

async function initiateMTNMoMo(phoneNumber: string, amount: number, currency: string) {
  // TODO: Integrate with MTN MoMo API
  // This is a placeholder — replace with actual API call
  const transactionId = `MTN-${Date.now()}`;

  // Simulate API call
  const response = await fetch('https://api.mtn.com/v1/collections/requesttopay', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${MTN_MOMO_API_KEY}`,
    },
    body: JSON.stringify({
      amount: amount.toString(),
      currency,
      externalId: transactionId,
      payer: {
        partyIdType: 'MSISDN',
        partyId: phoneNumber,
      },
      payerMessage: 'DAKIKA Premium Subscription',
      payeeNote: 'DAKIKA Premium',
    }),
  });

  if (!response.ok) {
    throw new Error(`MTN MoMo API error: ${response.status}`);
  }

  return { transactionId, status: 'pending' };
}

async function initiateAirtelMoney(phoneNumber: string, amount: number, currency: string) {
  // TODO: Integrate with Airtel Money API
  // This is a placeholder — replace with actual API call
  const transactionId = `AIRTEL-${Date.now()}`;

  // Simulate API call
  const response = await fetch('https://api.airtel.africa/merchant/v1/payments', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${AIRTEL_MONEY_API_KEY}`,
    },
    body: JSON.stringify({
      reference: 'DAKIKA Premium',
      subscriber: {
        country: 'RW',
        currency,
        msisdn: phoneNumber,
      },
      transaction: {
        amount: amount.toString(),
        id: transactionId,
        status: 'pending',
      },
    }),
  });

  if (!response.ok) {
    throw new Error(`Airtel Money API error: ${response.status}`);
  }

  return { transactionId, status: 'pending' };
}
