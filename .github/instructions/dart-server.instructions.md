---
description: "Use when reviewing, writing, or editing Serverpod backend Dart code in the tracking_training_server package. Covers endpoint logic, auth, authorization, input validation, Postgres data access, and secret handling."
applyTo: "tracking_training_server/lib/src/**/*.dart"
---
# Serverpod Server Dart Code Review Rules

## Generated Code Boundary
- Never hand-edit files under `lib/src/generated/` or `tracking_training_client/lib/src/protocol/`.
- All model and endpoint changes must originate in `.spy.yaml` source files; regenerate with `serverpod generate` from `tracking_training_server/`.

## Authorization
- Every endpoint method must verify the caller is authenticated before accessing data. Use `session.auth.authenticatedUserId` and reject if null.
- Enforce ownership checks: users may only read or modify their own routines and workouts. A missing ownership check is a critical security defect.
- Do not rely on client-supplied IDs as authorization proof — always re-fetch from the DB and compare `userId`.

## Input Validation
- Validate and sanitize all endpoint parameters at the boundary before any DB or business logic call.
- Reject null, empty, or out-of-range values with a structured `EndpointDispatchException` or equivalent, not a silent null return.
- String inputs used in queries must pass through Serverpod's ORM — never concatenate raw SQL strings.

## Data Access
- Use Serverpod's generated ORM expressions for all queries; never write raw SQL unless absolutely unavoidable and reviewed separately.
- Prefer transactions when multiple related rows must be written atomically.
- Do not expose internal DB row IDs to the client beyond what the generated protocol already exposes.

## Auth & Secrets
- Passwords, tokens, and pepper values must come from `config/passwords.yaml` or environment injection — never hardcoded.
- Verify `emailSecretHashPepper`, `jwtHmacSha512PrivateKey`, and `jwtRefreshTokenHashPepper` are loaded at startup; fail fast if missing.
- Never log token values, raw passwords, or JWTs, even at debug level.

## Error Handling & Logging
- Use structured Serverpod logging (`session.log`) with appropriate log levels; prefer `LogLevel.warning` or `LogLevel.error` for actionable failures.
- Do not swallow exceptions silently — log with context and re-throw or map to a user-facing error.
- Return typed error responses rather than raw exception strings to the client.

## Domain Boundaries
- Routine templates and workout history are separate domain objects; do not share tables or merge endpoint logic between them.
- Endpoint classes should stay focused: one endpoint class per domain entity.

## Testing
- New or modified endpoint logic requires integration tests under `tracking_training_server/test/integration/`.
- Tests must use a real Postgres/Redis container (via `docker compose`); do not mock the DB in integration tests.
- Use `withServerpod` test helper for session-scoped endpoint calls.
