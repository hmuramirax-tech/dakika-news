// Supabase Edge Function: User Management
// Admin endpoint for managing users, viewing stats, and updating roles

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
    const action = url.searchParams.get('action') || 'list';

    const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

    switch (action) {
      case 'list':
        return await listUsers(supabase, url);
      case 'stats':
        return await getUserStats(supabase);
      case 'update':
        return await updateUser(supabase, req);
      case 'delete':
        return await deleteUser(supabase, url);
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

async function listUsers(supabase: any, url: URL) {
  const limit = parseInt(url.searchParams.get('limit') || '50');
  const offset = parseInt(url.searchParams.get('offset') || '0');
  const search = url.searchParams.get('search');

  let query = supabase
    .from('profiles')
    .select('id, phone, display_name, language, subscription_tier, created_at, last_active')
    .order('created_at', { ascending: false })
    .range(offset, offset + limit - 1);

  if (search) {
    query = query.or(`phone.ilike.%${search}%,display_name.ilike.%${search}%`);
  }

  const { data: users, error } = await query;

  if (error) throw error;

  // Get total count
  const { count } = await supabase
    .from('profiles')
    .select('id', { count: 'exact', head: true });

  return new Response(
    JSON.stringify({ success: true, users, total: count }),
    { status: 200, headers: { 'Content-Type': 'application/json' } }
  );
}

async function getUserStats(supabase: any) {
  // Total users
  const { count: totalUsers } = await supabase
    .from('profiles')
    .select('id', { count: 'exact', head: true });

  // Premium users
  const { count: premiumUsers } = await supabase
    .from('profiles')
    .select('id', { count: 'exact', head: true })
    .eq('subscription_tier', 'premium');

  // Active subscriptions
  const { count: activeSubs } = await supabase
    .from('subscriptions')
    .select('id', { count: 'exact', head: true })
    .eq('payment_status', 'active');

  // New users today
  const today = new Date().toISOString().split('T')[0];
  const { count: newToday } = await supabase
    .from('profiles')
    .select('id', { count: 'exact', head: true })
    .gte('created_at', today);

  // New users this week
  const weekAgo = new Date(Date.now() - 7 * 24 * 60 * 60 * 1000).toISOString();
  const { count: newThisWeek } = await supabase
    .from('profiles')
    .select('id', { count: 'exact', head: true })
    .gte('created_at', weekAgo);

  return new Response(
    JSON.stringify({
      success: true,
      stats: {
        totalUsers,
        premiumUsers,
        activeSubs,
        newToday,
        newThisWeek,
      },
    }),
    { status: 200, headers: { 'Content-Type': 'application/json' } }
  );
}

async function updateUser(supabase: any, req: Request) {
  const { userId, action, value } = await req.json();

  if (!userId || !action) {
    return new Response(
      JSON.stringify({ error: 'Missing required fields' }),
      { status: 400, headers: { 'Content-Type': 'application/json' } }
    );
  }

  switch (action) {
    case 'upgrade':
      await supabase
        .from('profiles')
        .update({ subscription_tier: value || 'premium' })
        .eq('id', userId);
      break;
    case 'downgrade':
      await supabase
        .from('profiles')
        .update({ subscription_tier: 'free' })
        .eq('id', userId);
      break;
    case 'update_language':
      await supabase
        .from('profiles')
        .update({ language: value })
        .eq('id', userId);
      break;
    default:
      return new Response(
        JSON.stringify({ error: 'Unknown action' }),
        { status: 400, headers: { 'Content-Type': 'application/json' } }
      );
  }

  return new Response(
    JSON.stringify({ success: true, message: 'User updated' }),
    { status: 200, headers: { 'Content-Type': 'application/json' } }
  );
}

async function deleteUser(supabase: any, url: URL) {
  const userId = url.searchParams.get('userId');

  if (!userId) {
    return new Response(
      JSON.stringify({ error: 'Missing userId' }),
      { status: 400, headers: { 'Content-Type': 'application/json' } }
    );
  }

  // Delete user profile (cascades to related tables)
  const { error } = await supabase
    .from('profiles')
    .delete()
    .eq('id', userId);

  if (error) throw error;

  return new Response(
    JSON.stringify({ success: true, message: 'User deleted' }),
    { status: 200, headers: { 'Content-Type': 'application/json' } }
  );
}
