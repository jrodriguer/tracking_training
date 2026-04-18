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

  testWidgets(
    'edit button in history loads saved session into active editor',
    (tester) async {
      final repository = _InMemoryWorkoutRepository();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            workoutRepositoryProvider.overrideWithValue(repository),
          ],
          child: const MaterialApp(
            home: Scaffold(body: WorkoutsPage()),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('Start workout session'));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Save session'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save session'));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.byTooltip('Edit session'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Edit session'));
      await tester.pumpAndSettle();

      // Session is loaded into the active editor.
      expect(find.textContaining('Active session:'), findsOneWidget);
      // Session is hidden from history while being edited.
      expect(find.text('No sessions logged yet.'), findsOneWidget);
      expect(find.byTooltip('Edit session'), findsNothing);
    },
  );

  testWidgets(
    'conflict dialog Save path saves active session then edits the tapped one',
    (tester) async {
      final repository = _InMemoryWorkoutRepository();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            workoutRepositoryProvider.overrideWithValue(repository),
          ],
          child: const MaterialApp(
            home: Scaffold(body: WorkoutsPage()),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Save session-1.
      await tester.tap(find.text('Start workout session'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Save session'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save session'));
      await tester.pumpAndSettle();

      // Start session-2 without saving — now there is an active session
      // AND a history item (session-1).
      await tester.tap(find.text('Start workout session'));
      await tester.pumpAndSettle();

      // Tap Edit on session-1 in history → conflict dialog appears.
      await tester.ensureVisible(find.byTooltip('Edit session'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Edit session'));
      await tester.pumpAndSettle();

      expect(find.text('Unsaved session'), findsOneWidget);

      // Choose Save → session-2 is saved, session-1 becomes active.
      await tester.tap(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.widgetWithText(FilledButton, 'Save'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Active session:'), findsOneWidget);
    },
  );

  testWidgets(
    'conflict dialog Discard path discards active session then edits the '
    'tapped one',
    (tester) async {
      final repository = _InMemoryWorkoutRepository();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            workoutRepositoryProvider.overrideWithValue(repository),
          ],
          child: const MaterialApp(
            home: Scaffold(body: WorkoutsPage()),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Save session-1, then start session-2 (active, not saved).
      await tester.tap(find.text('Start workout session'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Save session'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save session'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Start workout session'));
      await tester.pumpAndSettle();

      // Tap Edit on session-1 → conflict dialog.
      await tester.ensureVisible(find.byTooltip('Edit session'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Edit session'));
      await tester.pumpAndSettle();

      expect(find.text('Unsaved session'), findsOneWidget);

      // Choose Discard → session-2 discarded, session-1 becomes active.
      await tester.tap(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.widgetWithText(OutlinedButton, 'Discard'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Active session:'), findsOneWidget);
    },
  );

  testWidgets(
    'conflict dialog Cancel path leaves the active session untouched',
    (tester) async {
      final repository = _InMemoryWorkoutRepository();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            workoutRepositoryProvider.overrideWithValue(repository),
          ],
          child: const MaterialApp(
            home: Scaffold(body: WorkoutsPage()),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Save session-1, then start session-2 (active, not saved).
      await tester.tap(find.text('Start workout session'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Save session'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save session'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Start workout session'));
      await tester.pumpAndSettle();

      // Tap Edit on session-1 → conflict dialog.
      await tester.ensureVisible(find.byTooltip('Edit session'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Edit session'));
      await tester.pumpAndSettle();

      expect(find.text('Unsaved session'), findsOneWidget);

      // Choose Cancel → nothing changes.
      await tester.tap(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.widgetWithText(TextButton, 'Cancel'),
        ),
      );
      await tester.pumpAndSettle();

      // session-2 is still the active session; session-1 is still in history.
      expect(find.textContaining('Active session:'), findsOneWidget);
      expect(find.byTooltip('Edit session'), findsOneWidget);
    },
  );

  testWidgets(
    'delete button in history shows confirmation and removes session',
    (tester) async {
      final repository = _InMemoryWorkoutRepository();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            workoutRepositoryProvider.overrideWithValue(repository),
          ],
          child: const MaterialApp(
            home: Scaffold(body: WorkoutsPage()),
          ),
        ),
      );

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
