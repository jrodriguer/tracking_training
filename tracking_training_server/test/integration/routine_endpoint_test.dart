import 'package:test/test.dart';

import 'package:tracking_training_server/src/generated/protocol.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  // ── Empty-state tests ────────────────────────────────────────────────────

  withServerpod('Given RoutineEndpoint with no data', (
    sessionBuilder,
    endpoints,
  ) {
    test('getRoutineDays returns empty list', () async {
      final days = await endpoints.routine.getRoutineDays(sessionBuilder);
      expect(days, isEmpty);
    });
  });

  // ── Seeded-data tests ─────────────────────────────────────────────────────

  withServerpod('Given RoutineEndpoint with a seeded day', (
    sessionBuilder,
    endpoints,
  ) {
    late RoutineDay testDay;

    setUp(() async {
      final session = sessionBuilder.build();
      testDay = await RoutineDay.db.insertRow(
        session,
        RoutineDay(
          title: 'Push Day',
          sortOrder: 0,
          focusAreas: ['Chest', 'Shoulders'],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
    });

    group('getRoutineDays', () {
      test('returns the seeded day', () async {
        final days = await endpoints.routine.getRoutineDays(sessionBuilder);
        expect(days.length, 1);
        expect(days.first.title, 'Push Day');
        expect(days.first.focusAreas, ['Chest', 'Shoulders']);
      });

      test('returns days ordered by sortOrder', () async {
        final session = sessionBuilder.build();
        await RoutineDay.db.insertRow(
          session,
          RoutineDay(
            title: 'Pull Day',
            sortOrder: 2,
            focusAreas: ['Back'],
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );
        await RoutineDay.db.insertRow(
          session,
          RoutineDay(
            title: 'Leg Day',
            sortOrder: 1,
            focusAreas: ['Quads'],
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );

        final days = await endpoints.routine.getRoutineDays(sessionBuilder);

        expect(days.length, 3);
        expect(days[0].sortOrder, 0);
        expect(days[1].sortOrder, 1);
        expect(days[2].sortOrder, 2);
      });
    });

    group('updateRoutineDay', () {
      test('updates title and focusAreas', () async {
        await endpoints.routine.updateRoutineDay(
          sessionBuilder,
          dayId: testDay.id!,
          title: 'Chest & Tris',
          focusAreas: ['Chest', 'Triceps'],
        );

        final days = await endpoints.routine.getRoutineDays(sessionBuilder);
        final updated = days.first;
        expect(updated.title, 'Chest & Tris');
        expect(updated.focusAreas, ['Chest', 'Triceps']);
      });

      test('throws when dayId does not exist', () async {
        expect(
          () => endpoints.routine.updateRoutineDay(
            sessionBuilder,
            dayId: 999999,
            title: 'Ghost',
            focusAreas: [],
          ),
          throwsA(anything),
        );
      });
    });

    group('addExercise', () {
      test('inserts exercise and returns it with an id', () async {
        final exercise = await endpoints.routine.addExercise(
          sessionBuilder,
          dayId: testDay.id!,
          name: 'Bench Press',
        );

        expect(exercise.id, isNotNull);
        expect(exercise.name, 'Bench Press');
        expect(exercise.routineDayId, testDay.id);
        expect(exercise.note, isNull);
        expect(exercise.sortOrder, 0);
      });

      test('assigns ascending sortOrder for subsequent exercises', () async {
        await endpoints.routine.addExercise(
          sessionBuilder,
          dayId: testDay.id!,
          name: 'Bench Press',
        );
        final second = await endpoints.routine.addExercise(
          sessionBuilder,
          dayId: testDay.id!,
          name: 'Overhead Press',
        );

        expect(second.sortOrder, 1);
      });

      test('stores optional note', () async {
        final exercise = await endpoints.routine.addExercise(
          sessionBuilder,
          dayId: testDay.id!,
          name: 'Squat',
          note: 'Keep chest up',
        );

        expect(exercise.note, 'Keep chest up');
      });
    });

    group('getExercises', () {
      test('returns exercises ordered by sortOrder', () async {
        await endpoints.routine.addExercise(
          sessionBuilder,
          dayId: testDay.id!,
          name: 'First',
        );
        await endpoints.routine.addExercise(
          sessionBuilder,
          dayId: testDay.id!,
          name: 'Second',
        );

        final exercises = await endpoints.routine.getExercises(
          sessionBuilder,
          dayId: testDay.id!,
        );

        expect(exercises.length, 2);
        expect(exercises[0].name, 'First');
        expect(exercises[1].name, 'Second');
      });

      test('returns empty list when day has no exercises', () async {
        final exercises = await endpoints.routine.getExercises(
          sessionBuilder,
          dayId: testDay.id!,
        );

        expect(exercises, isEmpty);
      });
    });

    group('updateExercise', () {
      late ExerciseTemplate exercise;

      setUp(() async {
        exercise = await endpoints.routine.addExercise(
          sessionBuilder,
          dayId: testDay.id!,
          name: 'Dumbbell Row',
        );
      });

      test('updates name', () async {
        await endpoints.routine.updateExercise(
          sessionBuilder,
          exerciseId: exercise.id!,
          name: 'Cable Row',
        );

        final exercises = await endpoints.routine.getExercises(
          sessionBuilder,
          dayId: testDay.id!,
        );
        expect(exercises.first.name, 'Cable Row');
      });

      test('updates optional note', () async {
        await endpoints.routine.updateExercise(
          sessionBuilder,
          exerciseId: exercise.id!,
          name: 'Dumbbell Row',
          note: 'Neutral grip',
        );

        final exercises = await endpoints.routine.getExercises(
          sessionBuilder,
          dayId: testDay.id!,
        );
        expect(exercises.first.note, 'Neutral grip');
      });

      test('throws when exerciseId does not exist', () async {
        expect(
          () => endpoints.routine.updateExercise(
            sessionBuilder,
            exerciseId: 999999,
            name: 'Ghost',
          ),
          throwsA(anything),
        );
      });
    });

    group('removeExercise', () {
      test('removes the exercise from the list', () async {
        final exercise = await endpoints.routine.addExercise(
          sessionBuilder,
          dayId: testDay.id!,
          name: 'To Remove',
        );

        await endpoints.routine.removeExercise(
          sessionBuilder,
          exerciseId: exercise.id!,
        );

        final exercises = await endpoints.routine.getExercises(
          sessionBuilder,
          dayId: testDay.id!,
        );
        expect(exercises, isEmpty);
      });

      test('throws when exerciseId does not exist', () async {
        expect(
          () => endpoints.routine.removeExercise(
            sessionBuilder,
            exerciseId: 999999,
          ),
          throwsA(anything),
        );
      });
    });

    group('reorderExercises', () {
      test('assigns sortOrder matching the provided order', () async {
        final a = await endpoints.routine.addExercise(
          sessionBuilder,
          dayId: testDay.id!,
          name: 'A',
        );
        final b = await endpoints.routine.addExercise(
          sessionBuilder,
          dayId: testDay.id!,
          name: 'B',
        );
        final c = await endpoints.routine.addExercise(
          sessionBuilder,
          dayId: testDay.id!,
          name: 'C',
        );

        // Reverse the order.
        await endpoints.routine.reorderExercises(
          sessionBuilder,
          dayId: testDay.id!,
          exerciseIdsInOrder: [c.id!, b.id!, a.id!],
        );

        final exercises = await endpoints.routine.getExercises(
          sessionBuilder,
          dayId: testDay.id!,
        );
        expect(exercises[0].name, 'C');
        expect(exercises[1].name, 'B');
        expect(exercises[2].name, 'A');
      });
    });
  });
}
