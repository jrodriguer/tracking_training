import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tracking_training_flutter/features/workouts/application/workout_controller.dart';
import 'package:tracking_training_flutter/features/workouts/data/workout_repository.dart';
import 'package:tracking_training_flutter/features/workouts/domain/workout_models.dart';
import 'package:tracking_training_flutter/features/workouts/presentation/workouts_page.dart';
import 'package:tracking_training_flutter/features/routines/domain/routine_models.dart';

void main() {
  testWidgets(
    'start button is disabled when an active session exists',
    (tester) async {
      final repository = _InMemoryWorkoutRepository();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [workoutRepositoryProvider.overrideWithValue(repository)],
          child: const MaterialApp(home: Scaffold(body: WorkoutsPage())),
        ),
      );

      await tester.pumpAndSettle();

      // Button is enabled when no session is active.
      final startButton = find.widgetWithText(
        FilledButton,
        'Start workout session',
      );
      expect(
        tester.widget<FilledButton>(startButton).onPressed,
        isNotNull,
      );

      // Start a session.
      await tester.tap(startButton);
      await tester.pumpAndSettle();

      // Button is disabled and hint text is shown while a session is active.
      expect(
        tester.widget<FilledButton>(startButton).onPressed,
        isNull,
      );
      expect(
        find.text(
          'Save or discard the active session before starting a new one.',
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets('starts and saves session from workouts page', (tester) async {
    final repository = _InMemoryWorkoutRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [workoutRepositoryProvider.overrideWithValue(repository)],
        child: const MaterialApp(home: Scaffold(body: WorkoutsPage())),
      ),
    );

    await tester.pumpAndSettle();

    expect(
      find.text('No active session. Start a workout from a routine day above.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Start workout session'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Active session:'), findsOneWidget);

    await tester.ensureVisible(find.text('Save session'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save session'));
    await tester.pumpAndSettle();

    expect(find.text('Workout session saved.'), findsOneWidget);
    expect(find.text('Day 1'), findsWidgets);
  });
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
              WorkoutSet(id: 'set-1', setNumber: 1, reps: 8, weight: 40),
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
