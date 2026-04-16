# tracking_training

Flutter app for tracking gym routines, workout sessions, and exercise progress
across iOS, Android, and web.

## Status

The approved MVP scope and implementation guidance are documented in
[docs/implementation_handoff.md](docs/implementation_handoff.md).

## MVP Goals

- Editable weekly routine split by training day.
- Workout logging with reps, weight, and notes.
- Progress history using compact tables and simple charts.
- Email login and registration screens as UI-only scaffolding.

## CI

Every push and pull request targeting `main` runs the workspace workflows in
`../.github/workflows/`.

Flutter app changes are validated by `../.github/workflows/flutter_ci.yml`, which:

1. Installs Flutter (stable channel).
2. Runs `flutter pub get`.
3. Runs `flutter analyze` — must pass with no issues.
4. Runs `flutter test` — all tests must pass.

Serverpod backend changes are validated separately by:

1. `../.github/workflows/analyze.yml` for `dart analyze --fatal-infos` in `tracking_training_server/`.
2. `../.github/workflows/format.yml` for `dart format --set-exit-if-changed` in `tracking_training_server/`.
3. `../.github/workflows/tests.yml` for Docker-backed server tests, including `serverpod generate` and `dart test` in `tracking_training_server/`.

If you change shared API contracts, endpoints, or models, expect both the
Flutter app flow and the Serverpod server workflows to matter for the branch.

## Contributing

1. Branch off `main` with a descriptive branch name.
2. Open a pull request. The PR template (`../.github/PULL_REQUEST_TEMPLATE.md`)
   will prompt you for a summary, list of changes, and test evidence.
3. Ensure CI is green before requesting a review.

## Getting Started

For Flutter setup and local development, see the official documentation:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Flutter documentation](https://docs.flutter.dev/)

For Serverpod-specific local development and backend commands, see
[../tracking_training_server/README.md](../tracking_training_server/README.md).
