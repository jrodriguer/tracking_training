---
description: "Use when reviewing, writing, or editing GitHub Actions workflow YAML files. Covers CI correctness, secret handling, job dependencies, and parity with local validated commands."
applyTo: ".github/workflows/*.yml"
---
# GitHub Actions Workflow Review Rules

## Parity with Validated Local Commands
- Workflow steps must mirror the validated local commands documented in `.github/copilot-instructions.md`.
- Flutter CI must run (in order): `flutter pub get`, `flutter analyze`, `flutter test` — all from within `tracking_training_flutter/`.
- Server CI must run: `dart pub get`, `serverpod generate`, `dart analyze --fatal-infos`, `dart format --set-exit-if-changed .` — from within `tracking_training_server/`.
- Server test jobs must start Docker services (Postgres + Redis via `docker compose up`) before running `dart test`, and stop them after.

## Working Directory Discipline
- Always set `working-directory` explicitly on steps that run package-local commands — never rely on the default repo root when the command is package-scoped.
- When a step sets `working-directory`, every subsequent dependent step in that job must do the same or use an absolute path.

## Secrets & Credentials
- Never hardcode secrets, tokens, API keys, or passwords in workflow YAML.
- Use `${{ secrets.SECRET_NAME }}` for all sensitive values; document required secret names in the workflow file's top-level comment.
- Do not echo or print secret values in `run` steps — mask them with `::add-mask::` if dynamically computed.
- `passwords.yaml` content required for server startup must be injected from secrets, not committed.

## Job Structure & Dependencies
- Jobs that can run independently (Flutter analyze vs. server analyze) must be separate jobs to enable parallelism.
- Use `needs:` to express explicit dependencies between jobs; do not rely on implicit ordering.
- Integration test jobs that require Docker must declare `services:` or use a `docker compose` step before the test step.

## Toolchain Versions
- Pin Flutter and Dart SDK versions to match the validated toolchain: Flutter `^3.32.0`, Dart `>=3.9.0 <4.0.0`, Serverpod CLI `3.4.5`.
- Use `actions/setup-java` or `subosito/flutter-action` with explicit version tags — avoid `latest` to prevent surprise breakage.

## Reliability
- Add `--fatal-infos` to `dart analyze` steps to catch info-level issues in CI.
- Use `--set-exit-if-changed` on `dart format` steps so unformatted code fails the build.
- Add `--quiet-pull` to `docker compose up` to reduce log noise without hiding real errors.
- Do not use `continue-on-error: true` on steps that gate correctness (analysis, tests).
