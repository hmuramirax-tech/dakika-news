-- Referral system schema
-- Run this in Supabase SQL Editor after the main schema

-- Referrals table
create table referrals (
  id uuid primary key default uuid_generate_v4(),
  referrer_id uuid not null references profiles(id) on delete cascade,
  referred_id uuid not null references profiles(id) on delete cascade,
  status text not null default 'pending' check (status in ('pending', 'completed', 'expired')),
  reward_given boolean default false,
  reward_type text check (reward_type in ('premium_week', 'premium_month')),
  created_at timestamptz default now(),
  completed_at timestamptz,
  unique(referrer_id, referred_id)
);

-- Add referral_code to profiles
alter table profiles add column if not exists referral_code text unique;

-- Indexes
create index idx_referrals_referrer on referrals(referrer_id);
create index idx_referrals_referred on referrals(referred_id);
create index idx_referrals_status on referrals(status);

-- RLS
alter table referrals enable row level security;

create policy "Users can view own referrals"
  on referrals for select
  using (auth.uid() = referrer_id or auth.uid() = referred_id);

create policy "Users can insert referrals"
  on referrals for insert
  with check (auth.uid() = referred_id);

-- Function to complete referral and give reward
create or replace function complete_referral(referral_id uuid)
returns void as $$
declare
  referrer_uuid uuid;
  referred_uuid uuid;
begin
  -- Get referral details
  select referrer_id, referred_id into referrer_uuid, referred_uuid
  from referrals where id = referral_id;

  -- Update referral status
  update referrals set
    status = 'completed',
    reward_given = true,
    reward_type = 'premium_week',
    completed_at = now()
  where id = referral_id;

  -- Give referrer 1 week premium
  update profiles set
    subscription_tier = 'premium',
    updated_at = now()
  where id = referrer_uuid;

  -- Give referred user 1 week premium
  update profiles set
    subscription_tier = 'premium',
    updated_at = now()
  where id = referred_uuid;
end;
$$ language plpgsql;
