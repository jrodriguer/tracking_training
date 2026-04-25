import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tracking_training_flutter/features/routines/application/routine_controller.dart';
import 'package:tracking_training_flutter/features/routines/domain/routine_models.dart';

void main() {
  ProviderContainer makeContainer() {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    return container;
  }

  group('RoutineController', () {
    test('initial state contains the four seeded routine days', () {
      final container = makeContainer();
      final days = container.read(routineControllerProvider);

      expect(days, hasLength(4));
      expect(days[0].title, 'Day 1');
      expect(days[3].title, 'Day 4');
    });

    test('initial seed includes expected focus areas per day', () {
      final container = makeContainer();
      final days = container.read(routineControllerProvider);

      expect(
        days[0].focusAreas,
        containsAll(['Chest', 'Shoulders', 'Triceps']),
      );
      expect(days[1].focusAreas, containsAll(['Back', 'Biceps']));
      expect(days[2].focusAreas, containsAll(['Legs', 'Abs']));
      expect(days[3].focusAreas, contains('Cardio'));
    });

    group('updateDayMetadata', () {
      test('renames the title for the specified day', () {
        final container = makeContainer();
        final dayId = container.read(routineControllerProvider).first.id;

        container
            .read(routineControllerProvider.notifier)
            .updateDayMetadata(
              dayId: dayId,
              title: 'Push Day',
              focusAreas: ['Chest', 'Shoulders'],
            );

        final updated = container.read(routineControllerProvider).first;
        expect(updated.title, 'Push Day');
        expect(updated.focusAreas, ['Chest', 'Shoulders']);
      });

      test('does not modify other days', () {
        final container = makeContainer();
        final days = container.read(routineControllerProvider);
        final dayId = days.first.id;
        final otherTitle = days[1].title;

        container
            .read(routineControllerProvider.notifier)
            .updateDayMetadata(
              dayId: dayId,
              title: 'Push Day',
              focusAreas: ['Chest'],
            );

        expect(
          container.read(routineControllerProvider)[1].title,
          otherTitle,
        );
      });
    });

    group('addExercise', () {
      test('appends an exercise to the specified day', () {
        final container = makeContainer();
        final dayId = container.read(routineControllerProvider).first.id;
        final initialCount = container
            .read(routineControllerProvider)
            .first
            .exercises
            .length;

        container
            .read(routineControllerProvider.notifier)
            .addExercise(
              dayId: dayId,
              name: 'Incline Dumbbell Press',
            );

        final exercises = container
            .read(routineControllerProvider)
            .first
            .exercises;
        expect(exercises, hasLength(initialCount + 1));
        expect(exercises.last.name, 'Incline Dumbbell Press');
      });

      test('exercise added with note preserves the note', () {
        final container = makeContainer();
        final dayId = container.read(routineControllerProvider).first.id;

        container
            .read(routineControllerProvider.notifier)
            .addExercise(
              dayId: dayId,
              name: 'Cable Fly',
              note: '3 sets of 15',
            );

        final added = container
            .read(routineControllerProvider)
            .first
            .exercises
            .last;
        expect(added.note, '3 sets of 15');
      });
    });

    group('updateExercise', () {
      test('changes the name and note for the specified exercise', () {
        final container = makeContainer();
        final day = container.read(routineControllerProvider).first;
        final exercise = day.exercises.first;

        container
            .read(routineControllerProvider.notifier)
            .updateExercise(
              dayId: day.id,
              exerciseId: exercise.id,
              name: 'Incline Barbell Press',
              note: 'Focus on upper chest',
            );

        final updated = container
            .read(routineControllerProvider)
            .first
            .exercises
            .first;
        expect(updated.name, 'Incline Barbell Press');
        expect(updated.note, 'Focus on upper chest');
        expect(updated.id, exercise.id);
      });

      test('clearing note sets it to null', () {
        final container = makeContainer();
        final day = container.read(routineControllerProvider).first;
        final exercise = day.exercises.first;

        container
            .read(routineControllerProvider.notifier)
            .updateExercise(
              dayId: day.id,
              exerciseId: exercise.id,
              name: exercise.name,
            );

        final updated = container
            .read(routineControllerProvider)
            .first
            .exercises
            .first;
        expect(updated.note, isNull);
      });
    });

    group('removeExercise', () {
      test('removes the specified exercise from the day', () {
        final container = makeContainer();
        final day = container.read(routineControllerProvider).first;
        final target = day.exercises.first;
        final initialCount = day.exercises.length;

        container
            .read(routineControllerProvider.notifier)
            .removeExercise(
              dayId: day.id,
              exerciseId: target.id,
            );

        final exercises = container
            .read(routineControllerProvider)
            .first
            .exercises;
        expect(exercises, hasLength(initialCount - 1));
        expect(exercises.any((e) => e.id == target.id), isFalse);
      });
    });

    group('reorderExercise', () {
      test('moves an exercise from one position to another', () {
        final container = makeContainer();
        final day = container.read(routineControllerProvider).first;
        // Day 1 has 3 exercises; move index 0 to index 2.
        final originalSecond = day.exercises[1].id;
        final originalFirst = day.exercises[0].id;

        container
            .read(routineControllerProvider.notifier)
            .reorderExercise(
              dayId: day.id,
              oldIndex: 0,
              newIndex: 2,
            );

        final reordered = container
            .read(routineControllerProvider)
            .first
            .exercises;
        // The item that was at 1 should now be at 0.
        expect(reordered[0].id, originalSecond);
        // The item moved away from 0 should be at the end.
        expect(reordered.last.id, originalFirst);
      });
    });

    group('routineDayByIdProvider', () {
      test('returns the matching day for a known id', () {
        final container = makeContainer();
        final days = container.read(routineControllerProvider);
        final target = days[2];

        expect(
          container.read(routineDayByIdProvider(target.id)),
          isA<RoutineDay>(),
        );
        expect(
          container.read(routineDayByIdProvider(target.id))!.title,
          target.title,
        );
      });

      test('returns null for an unknown id', () {
        final container = makeContainer();
        expect(
          container.read(routineDayByIdProvider('nonexistent-id')),
          isNull,
        );
      });
    });
  });
}
