# Smartics — Build Checkpoints

Each checkpoint is independently demoable. Complete them in order.
Resume from any checkpoint — each builds on the previous.

---

## Checkpoint 1 — Events Flow End to End
**Goal:** Prove the full pipeline works — HTTP → Kafka → PostgreSQL

What to build:
- Docker Compose with all 5 containers (api, consumer, kafka, zookeeper, postgres)
- `POST /v1/events` ingest endpoint with API key auth
- Kafka producer in the api binary
- Kafka consumer loop in the consumer binary writing to PostgreSQL
- `/v1/health` endpoint showing DB + Kafka connectivity

Demo:
- Terminal A: `curl -X POST /v1/events` with a JSON event body
- Terminal B: `watch psql -c "SELECT * FROM events ORDER BY received_at DESC LIMIT 5"`
- Events appear in PostgreSQL within milliseconds of posting

Portfolio story: Event-driven architecture, Kafka, Go, Docker, multi-service coordination

---

## Checkpoint 2 — Multi-Tenant Activity Feed
**Goal:** Prove tenant isolation and queryable feed

What to build:
- Seed 2 tenants with distinct API keys in PostgreSQL
- `GET /v1/feed` endpoint with cursor pagination (by tenant, optionally by user)
- Enforce tenant isolation at the query layer (tenant_id always scoped from API key)

Demo:
- Two terminals posting events with different API keys
- Feed endpoint showing each tenant sees only their own events
- Pagination working across multiple pages

Portfolio story: Multi-tenancy, API design, cursor pagination, data isolation

---

## Checkpoint 3 — Live Dashboard
**Goal:** Visual, browser-based demo of the full system working in real time

What to build:
- Single HTML file served by the api binary at `GET /`
- Polls `GET /v1/feed` every 3 seconds
- Displays live event stream as cards (event name, user, timestamp, properties)
- No framework — plain HTML + fetch API

Demo:
- Open browser to localhost:8080
- Post events from terminal
- Events appear in browser within 3 seconds
- Works for portfolio screen recording

Portfolio story: Full stack working together, real-time UX without complexity

---

## Checkpoint 4 — Analytics Consumer
**Goal:** Show fan-out — same Kafka events feeding two independent consumers

What to build:
- Second consumer group `smartics-analytics-writer` reading the same topic
- Aggregates event counts per (tenant_id, event_name, minute) into `analytics_summary` table
- `GET /v1/analytics/summary` endpoint returning top events + counts per minute
- Dashboard updated to show metrics panel alongside feed

Demo:
- Dashboard shows live feed (Checkpoint 3) + analytics panel side by side
- Post a burst of events — watch counts update
- Show that stopping the analytics consumer doesn't affect the feed consumer

Portfolio story: Event fan-out, analytics pipeline, multiple consumer groups, aggregation

---

## Current Status
- [ ] Checkpoint 1
- [ ] Checkpoint 2
- [ ] Checkpoint 3
- [ ] Checkpoint 4
