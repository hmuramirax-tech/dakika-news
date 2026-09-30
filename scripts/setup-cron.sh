#!/bin/bash
# Set up Supabase cron jobs for scheduled tasks
# Run this in Supabase SQL Editor, not as a bash script

echo "Run this SQL in your Supabase SQL Editor:"
echo ""
cat << 'SQL'
-- Ingest articles every 30 minutes
select cron.schedule(
  'ingest',
  '*/30 * * * *',
  $$ select net.http_post(
    'https://your-project.supabase.co/functions/v1/scheduled-tasks',
    '{"task": "ingest"}',
    'application/json'
  ) $$
);

-- Summarize pending articles every 15 minutes
select cron.schedule(
  'summarize',
  '*/15 * * * *',
  $$ select net.http_post(
    'https://your-project.supabase.co/functions/v1/scheduled-tasks',
    '{"task": "summarize"}',
    'application/json'
  ) $$
);

-- Generate morning digest at 6:00 AM CAT
select cron.schedule(
  'digest-morning',
  '0 6 * * *',
  $$ select net.http_post(
    'https://your-project.supabase.co/functions/v1/scheduled-tasks',
    '{"task": "digest"}',
    'application/json'
  ) $$
);

-- Generate afternoon digest at 12:00 PM CAT
select cron.schedule(
  'digest-afternoon',
  '0 12 * * *',
  $$ select net.http_post(
    'https://your-project.supabase.co/functions/v1/scheduled-tasks',
    '{"task": "digest"}',
    'application/json'
  ) $$
);

-- Generate evening digest at 6:00 PM CAT
select cron.schedule(
  'digest-evening',
  '0 18 * * *',
  $$ select net.http_post(
    'https://your-project.supabase.co/functions/v1/scheduled-tasks',
    '{"task": "digest"}',
    'application/json'
  ) $$
);

-- Cleanup old data at 2:00 AM
select cron.schedule(
  'cleanup',
  '0 2 * * *',
  $$ select net.http_post(
    'https://your-project.supabase.co/functions/v1-scheduled-tasks',
    '{"task": "cleanup"}',
    'application/json'
  ) $$
);
SQL
