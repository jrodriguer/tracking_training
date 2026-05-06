---
description: "Use when reviewing, writing, or editing Flutter UI Dart code in the tracking_training_flutter package. Covers Riverpod state management, GoRouter navigation, widget composition, and Flutter best practices."
applyTo: "tracking_training_flutter/lib/**/*.dart"
---
# Flutter Dart Code Review Rules

## Architecture & Domain Boundaries
- Enforce the feature slice layout: `auth`, `progress`, `routines`, `workouts` under `lib/features/`; shared reusables under `lib/shared/`; app bootstrap under `lib/app/`.
- Routine templates and workout history are separate data sets — do not merge their models, providers, or screens.
- Never import a feature slice from another feature slice directly; route through shared/ or via GoRouter navigation.

## State Management (Riverpod)
- Providers must be defined at top-level or in a dedicated providers file — never inside widget build methods.
- Prefer `AsyncNotifierProvider` / `NotifierProvider` for mutable async state over raw `StateProvider` for complex state.
- Watch providers with `ref.watch`; use `ref.read` only inside callbacks and methods, never in `build`.
- Dispose resources in `ref.onDispose` for providers that hold subscriptions or controllers.
- Flag unused providers or providers duplicating state that already exists elsewhere.

## Navigation (GoRouter)
- All protected routes must redirect unauthenticated users; route guards live in `lib/app/router.dart`.
- Do not navigate imperatively with `Navigator.push` inside features — use GoRouter named routes.
- New routes must be added to the centralized router definition, not scattered across widgets.

## Widget Composition
- Keep `build` methods small; extract sub-widgets or builder methods when a widget exceeds ~80 lines.
- Avoid business logic in widget classes — delegate to providers or use cases.
- Do not call async functions fire-and-forget inside `build`; use `ref.listen` or trigger from callbacks.
- Prefer `const` constructors wherever possible.

## Security
- Do not log or print sensitive user data (tokens, emails, passwords) in any widget or callback.
- Auth state reads must go through the `authServiceProvider`; never read raw Serverpod session objects in UI code.

## Error Handling
- Every `AsyncValue` from a provider must handle the `.error` state explicitly in the UI — no silent failures.
- User-facing error messages must be descriptive and not expose internal stack traces.

## Naming
- Widget classes: `PascalCase`. Providers: `camelCase` ending in `Provider`. Routes: `camelCase` or `kebab-case` path segments.
- Screen widgets end in `Screen`; reusable components end in `Widget` or a domain noun.

## Testing
- New screens and non-trivial widgets require widget tests under `tracking_training_flutter/test/`.
- Mock providers using `ProviderContainer` with overrides — do not rely on real Serverpod connections in widget tests.
