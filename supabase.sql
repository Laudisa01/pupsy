-- Pupsy Web – Backend für Supabase
-- Im Supabase Dashboard → SQL Editor einmal komplett ausführen.

-- Eine Zeile pro Person: Profil, eigene Fürze (ohne Audio), Swipes, Duell- und Turnierstimmen.
create table if not exists public.pupsy_users (
  id         uuid primary key references auth.users(id) on delete cascade,
  doc        jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now(),
  constraint pupsy_users_doc_size check (pg_column_size(doc) < 400000)
);

-- Audio als Base64 (8 kHz, μ-law, max. 15 s ≈ 160 KB).
create table if not exists public.pupsy_audio (
  id         text primary key check (char_length(id) between 4 and 40),
  owner      uuid not null references auth.users(id) on delete cascade,
  d          text not null check (char_length(d) <= 200000),
  created_at timestamptz not null default now()
);
create index if not exists pupsy_audio_owner_idx on public.pupsy_audio (owner);

alter table public.pupsy_users enable row level security;
alter table public.pupsy_audio enable row level security;

-- Alle (auch Gäste) dürfen lesen und hören; schreiben nur die eigene Zeile.
drop policy if exists "pupsy_users_read"   on public.pupsy_users;
drop policy if exists "pupsy_users_insert" on public.pupsy_users;
drop policy if exists "pupsy_users_update" on public.pupsy_users;
drop policy if exists "pupsy_users_delete" on public.pupsy_users;
create policy "pupsy_users_read"   on public.pupsy_users for select to anon, authenticated using (true);
create policy "pupsy_users_insert" on public.pupsy_users for insert to authenticated with check (id = auth.uid());
create policy "pupsy_users_update" on public.pupsy_users for update to authenticated using (id = auth.uid()) with check (id = auth.uid());
create policy "pupsy_users_delete" on public.pupsy_users for delete to authenticated using (id = auth.uid());

drop policy if exists "pupsy_audio_read"   on public.pupsy_audio;
drop policy if exists "pupsy_audio_insert" on public.pupsy_audio;
drop policy if exists "pupsy_audio_update" on public.pupsy_audio;
drop policy if exists "pupsy_audio_delete" on public.pupsy_audio;
create policy "pupsy_audio_read"   on public.pupsy_audio for select to anon, authenticated using (true);
create policy "pupsy_audio_insert" on public.pupsy_audio for insert to authenticated with check (owner = auth.uid());
create policy "pupsy_audio_update" on public.pupsy_audio for update to authenticated using (owner = auth.uid()) with check (owner = auth.uid());
create policy "pupsy_audio_delete" on public.pupsy_audio for delete to authenticated using (owner = auth.uid());

-- Live-Updates, damit neue Fürze und Stimmen sofort bei allen ankommen.
do $$ begin
  alter publication supabase_realtime add table public.pupsy_users;
exception when duplicate_object then null; end $$;

-- Moderation: einen gemeldeten Pups entfernen (als Admin im SQL Editor):
--   update public.pupsy_users set doc = doc #- '{farts,<PUPS-ID>}' where id = '<USER-ID>';
--   delete from public.pupsy_audio where id = '<PUPS-ID>';
