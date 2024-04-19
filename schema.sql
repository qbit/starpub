CREATE EXTENSION IF NOT EXISTS pg_trgm;

CREATE EXTENSION IF NOT EXISTS pgcrypto;

DROP Table if exists entry_categories;
drop table if exists categories;
drop table if exists entries;
drop table if exists users;

CREATE TABLE users (
    id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    uid UUID NOT NULL DEFAULT gen_random_uuid() UNIQUE,
    created_at timestamp NOT NULL DEFAULT NOW(),
    updated_at timestamp,
    real_name text NOT NULL,
    username text NOT NULL UNIQUE,
    hash text NOT NULL,
    email text NOT NULL,
    pubkey jsonb NOT NULL
);

CREATE TABLE categories (
    id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    user_id INTEGER NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    created_at timestamp NOT NULL DEFAULT NOW(),
    updated_at timestamp,
    name text NOT NULL,
    descr text NOT NULL
);

CREATE TABLE entries (
    id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    user_id INTEGER NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    pubic bool DEFAULT TRUE,
    created_at timestamp NOT NULL DEFAULT NOW(),
    updated_at timestamp,
    title text NOT NULL DEFAULT '',
    descr text NOT NULL DEFAULT '',
    signature text NOT NULL
);

CREATE TABLE entry_categories (
    user_id INTEGER NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    entry_id INTEGER NOT NULL REFERENCES entries (id) ON DELETE CASCADE,
    category_id INTEGER NOT NULL REFERENCES categories (id) ON DELETE CASCADE
);

CREATE INDEX entry_trgm_idx ON entries USING gist (title, descr gist_trgm_ops);
