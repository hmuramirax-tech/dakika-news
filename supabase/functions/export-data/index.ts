// Supabase Edge Function: Data Export
// Exports analytics data in CSV format for admin reporting

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
    const { startDate, endDate, dataType } = await req.json();

    if (!startDate || !endDate || !dataType) {
      return new Response(
        JSON.stringify({ error: 'Missing required fields: startDate, endDate, dataType' }),
        { status: 400, headers: { 'Content-Type': 'application/json' } }
      );
    }

    const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

    let csvContent = '';

    switch (dataType) {
      case 'articles':
        csvContent = await exportArticles(supabase, startDate, endDate);
        break;
      case 'users':
        csvContent = await exportUsers(supabase, startDate, endDate);
        break;
      case 'analytics':
        csvContent = await exportAnalytics(supabase, startDate, endDate);
        break;
      case 'subscriptions':
        csvContent = await exportSubscriptions(supabase, startDate, endDate);
        break;
      default:
        return new Response(
          JSON.stringify({ error: 'Invalid dataType' }),
          { status: 400, headers: { 'Content-Type': 'application/json' } }
        );
    }

    return new Response(csvContent, {
      status: 200,
      headers: {
        'Content-Type': 'text/csv',
        'Content-Disposition': `attachment; filename="${dataType}_${startDate}_${endDate}.csv"`,
      },
    });
  } catch (error) {
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500, headers: { 'Content-Type': 'application/json' } }
    );
  }
});

async function exportArticles(supabase: any, startDate: string, endDate: string): Promise<string> {
  const { data, error } = await supabase
    .from('articles')
    .select('id, title, source_id, status, published_at, confidence_score')
    .gte('published_at', startDate)
    .lte('published_at', endDate);

  if (error) throw error;

  const header = 'id,title,source_id,status,published_at,confidence_score\n';
  const rows = data.map((a: any) =>
    `${a.id},"${a.title.replace(/"/g, '""')}",${a.source_id},${a.status},${a.published_at},${a.confidence_score}`
  ).join('\n');

  return header + rows;
}

async function exportUsers(supabase: any, startDate: string, endDate: string): Promise<string> {
  const { data, error } = await supabase
    .from('profiles')
    .select('id, phone, display_name, language, subscription_tier, created_at')
    .gte('created_at', startDate)
    .lte('created_at', endDate);

  if (error) throw error;

  const header = 'id,phone,display_name,language,subscription_tier,created_at\n';
  const rows = data.map((u: any) =>
    `${u.id},${u.phone},${u.display_name},${u.language},${u.subscription_tier},${u.created_at}`
  ).join('\n');

  return header + rows;
}

async function exportAnalytics(supabase: any, startDate: string, endDate: string): Promise<string> {
  const { data, error } = await supabase
    .from('analytics_events')
    .select('id, user_id, event_name, event_data, created_at')
    .gte('created_at', startDate)
    .lte('created_at', endDate);

  if (error) throw error;

  const header = 'id,user_id,event_name,event_data,created_at\n';
  const rows = data.map((e: any) =>
    `${e.id},${e.user_id},${e.event_name},"${JSON.stringify(e.event_data).replace(/"/g, '""')}",${e.created_at}`
  ).join('\n');

  return header + rows;
}

async function exportSubscriptions(supabase: any, startDate: string, endDate: string): Promise<string> {
  const { data, error } = await supabase
    .from('subscriptions')
    .select('id, user_id, tier, provider, payment_status, start_date, end_date')
    .gte('start_date', startDate)
    .lte('start_date', endDate);

  if (error) throw error;

  const header = 'id,user_id,tier,provider,payment_status,start_date,end_date\n';
  const rows = data.map((s: any) =>
    `${s.id},${s.user_id},${s.tier},${s.provider},${s.payment_status},${s.start_date},${s.end_date}`
  ).join('\n');

  return header + rows;
}
