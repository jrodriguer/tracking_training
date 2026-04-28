import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tracking_training_flutter/features/auth/application/auth_controller.dart';
import 'package:tracking_training_flutter/features/workouts/application/workout_controller.dart';
import 'package:tracking_training_flutter/features/workouts/data/workout_repository.dart';
import 'package:tracking_training_flutter/features/workouts/domain/workout_models.dart';
import 'package:tracking_training_flutter/features/workouts/presentation/workouts_page.dart';
import 'package:tracking_training_flutter/features/routines/domain/routine_models.dart';

void main() {
  Future<void> pumpWorkoutsPage(
    WidgetTester tester,
    _InMemoryWorkoutRepository repository,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authControllerProvider.overrideWith(_SignedInAuthController.new),
          workoutRepositoryProvider.overrideWithValue(repository),
        ],
        child: const MaterialApp(home: Scaffold(body: WorkoutsPage())),
      ),
    );
  }

  Future<void> seedSavedSession(_InMemoryWorkoutRepository repository) async {
    final seededDay = RoutineDay(
      id: 'day-1',
      title: 'Day 1',
      focusAreas: const ['Chest', 'Shoulders', 'Triceps'],
      exercises: const [
        ExerciseTemplate(id: 'd1-ex1', name: 'Barbell Bench Press'),
      ],
    );
    final session = await repository.createSessionFromRoutineDay(seededDay);
    await repository.upsertSession(session);
  }

  testWidgets(
    'start button is disabled when an active session exists',
    (tester) async {
      final repository = _InMemoryWorkoutRepository();

      await pumpWorkoutsPage(tester, repository);

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

    await pumpWorkoutsPage(tester, repository);

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

  testWidgets(
    'edit button in history loads saved session into active editor',
    (tester) async {
      final repository = _InMemoryWorkoutRepository();
      await seedSavedSession(repository);

      await pumpWorkoutsPage(tester, repository);

      await tester.pumpAndSettle();

      await tester.ensureVisible(find.byTooltip('Edit session'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Edit session'));
      await tester.pumpAndSettle();

      // Session is loaded into the active editor.
      expect(find.textContaining('Active session:'), findsOneWidget);
      // Session history is hidden while a saved session is being edited.
      expect(find.text('Session history'), findsNothing);
      expect(find.byTooltip('Edit session'), findsNothing);
    },
  );

  testWidgets(
    'history actions are hidden while an active session exists',
    (tester) async {
      final repository = _InMemoryWorkoutRepository();
      await seedSavedSession(repository);

      await pumpWorkoutsPage(tester, repository);
      await tester.pumpAndSettle();

      expect(find.byTooltip('Edit session'), findsOneWidget);
      expect(find.byTooltip('Delete session'), findsOneWidget);

      await tester.tap(find.text('Start workout session'));
      await tester.pumpAndSettle();

      expect(find.byTooltip('Edit session'), findsNothing);
      expect(find.byTooltip('Delete session'), findsNothing);
      expect(find.text('Session history'), findsNothing);
    },
  );

  testWidgets(
    'discarding active session reveals history actions again',
    (tester) async {
      final repository = _InMemoryWorkoutRepository();
      await seedSavedSession(repository);

      await pumpWorkoutsPage(tester, repository);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Start workout session'));
      await tester.pumpAndSettle();

      expect(find.byTooltip('Edit session'), findsNothing);

      final discardButton = find.widgetWithText(OutlinedButton, 'Discard');
      await tester.ensureVisible(discardButton);
      await tester.pumpAndSettle();
      await tester.tap(discardButton);
      await tester.pumpAndSettle();

      expect(find.byTooltip('Edit session'), findsOneWidget);
      expect(find.byTooltip('Delete session'), findsOneWidget);
      expect(find.text('Session history'), findsOneWidget);
    },
  );

  testWidgets(
    'saving active session restores history list with session actions',
    (tester) async {
      final repository = _InMemoryWorkoutRepository();
      await seedSavedSession(repository);

      await pumpWorkoutsPage(tester, repository);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Start workout session'));
      await tester.pumpAndSettle();

      expect(find.byTooltip('Edit session'), findsNothing);

      final saveButton = find.text('Save session');
      await tester.ensureVisible(saveButton);
      await tester.pumpAndSettle();
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      expect(find.byTooltip('Edit session'), findsWidgets);
      expect(find.byTooltip('Delete session'), findsWidgets);
      expect(find.text('Session history'), findsOneWidget);
    },
  );

  testWidgets(
    'delete button in history shows confirmation and removes session',
    (tester) async {
      final repository = _InMemoryWorkoutRepository();

      await pumpWorkoutsPage(tester, repository);

      await tester.pumpAndSettle();

      await tester.tap(find.text('Start workout session'));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Save session'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save session'));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.byTooltip('Delete session'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Delete session'));
      await tester.pumpAndSettle();

      expect(find.text('Delete session'), findsOneWidget);

      await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
      await tester.pumpAndSettle();

      expect(find.text('No sessions logged yet.'), findsOneWidget);
    },
  );
}

class _SignedInAuthController extends AuthController {
  @override
  AuthState build() => const SignedIn('test@example.com');
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
    // Use distinct dates per session so list ordering is deterministic.
    final created = DateTime(2026, 4, _idCounter, 12, 0);
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
            id: 'entry-${exercise.id}-$_idCounter',
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

  @override
  Future<void> deleteSession(String sessionId) async {
    _sessions.removeWhere((value) => value.id == sessionId);
  }
}
