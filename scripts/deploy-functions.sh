#!/bin/bash
# Deploy all Supabase Edge Functions
# Usage: ./scripts/deploy-functions.sh

set -e

echo "Deploying Supabase Edge Functions..."

# Check Supabase CLI
if ! command -v supabase &> /dev/null; then
    echo "Installing Supabase CLI..."
    npm install -g supabase
fi

# Login (uncomment when ready)
# supabase login

# Link project (uncomment and set your project ref)
# supabase link --project-ref your-project-ref

# Deploy functions
echo "Deploying summarize..."
supabase functions deploy summarize

echo "Deploying ingest-rss..."
supabase functions deploy ingest-rss

echo "Deploying generate-digest..."
supabase functions deploy generate-digest

echo "Deploying send-push..."
supabase functions deploy send-push

echo "Deploying process-payment..."
supabase functions deploy process-payment

echo "Deploying payment-callback..."
supabase functions deploy payment-callback

echo "Deploying scheduled-tasks..."
supabase functions deploy scheduled-tasks

echo "All functions deployed!"
