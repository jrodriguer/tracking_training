# Copilot Instructions

## Source of Truth

Before making changes, review these files in order:

1. [tracking_training_flutter/README.md](../tracking_training_flutter/README.md)
2. [tracking_training_flutter/docs/implementation_handoff.md](../tracking_training_flutter/docs/implementation_handoff.md)
3. [tracking_training_server/README.md](../tracking_training_server/README.md)
4. [tracking_training_client/README.md](../tracking_training_client/README.md)

If instructions conflict, follow this precedence:

1. `tracking_training_flutter/docs/implementation_handoff.md`
2. `tracking_training_flutter/README.md`
3. `tracking_training_server/README.md`
4. `tracking_training_client/README.md`

## Project Context

- This repository is a Serverpod workspace with three active packages:
	- `tracking_training_flutter/` for the Flutter app UI.
	- `tracking_training_server/` for the Serverpod backend.
	- `tracking_training_client/` for the generated Serverpod client.
- MVP scope and delivery phases for the product are defined in
	`tracking_training_flutter/docs/implementation_handoff.md`.
- Flutter app code lives under `tracking_training_flutter/lib/features/` and
	`tracking_training_flutter/lib/shared/`.
- Server changes often require coordinated updates across server, client, and
	Flutter app layers.

## Implementation Guidelines

- Keep solutions aligned with the approved MVP scope.
- Prefer small, incremental changes that preserve current architecture.
- Keep routine templates separate from workout history data.
- For auth, implement UI scaffolding and local fake auth only unless asked otherwise.
- Prefer editing Serverpod source definitions and server logic instead of hand-editing
	generated protocol output.
- When changing Serverpod protocols, endpoints, or serializable models, regenerate
	the project artifacts before finishing.
- Treat generated code in `tracking_training_client/lib/src/protocol/` and generated
	server output under `tracking_training_server/lib/src/` as derived artifacts.
- Keep Flutter, server, and generated client APIs in sync.

## Validation Expectations

- For Flutter app changes, run validation from the repository root:
	- `flutter pub get`
	- `flutter analyze`
	- `flutter test`
- For Serverpod server changes, run validation in `tracking_training_server/`:
	- `dart pub get`
	- `serverpod generate` when schema or protocol changes
	- `dart analyze --fatal-infos`
	- `dart format --set-exit-if-changed .`
	- `dart test`
- If server tests require infrastructure, use `docker compose up -d` in
	`tracking_training_server/` before running them.

## CI Workflows

- `.github/workflows/flutter_ci.yml` validates the Flutter app.
- `.github/workflows/analyze.yml` analyzes the Serverpod server package.
- `.github/workflows/format.yml` checks Serverpod server formatting.
- `.github/workflows/tests.yml` runs Serverpod generation and server tests.

## Quality Expectations

- Add or update tests when behavior changes.
- Keep code readable and maintainable; avoid unnecessary abstractions.
- Document user-visible behavior or setup changes in the relevant package README when relevant.

## Commit Message Notes

Use concise commit titles that clearly summarize the change.
