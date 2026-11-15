-- NEXORA demo schema only. This schema stores simulated calculations,
-- not deposits, private keys, collateral custody, or real loan contracts.

create table if not exists public.loan_simulations (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  collateral_asset text not null check (collateral_asset in ('BTC', 'ETH', 'USDT')),
  collateral_quantity numeric(30, 12) not null check (collateral_quantity > 0),
  illustrative_asset_price_usd numeric(20, 8) not null check (illustrative_asset_price_usd > 0),
  collateral_value_usd numeric(20, 8) not null check (collateral_value_usd > 0),
  ltv_percent numeric(5, 2) not null check (ltv_percent between 10 and 70),
  principal_usdt numeric(20, 8) not null check (principal_usdt > 0),
  illustrative_apr_percent numeric(5, 2) not null check (illustrative_apr_percent between 4 and 24),
  term_days integer not null check (term_days in (30, 90, 180)),
  estimated_interest_usdt numeric(20, 8) not null check (estimated_interest_usdt >= 0),
  estimated_total_due_usdt numeric(20, 8) not null check (estimated_total_due_usdt >= principal_usdt),
  calculation_version text not null default 'demo-v1',
  created_at timestamptz not null default now()
);

create index if not exists loan_simulations_user_created_idx
  on public.loan_simulations (user_id, created_at desc);

alter table public.loan_simulations enable row level security;

create policy "Users can read their own simulations"
  on public.loan_simulations for select
  using (auth.uid() = user_id);

create policy "Users can create their own simulations"
  on public.loan_simulations for insert
  with check (auth.uid() = user_id);

create policy "Users can delete their own simulations"
  on public.loan_simulations for delete
  using (auth.uid() = user_id);

-- Intentionally no public update policy. Simulation records are immutable
-- in this first backend iteration. Do not add service-role keys to the app.
