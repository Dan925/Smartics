-- Events are the core of the activity feed.
-- One row per event. Append-only. Pruned by retention job.

CREATE TABLE IF NOT EXISTS events (
    id          TEXT PRIMARY KEY,                              -- ULID, generated at the ingest API
    tenant_id   TEXT NOT NULL REFERENCES tenants(id),
    user_id     TEXT NOT NULL,                                 -- arbitrary client-defined string
    event       TEXT NOT NULL,                                 -- snake_case event name
    properties  JSONB NOT NULL DEFAULT '{}'::jsonb,
    timestamp   TIMESTAMPTZ NOT NULL,                          -- client-reported time
    received_at TIMESTAMPTZ NOT NULL,                          -- server-stamped, authoritative
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_events_tenant
    ON events (tenant_id, received_at DESC);

CREATE INDEX IF NOT EXISTS idx_events_user
    ON events (tenant_id, user_id, received_at DESC);
