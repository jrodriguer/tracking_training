# tracking_training

Flutter app for tracking gym routines, workout sessions, and exercise progress
across iOS, Android, and web.

## Status

The approved MVP scope and implementation guidance are documented in
[tracking_training_flutter/docs/implementation_handoff.md](tracking_training_flutter/docs/implementation_handoff.md).

## MVP Goals

- Editable weekly routine split by training day.
- Workout logging with reps, weight, and notes.
- Progress history using compact tables and simple charts.
- Email login and registration screens as UI-only scaffolding.

## CI

Every push and pull request targeting `main` runs the Flutter CI workflow
(`.github/workflows/flutter_ci.yml`), which:

1. Installs Flutter (stable channel).
2. Runs `flutter pub get`.
3. Runs `flutter analyze` — must pass with no issues.
4. Runs `flutter test` — all tests must pass.

## Contributing

1. Branch off `main` with a descriptive branch name.
2. Open a pull request. The PR template (`.github/PULL_REQUEST_TEMPLATE.md`)
   will prompt you for a summary, list of changes, and test evidence.
3. Ensure CI is green before requesting a review.

### PR Automation Prompt

The PR automation prompt at `.github/prompts/pr-generation.prompt.md` is aligned
to this repository workflow:

1. Prepare a concise commit message that summarizes your change.
2. Use `report_progress` to commit, push, and update the PR checklist.
3. Keep the PR open for human review (no auto-merge or branch deletion).

## Getting Started

For Flutter setup and local development, see the official documentation:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Flutter documentation](https://docs.flutter.dev/)
