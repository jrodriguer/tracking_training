# Gym Tracker Implementation Handoff

## Goal

Build a local-first Flutter MVP for iOS, Android, and web that replaces
handwritten workout tables with an app for weekly routines, workout logging,
exercise notes, and easy-to-read progress views.

## Approved Scope

This MVP includes:

- A weekly routine split into editable days.
- One or more muscle groups per day.
- Routine editing for day titles, muscle-group focus, and exercises.
- Workout logging per exercise with sets, reps, weight, and notes.
- Historical progress views for each exercise using compact tables and simple
  charts.
- Cross-platform support for iOS, Android, and web.
- Email login and registration screens as UI-only scaffolding.

This MVP does not include:

- Real backend authentication.
- Cloud sync across devices.
- Push notifications.
- Advanced analytics beyond simple progress views.

## Product Requirements

### 1. Weekly Routine

The app must support a weekly routine divided into days. Each day must allow
one or more muscle groups and a list of exercises.

Seed the first routine with:

- Day 1: Chest, shoulders, and triceps.
- Day 2: Back and biceps.
- Day 3: Legs and abs.
- Day 4: Cardio.

The routine must be editable. The user must be able to:

- Rename a day.
- Change the muscle-group focus.
- Add, edit, remove, and reorder exercises.

Preferred presentation:

- Phone: card list with clear exercise summaries.
- Web and tablet: list-detail or table-oriented layout.

### 2. Workout Logging

The app must allow logging a dated workout session from a selected routine day.
Each exercise entry must support:

- Set number.
- Repetitions.
- Weight.
- Freeform notes.

The routine template and workout history must stay separate. Logging a workout
must create historical data rather than overwrite the routine definition.

### 3. Progress Visualization

The user must be able to review previous performance for the same exercise.
Start with two progress views:

- A compact history table showing date, reps, weight, and notes.
- A simple chart showing progress over time.

The first chart can be based on either weight or total volume:

$$
\text{volume} = \sum (\text{reps} \times \text{weight})
$$

Keep the UI readable and fast. Avoid dense dashboards in the first version.

### 4. Authentication Placeholder

The app must include:

- Login screen.
- Registration screen.
- Email and password validation.
- Protected-route behavior in the UI.

Use a fake local auth service for now. The implementation must be structured so
that a real provider such as Firebase Auth can be swapped in later.

## Recommended Technical Direction

### Local-First Storage

Use local persistence for the MVP. This reduces risk and keeps the app usable
offline on mobile and in the browser.

Recommended path:

- Drift for the local database and typed queries.
- A web-compatible SQLite setup through Drift's supported web strategy.
- Shared preferences or equivalent only for lightweight UI settings.

### Architecture

Use a feature-first structure. It is simpler than full clean architecture while
still keeping the app testable and easy to extend.

Suggested layout:

```text
lib/
  app/
    app.dart
    router.dart
    theme.dart
  features/
    auth/
    progress/
    routines/
    workouts/
  shared/
    data/
    models/
    widgets/
    utils/
```

Suggested responsibilities:

- `app/`: bootstrap, theme, router, top-level providers.
- `features/routines/`: routine editing, weekly split, exercise templates.
- `features/workouts/`: session logging and workout history.
- `features/progress/`: exercise history tables and charts.
- `features/auth/`: UI-only auth flow and route guards.
- `shared/`: reusable data access, widgets, models, validation, and utilities.

### Package Set

Recommended initial dependencies:

- `flutter_riverpod` for state management.
- `go_router` for navigation and web-friendly routes.
- `drift` plus the required SQLite/web support packages for persistence.
- `intl` for dates and formatting.
- `fl_chart` for simple progress charts.
- `form_builder_validators` or a similarly lightweight validator package.

Keep the first dependency set small. Avoid adding packages without a clear
feature need.

## Core Data Model

The MVP should be built around these core entities:

- `Routine`: the editable weekly plan.
- `RoutineDay`: one day in the plan with title, order, and focus areas.
- `ExerciseTemplate`: the exercise definition attached to a routine day.
- `WorkoutSession`: a dated session created from a routine day.
- `WorkoutEntry`: one logged exercise inside a session.
- `WorkoutSet`: set-level reps and weight details if you model sets explicitly.

Minimum persistence rules:

- Use stable IDs for all stored entities.
- Store creation and update timestamps.
- Preserve historical workout entries even if the routine changes later.
- Make cardio compatible with future duration or distance fields.

## Suggested Delivery Phases

### Phase 1: Foundation

- Replace the Flutter counter app.
- Add dependencies.
- Set up app theme, routing, and top-level providers.
- Add responsive breakpoints for phone, tablet, and desktop web.

### Phase 2: Routine Management

- Add the seeded weekly routine.
- Build the routine list and routine detail flows.
- Support exercise CRUD and reordering.

### Phase 3: Workout Logging

- Start a session from a selected routine day.
- Record reps, weight, and notes.
- Save session history without mutating the routine template.
- Detailed execution plan: `docs/phase_3_delivery_planning.md`.

### Phase 4: Progress

- Build per-exercise history tables.
- Build one simple chart per exercise.
- Add a recent-history filter if performance needs it on web.

### Phase 5: Auth Placeholder

- Add login and registration screens.
- Add local fake auth state.
- Block protected routes in the UI.

### Phase 6: Tests and Cleanup

- Remove the starter counter test.
- Add unit tests for routine updates, progress calculations, and storage.
- Add widget tests for navigation and core flows.

## Dart Implementation Guidance

Follow the Dart best-practices and modern-features skills during
implementation.

### General Rules

- Keep lines near 80 characters when practical, including Markdown and comments.
- Prefer multi-line strings over concatenated strings when storing SQL, seeded
  text, or long UI messages.
- Avoid unnecessary abstractions in the MVP.
- Keep state, persistence, and UI concerns separated.

### Modern Dart Features to Use Intentionally

Use modern features where they improve clarity, not just to be clever.

- Use `sealed` classes for UI state families such as loading, success, and
  failure states when exhaustive handling matters.
- Use `switch` expressions for concise derived UI values.
- Use pattern matching to safely unpack maps, JSON-like structures, or sealed
  state objects.
- Use records for short-lived grouped return values, such as paired filters or
  chart bounds.
- Use wildcards for intentionally unused parameters.
- Use null-aware collection elements for optional UI actions or metadata.
- Use dot shorthands only where the inferred type is obvious and improves
  readability.

Examples of good fit in this project:

```dart
sealed class AuthState {
  const AuthState();
}

final class SignedOut extends AuthState {
  const SignedOut();
}

final class SignedIn extends AuthState {
  const SignedIn(this.email);

  final String email;
}

String authLabel(AuthState state) => switch (state) {
  SignedOut() => 'Sign in',
  SignedIn(:final email) => email,
};
```

```dart
(DateTime start, DateTime end) recentWindow(DateTime now) => (
  now.subtract(const Duration(days: 30)),
  now,
);
```

### Where Not to Force Modern Syntax

- Do not replace clear domain classes with records when named fields matter.
- Do not use extension types unless there is a real domain-safety benefit.
- Do not use dot shorthand if it makes the target type harder to read.

## UI and UX Direction

Prioritize readability over decoration.

- Use lists and tables for the main routine and history views.
- Keep chart usage secondary to readable raw values.
- Make weight, reps, and notes fast to enter on mobile.
- Ensure wide layouts on web do not stretch content excessively.

Responsive guidance:

- Small screens: bottom navigation or tab-based navigation.
- Larger screens: navigation rail or persistent side navigation.
- Prefer list-detail layouts for routine editing and progress review.

## Acceptance Criteria

The handoff is complete when the implemented app can do the following:

1. Show a seeded weekly routine with four editable days.
2. Let the user edit muscle-group focus and exercises for each day.
3. Let the user log a dated workout with reps, weight, and notes.
4. Show previous performance for an exercise in a readable history view.
5. Show a simple progress chart for an exercise.
6. Run on iOS, Android, and web from the same Flutter codebase.
7. Display login and registration screens with validation and fake auth state.

## Verification Checklist

- Run `flutter analyze` and resolve issues.
- Run `flutter test` and cover routine mutation, session logging, and progress
  calculations.
- Test the main flow on one phone-sized simulator and one desktop browser.
- Confirm that editing a routine does not erase historical workout data.
- Confirm that protected routes redirect correctly under fake auth.

## Immediate Next Files To Change

Implementation should start in these files:

- `pubspec.yaml`
- `lib/main.dart`
- `test/widget_test.dart`

Then add the new app and feature directories under `lib/`.