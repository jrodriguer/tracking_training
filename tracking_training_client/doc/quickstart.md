# API Quickstart

This quickstart shows common calls for your current endpoints:

- `emailIdp`
- `jwtRefresh`
- `routine`
- `workout`

## 1. Setup client

```dart
import 'package:tracking_training_client/tracking_training_client.dart';

final client = Client('http://localhost:8080/');
```

## 2. Auth flow (emailIdp + jwtRefresh)

### Sign in

```dart
final auth = await client.emailIdp.login(
  email: 'user@example.com',
  password: 'secret123',
);

// Keep tokens from auth for later authenticated calls.
final refreshToken = auth.refreshToken;
```

### Start and complete registration

```dart
final requestId = await client.emailIdp.startRegistration(
  email: 'newuser@example.com',
);

// Use the code the user receives by email.
final registrationToken = await client.emailIdp.verifyRegistrationCode(
  accountRequestId: requestId,
  verificationCode: '123456',
);

final registered = await client.emailIdp.finishRegistration(
  registrationToken: registrationToken,
  password: 'newPassword123',
);
```

### Refresh access token

```dart
final refreshed = await client.jwtRefresh.refreshAccessToken(
  refreshToken: refreshToken,
);
```

## 3. Routine flow (routine)

### Read routine days

```dart
final days = await client.routine.getRoutineDays();
final day = days.first;
```

### Update day metadata

```dart
await client.routine.updateRoutineDay(
  dayId: day.id!,
  title: 'Day 1 - Push',
  focusAreas: ['Chest', 'Shoulders', 'Triceps'],
);
```

### Add, update, reorder, and remove exercises

```dart
final created = await client.routine.addExercise(
  dayId: day.id!,
  name: 'Incline Dumbbell Press',
  note: '3 x 10',
);

await client.routine.updateExercise(
  exerciseId: created.id!,
  name: 'Incline Bench Press',
  note: 'Keep elbows at 45 degrees',
);

final exercises = await client.routine.getExercises(dayId: day.id!);
await client.routine.reorderExercises(
  dayId: day.id!,
  exerciseIdsInOrder: exercises.map((e) => e.id!).toList().reversed.toList(),
);

await client.routine.removeExercise(exerciseId: created.id!);
```

## 4. Workout flow (workout)

### Create a workout session from a routine day

```dart
final session = await client.workout.createSessionFromRoutineDay(
  routineDayId: day.id!,
  workoutDate: DateTime.now(),
);
```

### Read entries and sets

```dart
final entries = await client.workout.getEntries(sessionId: session.id!);
final firstEntry = entries.first;

final sets = await client.workout.getSets(entryId: firstEntry.id!);
```

### Save a new set

```dart
final newSet = WorkoutSet(
  entryId: firstEntry.id!,
  setNumber: 2,
  reps: 8,
  weight: 80,
  note: 'Hard but clean reps',
);

final savedSet = await client.workout.saveSet(workoutSet: newSet);
```

### Update session metadata and delete data

```dart
await client.workout.updateSessionMetadata(
  workoutSession: session.copyWith(startedAt: DateTime(2026, 4, 25)),
);

await client.workout.deleteSet(setId: savedSet.id!);
await client.workout.deleteSession(sessionId: session.id!);
```

## Notes

- Run `serverpod generate` in `tracking_training_server/` whenever endpoint or
  model contracts change.
- For full endpoint reference, see `doc/endpoint.md`.