---
description: "Use when reviewing, writing, or editing Dart test files. Covers test structure, naming, assertions, mocking, and coverage expectations for both Flutter widget tests and Serverpod integration tests."
applyTo: "**/test/**/*.dart"
---
# Dart Test Code Review Rules

## Structure & Naming
- Group related tests with `group()`; nest groups to mirror the feature or class under test.
- Test names must describe the scenario and expected outcome: `'returns empty list when user has no routines'`, not `'test 1'`.
- Each `test` or `testWidgets` block should test exactly one behavior — split multi-assertion tests unless assertions describe a single outcome.
- Use `setUp` / `tearDown` for shared initialization and cleanup; avoid duplicating setup across tests.

## Assertions
- Prefer `package:checks` (`check(value).equals(...)`) over bare `expect` where available for richer failure output.
- Avoid `expect(result, isNotNull)` as the only assertion — also verify the shape or value of the result.
- Do not use `expect(true, true)` or other vacuous assertions that always pass.

## Flutter Widget Tests
- Pump the full widget tree only when integration behavior is under test; pump minimal subtrees for unit-style widget checks.
- Use `ProviderContainer` with overrides to inject fake state — never depend on real Serverpod sessions.
- Call `tester.pumpAndSettle()` only when animations or async gaps are actually expected; prefer `pump(Duration.zero)` for instant frame advances.
- Verify user-visible outcomes (text rendered, button enabled) rather than internal widget type counts.

## Server Integration Tests
- Integration tests require Docker (Postgres + Redis); tests that skip the DB must be clearly marked and scoped to pure logic.
- Use `withServerpod` for session-scoped endpoint calls; do not share session state across test cases.
- Clean up DB state in `tearDown` or use isolated test databases to prevent cross-test contamination.
- Test the unhappy path: missing auth, invalid input, and ownership violations, not only the happy path.

## Coverage Expectations
- All new endpoint methods require at least one integration test covering the authorized happy path.
- All new screens with non-trivial state transitions require at least one widget test.
- Bug fixes must include a regression test that would have caught the original bug.

## Do Not
- Do not commit `skip:` or `solo:` annotations except as temporary scaffolding clearly marked with a TODO.
- Do not `print` inside tests — use `addTearDown(() => ...)` to log diagnostics on failure only.
- Do not test implementation details (private methods, internal provider state) — test observable behavior.
