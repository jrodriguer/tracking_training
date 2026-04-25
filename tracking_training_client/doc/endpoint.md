# Callable endpoints

This client calls your Serverpod endpoints and returns typed Dart models.

Generic call format:

```dart
client.<endpoint>.<method>(...);
```

## Available endpoints

### `emailIdp`

Email/password identity-provider endpoint from
`serverpod_auth_idp_server`. Use this for auth flows.

Common methods:

- `login(email, password)`
- `startRegistration(email)`
- `verifyRegistrationCode(accountRequestId, verificationCode)`
- `finishRegistration(registrationToken, password)`
- `startPasswordReset(email)`
- `verifyPasswordResetCode(passwordResetRequestId, verificationCode)`
- `finishPasswordReset(finishPasswordResetToken, newPassword)`

Example:

```dart
final auth = await client.emailIdp.login(
	email: 'user@example.com',
	password: 'secret123',
);
```

### `jwtRefresh`

Refreshes access tokens when your client has a refresh token.

Common method:

- `refreshAccessToken(refreshToken: ...)`

Example:

```dart
final refreshed = await client.jwtRefresh.refreshAccessToken(
	refreshToken: refreshToken,
);
```

### `routine`

Manages routine days and exercise templates.

Methods:

- `getRoutineDays()`
- `updateRoutineDay(dayId, title, focusAreas)`
- `getExercises(dayId)`
- `addExercise(dayId, name, note?)`
- `updateExercise(exerciseId, name, note?)`
- `removeExercise(exerciseId)`
- `reorderExercises(dayId, exerciseIdsInOrder)`

Example:

```dart
final days = await client.routine.getRoutineDays();

await client.routine.updateRoutineDay(
	dayId: days.first.id!,
	title: 'Day 1 - Push',
	focusAreas: ['Chest', 'Shoulders', 'Triceps'],
);
```

### `workout`

Manages workout sessions, entries, and sets.

Methods:

- `listSessions()`
- `getSession(sessionId)`
- `createSessionFromRoutineDay(routineDayId, workoutDate)`
- `updateSessionMetadata(workoutSession)`
- `deleteSession(sessionId)`
- `getEntries(sessionId)`
- `getSets(entryId)`
- `saveSet(workoutSet)`
- `deleteSet(setId)`

Example:

```dart
final session = await client.workout.createSessionFromRoutineDay(
	routineDayId: 1,
	workoutDate: DateTime.now(),
);

final entries = await client.workout.getEntries(sessionId: session.id!);
final sets = await client.workout.getSets(entryId: entries.first.id!);
```

## Notes

- Endpoint contracts are generated from the server package.
- If endpoints or models change, run `serverpod generate` in
	`tracking_training_server/`.
- Official docs: https://docs.serverpod.dev
