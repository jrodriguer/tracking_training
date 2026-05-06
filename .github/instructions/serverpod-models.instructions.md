---
description: "Use when reviewing, writing, or editing Serverpod model definition files (.spy.yaml). Covers naming conventions, field types, relations, serialization, and the generate-first workflow."
applyTo: "**/*.spy.yaml"
---
# Serverpod Model (.spy.yaml) Review Rules

## Generate-First Workflow
- `.spy.yaml` files are the single source of truth for all Serverpod models, endpoints, and serializable types.
- After any change to a `.spy.yaml` file, always run `serverpod generate` from `tracking_training_server/` before analyzing or testing.
- Never hand-edit generated artifacts under `lib/src/generated/` or `tracking_training_client/lib/src/protocol/`.

## Naming Conventions
- Model class names: `PascalCase` (e.g., `WorkoutSession`, `RoutineTemplate`).
- Field names: `camelCase`.
- Table names (for persistent models): `snake_case`, singular noun (e.g., `workout_session`).
- Endpoint class names: `PascalCase` ending in `Endpoint` (e.g., `WorkoutsEndpoint`).

## Field Definitions
- Always explicitly specify the Dart type for every field — avoid relying on inference where Serverpod supports explicit typing.
- Mark nullable fields with `?` only when absence is semantically valid; prefer non-null with a default over nullable for required data.
- Use `int` for surrogate primary keys; do not use `String` UUIDs unless the product requires it.
- Timestamps must use `DateTime` (Serverpod serializes these correctly); do not use raw `int` epoch values.

## Relations & Ownership
- Foreign key fields referencing a `userId` must be present on every user-owned model (routines, workouts).
- One-to-many relations must declare the parent `id` field as a non-nullable FK on the child model.
- Do not create circular relations between the routine and workout domains.

## Security
- Endpoint method definitions must not expose admin or cross-user data through generated client methods without a corresponding server-side authorization check.
- Do not define fields that store plaintext passwords, tokens, or secrets in persistent models.

## Domain Boundaries
- Routine-domain models live under `tracking_training_server/lib/src/routines/`.
- Workout-domain models live under `tracking_training_server/lib/src/workouts/`.
- Shared or auth models belong in their own namespace — do not mix domains in one `.spy.yaml` file.

## Migrations
- Every structural change to a persistent model (add/remove/rename field, change type) requires a new Serverpod migration.
- Migrations are generated via `serverpod generate` and must be committed alongside the `.spy.yaml` change.
- Renaming a field is a breaking change — coordinate with any in-flight client code before merging.
