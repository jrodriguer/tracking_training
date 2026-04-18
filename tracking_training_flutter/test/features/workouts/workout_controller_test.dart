import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tracking_training_flutter/features/routines/domain/routine_models.dart';
import 'package:tracking_training_flutter/features/workouts/application/workout_controller.dart';
import 'package:tracking_training_flutter/features/workouts/data/workout_repository.dart';
import 'package:tracking_training_flutter/features/workouts/domain/workout_models.dart';

void main() {
  test('creates and saves a workout session', () async {
    final repository = _InMemoryWorkoutRepository();
    final container = ProviderContainer(
      overrides: [workoutRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    await container.read(workoutControllerProvider.future);

    await container
        .read(workoutControllerProvider.notifier)
        .startSession(_fixtureDay());

    var state = container.read(workoutControllerProvider).value!;

    expect(state.activeSession, isNotNull);
    expect(state.activeSession!.entries.length, 1);
    expect(state.activeSession!.entries.first.sets.length, 1);

    await container
        .read(workoutControllerProvider.notifier)
        .saveActiveSession();

    state = container.read(workoutControllerProvider).value!;

    expect(state.activeSession, isNull);
    expect(state.sessions, hasLength(1));
    expect(
      state.sessions.first.entries.first.exerciseName,
      'Barbell Bench Press',
    );
  });

  test('keeps workout history separate from routine template edits', () async {
    final repository = _InMemoryWorkoutRepository();
    final container = ProviderContainer(
      overrides: [workoutRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    await container.read(workoutControllerProvider.future);

    final originalDay = _fixtureDay();
    await container
        .read(workoutControllerProvider.notifier)
        .startSession(originalDay);
    await container
        .read(workoutControllerProvider.notifier)
        .saveActiveSession();

    final updatedRoutine = originalDay.copyWith(
      exercises: const [
        ExerciseTemplate(id: 'ex-1', name: 'Incline Dumbbell Press'),
      ],
    );

    final state = container.read(workoutControllerProvider).value!;
    final savedExerciseName = state.sessions.first.entries.first.exerciseName;

    expect(updatedRoutine.exercises.first.name, 'Incline Dumbbell Press');
    expect(savedExerciseName, 'Barbell Bench Press');
  });

  test('deleteSession removes the session from history', () async {
    final repository = _InMemoryWorkoutRepository();
    final container = ProviderContainer(
      overrides: [workoutRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    await container.read(workoutControllerProvider.future);

    await container
        .read(workoutControllerProvider.notifier)
        .startSession(_fixtureDay());
    await container
        .read(workoutControllerProvider.notifier)
        .saveActiveSession();

    var state = container.read(workoutControllerProvider).value!;
    expect(state.sessions, hasLength(1));

    await container
        .read(workoutControllerProvider.notifier)
        .deleteSession(state.sessions.first.id);

    state = container.read(workoutControllerProvider).value!;
    expect(state.sessions, isEmpty);
  });

  test('editSavedSession loads session into active state', () async {
    final repository = _InMemoryWorkoutRepository();
    final container = ProviderContainer(
      overrides: [workoutRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    await container.read(workoutControllerProvider.future);

    await container
        .read(workoutControllerProvider.notifier)
        .startSession(_fixtureDay());
    await container
        .read(workoutControllerProvider.notifier)
        .saveActiveSession();

    final state = container.read(workoutControllerProvider).value!;
    final savedSession = state.sessions.first;
    container
        .read(workoutControllerProvider.notifier)
        .editSavedSession(savedSession);

    final updated = container.read(workoutControllerProvider).value!;
    expect(updated.activeSession?.id, savedSession.id);
  });

  test('updateSessionDate changes startedAt on active session', () async {
    final repository = _InMemoryWorkoutRepository();
    final container = ProviderContainer(
      overrides: [workoutRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    await container.read(workoutControllerProvider.future);

    await container
        .read(workoutControllerProvider.notifier)
        .startSession(_fixtureDay());

    final pastDate = DateTime(2026, 3, 1);
    container
        .read(workoutControllerProvider.notifier)
        .updateSessionDate(pastDate);

    final state = container.read(workoutControllerProvider).value!;
    expect(state.activeSession?.startedAt, pastDate);
  });

  test('startSession with custom workoutDate uses that date', () async {
    final repository = _InMemoryWorkoutRepository();
    final container = ProviderContainer(
      overrides: [workoutRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    await container.read(workoutControllerProvider.future);

    final pastDate = DateTime(2026, 4, 10);
    await container
        .read(workoutControllerProvider.notifier)
        .startSession(_fixtureDay(), workoutDate: pastDate);

    final state = container.read(workoutControllerProvider).value!;
    expect(state.activeSession?.startedAt, pastDate);
  });

  test('deleteSession clears activeSession when the ids match', () async {
    final repository = _InMemoryWorkoutRepository();
    final container = ProviderContainer(
      overrides: [workoutRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    await container.read(workoutControllerProvider.future);

    await container
        .read(workoutControllerProvider.notifier)
        .startSession(_fixtureDay());
    await container
        .read(workoutControllerProvider.notifier)
        .saveActiveSession();

    var state = container.read(workoutControllerProvider).value!;
    final savedSession = state.sessions.first;

    container
        .read(workoutControllerProvider.notifier)
        .editSavedSession(savedSession);

    state = container.read(workoutControllerProvider).value!;
    expect(state.activeSession?.id, savedSession.id);

    await container
        .read(workoutControllerProvider.notifier)
        .deleteSession(savedSession.id);

    state = container.read(workoutControllerProvider).value!;
    expect(state.sessions, isEmpty);
    expect(state.activeSession, isNull);
  });

  test('editSavedSession replaces an existing activeSession', () async {
    final repository = _InMemoryWorkoutRepository();
    final container = ProviderContainer(
      overrides: [workoutRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    await container.read(workoutControllerProvider.future);

    // Save two distinct sessions.
    await container
        .read(workoutControllerProvider.notifier)
        .startSession(_fixtureDay());
    await container
        .read(workoutControllerProvider.notifier)
        .saveActiveSession();

    await container
        .read(workoutControllerProvider.notifier)
        .startSession(_fixtureDay());
    await container
        .read(workoutControllerProvider.notifier)
        .saveActiveSession();

    var state = container.read(workoutControllerProvider).value!;
    expect(state.sessions, hasLength(2));

    // Load the first session into active.
    container
        .read(workoutControllerProvider.notifier)
        .editSavedSession(state.sessions.first);
    final firstId = state.sessions.first.id;

    // Load the second session — must replace the first active session.
    container
        .read(workoutControllerProvider.notifier)
        .editSavedSession(state.sessions.last);
    final secondId = state.sessions.last.id;

    state = container.read(workoutControllerProvider).value!;
    expect(state.activeSession?.id, secondId);
    expect(state.activeSession?.id, isNot(firstId));
  });
}

RoutineDay _fixtureDay() {
  return const RoutineDay(
    id: 'day-1',
    title: 'Day 1',
    focusAreas: ['Chest'],
    exercises: [ExerciseTemplate(id: 'ex-1', name: 'Barbell Bench Press')],
  );
}

class _InMemoryWorkoutRepository implements WorkoutRepository {
  final List<WorkoutSession> _sessions = [];
  int _idCounter = 0;

  @override
  Future<WorkoutSession> createSessionFromRoutineDay(
    RoutineDay day, {
    DateTime? workoutDate,
  }) async {
    _idCounter++;
    final created = DateTime(2026, 4, 2, 12, 0);
    final date = workoutDate ?? created;

    return WorkoutSession(
      id: 'session-$_idCounter',
      routineDayId: day.id,
      routineDayTitle: day.title,
      createdAt: created,
      startedAt: date,
      updatedAt: created,
      entries: [
        for (final exercise in day.exercises)
          WorkoutEntry(
            id: 'entry-${exercise.id}',
            exerciseTemplateId: exercise.id,
            exerciseName: exercise.name,
            sets: const [
              WorkoutSet(id: 'set-1', setNumber: 1, reps: 0, weight: 0),
            ],
          ),
      ],
    );
  }

  @override
  Future<List<WorkoutSession>> listSessions() async {
    return [..._sessions];
  }

  @override
  Future<void> upsertSession(WorkoutSession session) async {
    _sessions
      ..removeWhere((value) => value.id == session.id)
      ..add(session);
  }

  @override
  Future<void> deleteSession(String sessionId) async {
    _sessions.removeWhere((value) => value.id == sessionId);
  }
}
