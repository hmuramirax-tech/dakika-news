#!/bin/bash
# Set Supabase Edge Function secrets
# Usage: ./scripts/setup-secrets.sh

set -e

echo "Setting Supabase secrets..."

# Required secrets
read -p "OpenAI API Key: " OPENAI_API_KEY
read -p "Flutterwave Secret Key: " FLUTTERWAVE_SECRET_KEY
read -p "FCM Server Key: " FCM_SERVER_KEY

supabase secrets set \
  OPENAI_API_KEY="$OPENAI_API_KEY" \
  FLUTTERWAVE_SECRET_KEY="$FLUTTERWAVE_SECRET_KEY" \
  FCM_SERVER_KEY="$FCM_SERVER_KEY"

echo "Secrets set successfully!"
