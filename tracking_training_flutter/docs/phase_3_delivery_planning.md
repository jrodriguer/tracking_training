# Phase 3 Delivery Planning: Workout Logging

## Objective

Deliver the Workout Logging phase so users can create a session from a
selected routine day, choose the workout date independently from when they log
it, edit or remove saved sessions, and persist session history without
mutating routine templates.

This plan is aligned with the approved MVP in
[implementation_handoff.md](implementation_handoff.md).

## In Scope

- Create a workout session from a routine day.
- Capture user-selected session dates for current or previous workouts.
- Record exercise entries with reps, weight, and notes.
- Edit saved workout sessions.
- Remove saved workout sessions.
- Persist session history as standalone records.
- Keep routine templates and workout history separate.
- Provide basic session history list for validation and flow confidence.

## Out of Scope

- Cloud sync.
- Real-time collaboration.
- Advanced analytics (handled in Phase 4).
- Real backend auth.

## Current Baseline

- `routines` feature is functional with seeded routine, editing, and reordering.
- `workouts` feature currently shows a placeholder page.
- Routing already includes `/workouts`.
- No persistence layer for workout sessions yet.

## Delivery Strategy

Use incremental vertical slices to reduce risk:

1. Build domain and state contracts first.
2. Add local persistence and repository wiring.
3. Add workout logging UI and session management lifecycle.
4. Add history read-back UI and test coverage.
5. Validate separation rules and edge cases.

## Work Breakdown Structure

### Milestone 1: Domain and Contracts

Deliverables:

- Workout entities in `features/workouts/domain/`:
  - `WorkoutSession`
  - `WorkoutEntry`
  - Optional `WorkoutSet` (or flatten set-level fields into entries)
- Clear IDs and timestamps for all persisted entities.
- Separation rule documented in code comments and tests:
  - Routine templates are read-only inputs to session creation.

Exit criteria:

- Model API compiles and supports MVP fields.
- Unit tests validate model creation and copy/update behavior.

### Milestone 2: Local Persistence

Deliverables:

- Storage schema for sessions and entries in shared data layer.
- Repository interface + implementation for:
  - Create session from routine day snapshot.
  - Update session date and entry data.
  - Delete saved sessions.
  - List sessions and session details.
- Transaction-safe writes for session + entries.

Exit criteria:

- Session save/read works end-to-end in local storage.
- Updating routine data after logging does not alter saved sessions.

### Milestone 3: Session Logging Flow

Deliverables:

- Replace placeholder `workouts_page.dart` with:
  - Routine day picker or "Log session" from selected day.
  - User-editable workout date field.
  - Exercise logging form rows (reps, weight, notes).
  - Save/complete session action.
  - Edit and delete actions for saved sessions.
- Riverpod controller(s) for draft session state and persistence.
- Input validation and user feedback for invalid values.

Exit criteria:

- User can complete full logging flow in app.
- User can correct or remove a saved historical session.
- Data is persisted and visible after app restart.

### Milestone 4: Session History Surface

Deliverables:

- Session history list view with date and routine day context.
- Session detail view with logged entries.
- Entry points to edit or remove an existing session.
- Minimal filtering (most recent first) to keep reads fast and simple.

Exit criteria:

- User can verify previous logged sessions from the app UI.
- History display proves data persistence and template/history separation.

### Milestone 5: Quality Gates

Deliverables:

- Tests:
  - Unit tests for controller/repository session creation, updates, and
    deletion.
  - Regression test for logging a session after its workout date.
  - Regression test for non-mutation of routine templates.
  - Widget test for core workout flow navigation and save.
- Validation runs:
  - `flutter analyze`
  - `flutter test`

Exit criteria:

- Tests pass and cover core Phase 3 behaviors.
- No analyzer issues introduced by Phase 3 changes.

## Suggested File-Level Implementation Targets

- `lib/features/workouts/domain/`:
  - `workout_models.dart`
- `lib/features/workouts/application/`:
  - `workout_session_controller.dart`
  - `workout_history_controller.dart` (optional split)
- `lib/features/workouts/data/`:
  - `workout_repository.dart`
  - `local_workout_repository.dart`
- `lib/features/workouts/presentation/`:
  - `workouts_page.dart`
  - `widgets/session_editor.dart`
  - `widgets/session_history_list.dart`
- `lib/shared/data/`:
  - local storage schema/adapters as needed for MVP
- `test/features/workouts/`:
  - controller and repository unit tests
  - widget flow tests

## Dependency Sequencing

1. Domain models
2. Repository contracts
3. Persistence implementation
4. Controllers/state
5. UI composition
6. Tests and cleanup

Keep this order to avoid UI rework caused by unstable contracts.

## Risk Register

- Risk: Persistence complexity delays UI.
  - Mitigation: Keep schema minimal; defer non-essential fields.
- Risk: Session/routine coupling causes accidental mutation.
  - Mitigation: Snapshot day/exercise identity during session creation and test it.
- Risk: Editing history accidentally changes immutable session context.
  - Mitigation: Restrict editable fields to session-owned data and cover with tests.
- Risk: Form UX becomes slow on mobile.
  - Mitigation: Keep fields compact and avoid deep modal stacks.
- Risk: Scope creep into Phase 4 analytics.
  - Mitigation: Limit Phase 3 to logging + basic history verification.

## Definition of Done for Phase 3

Phase 3 is done when all are true:

1. User can create a workout session from a routine day for the current day or
  a previous date.
2. User can record reps, weight, and notes per exercise.
3. User can edit or remove a saved workout session.
4. Session history persists locally and survives restarts.
5. Routine template edits do not rewrite historical session data.
6. Analyzer and tests pass for the new changes.

## Execution Checklist

- [ ] Add workout domain models.
- [ ] Add repository interfaces and local implementation.
- [ ] Add session logging controllers.
- [ ] Add session edit and delete flows.
- [ ] Build workout logging UI.
- [ ] Build session history UI.
- [ ] Add tests for model/controller/repository/widget flow.
- [ ] Run `flutter analyze`.
- [ ] Run `flutter test`.
