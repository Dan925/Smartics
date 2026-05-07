# Smartics

A multi-tenant, event-driven SaaS backend that combines a business activity feed
with a lightweight analytics pipeline. Built in Go with Apache Kafka and
PostgreSQL.

External clients post events to an HTTP ingest API. Events flow through Kafka
into PostgreSQL via independent consumer processes. A query API serves a
paginated activity feed and (later) aggregated analytics.

```
External Client
      │
      │ POST /v1/events
      ▼
┌──────────┐    produces   ┌────────┐   consumes   ┌──────────┐
│   api    │ ────────────► │ kafka  │ ──────────►  │ consumer │
│   :8080  │               │  :9092 │               │          │
└──────────┘               └────────┘               └──────────┘
      │                                                  │
      │ SELECT (read)                       INSERT (write)
      ▼                                                  ▼
┌──────────────────────────────────────────────────────────────┐
│                     postgres :5432                           │
└──────────────────────────────────────────────────────────────┘
```

## Status

Currently scaffolding. See `docs/CHECKPOINTS.md` for the four demoable
milestones. Active checkpoint:

- [ ] **Checkpoint 1** — Events flow end-to-end
- [ ] Checkpoint 2 — Multi-tenant feed
- [ ] Checkpoint 3 — Live dashboard
- [ ] Checkpoint 4 — Analytics consumer

## Quick Start (infrastructure only — for now)

```bash
cp .env.example .env
docker compose up -d
docker compose ps     # all healthy
```

Verify:

```bash
# PostgreSQL — tenants seeded via migrations
docker exec -it smartics-postgres psql -U smartics -d smartics \
  -c "SELECT id, name, api_key FROM tenants;"

# Kafka — list topics
docker exec -it smartics-kafka kafka-topics \
  --bootstrap-server localhost:9092 --list
```

The `api` and `consumer` services are commented out in `docker-compose.yml`
until their Go binaries are built (Steps 9 and 11 of the Checkpoint 1 plan).

## Repository Layout

```
cmd/                    # binary entry points (api, consumer) — built incrementally
internal/               # shared packages (event, kafka, store, middleware, config)
migrations/             # plain SQL, run by postgres on first boot
docs/                   # spec, plan, checkpoints
docker-compose.yml      # infra + (eventually) services
Dockerfile.api          # api binary image
Dockerfile.consumer     # consumer binary image
```

## Tech Stack

- **Go 1.22** — standard library + `chi` for routing, `kafka-go` for Kafka, `lib/pq` or `pgx` for PostgreSQL
- **Apache Kafka 7.5** (Confluent images) — single broker, 3 partitions, 7-day retention
- **PostgreSQL 16** — activity feed storage, 90-day retention via scheduled cleanup
- **Docker Compose** — local orchestration

## License

Personal portfolio project. No license granted.
