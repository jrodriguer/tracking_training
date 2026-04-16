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

  @override
  Future<WorkoutSession> createSessionFromRoutineDay(RoutineDay day) async {
    final now = DateTime(2026, 4, 2, 12, 0);

    return WorkoutSession(
      id: 'session-1',
      routineDayId: day.id,
      routineDayTitle: day.title,
      startedAt: now,
      updatedAt: now,
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
}
