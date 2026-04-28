import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tracking_training_flutter/features/auth/application/auth_controller.dart';
import 'package:tracking_training_flutter/features/routines/application/routine_controller.dart';
import 'package:tracking_training_flutter/features/routines/domain/routine_models.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  ProviderContainer makeSignedInContainer() {
    final container = ProviderContainer(
      overrides: [
        authControllerProvider.overrideWith(_SignedInAuthController.new),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('RoutineController', () {
    test('returns empty list when signed out', () async {
      final container = ProviderContainer(
        overrides: [
          authControllerProvider.overrideWith(_SignedOutAuthController.new),
        ],
      );
      addTearDown(container.dispose);

      final days = container.read(routineControllerProvider).value ?? [];
      expect(days, isEmpty);
    });

    test('initial state contains the four seeded routine days', () async {
      final container = makeSignedInContainer();
      final days = await container.read(routineControllerProvider.future);

      expect(days, hasLength(4));
      expect(days[0].title, 'Day 1');
      expect(days[3].title, 'Day 4');
    });

    test('initial seed includes expected focus areas per day', () async {
      final container = makeSignedInContainer();
      final days = await container.read(routineControllerProvider.future);

      expect(
        days[0].focusAreas,
        containsAll(['Chest', 'Shoulders', 'Triceps']),
      );
      expect(days[1].focusAreas, containsAll(['Back', 'Biceps']));
      expect(days[2].focusAreas, containsAll(['Legs', 'Abs']));
      expect(days[3].focusAreas, contains('Cardio'));
    });

    group('updateDayMetadata', () {
      test('renames the title for the specified day', () async {
        final container = makeSignedInContainer();
        final days = await container.read(routineControllerProvider.future);
        final dayId = days.first.id;

        await container
            .read(routineControllerProvider.notifier)
            .updateDayMetadata(
              dayId: dayId,
              title: 'Push Day',
              focusAreas: ['Chest', 'Shoulders'],
            );

        final updated = container.read(routineControllerProvider).value!.first;
        expect(updated.title, 'Push Day');
        expect(updated.focusAreas, ['Chest', 'Shoulders']);
      });

      test('does not modify other days', () async {
        final container = makeSignedInContainer();
        final days = await container.read(routineControllerProvider.future);
        final dayId = days.first.id;
        final otherTitle = days[1].title;

        await container
            .read(routineControllerProvider.notifier)
            .updateDayMetadata(
              dayId: dayId,
              title: 'Push Day',
              focusAreas: ['Chest'],
            );

        expect(
          container.read(routineControllerProvider).value![1].title,
          otherTitle,
        );
      });
    });

    group('addExercise', () {
      test('appends an exercise to the specified day', () async {
        final container = makeSignedInContainer();
        final days = await container.read(routineControllerProvider.future);
        final dayId = days.first.id;
        final initialCount = days.first.exercises.length;

        await container
            .read(routineControllerProvider.notifier)
            .addExercise(
              dayId: dayId,
              name: 'Incline Dumbbell Press',
            );

        final exercises = container
            .read(routineControllerProvider)
            .value!
            .first
            .exercises;
        expect(exercises, hasLength(initialCount + 1));
        expect(exercises.last.name, 'Incline Dumbbell Press');
      });

      test('exercise added with note preserves the note', () async {
        final container = makeSignedInContainer();
        final days = await container.read(routineControllerProvider.future);
        final dayId = days.first.id;

        await container
            .read(routineControllerProvider.notifier)
            .addExercise(
              dayId: dayId,
              name: 'Cable Fly',
              note: '3 sets of 15',
            );

        final added = container
            .read(routineControllerProvider)
            .value!
            .first
            .exercises
            .last;
        expect(added.note, '3 sets of 15');
      });
    });

    group('updateExercise', () {
      test('changes the name and note for the specified exercise', () async {
        final container = makeSignedInContainer();
        final days = await container.read(routineControllerProvider.future);
        final day = days.first;
        final exercise = day.exercises.first;

        await container
            .read(routineControllerProvider.notifier)
            .updateExercise(
              dayId: day.id,
              exerciseId: exercise.id,
              name: 'Incline Barbell Press',
              note: 'Focus on upper chest',
            );

        final updated = container
            .read(routineControllerProvider)
            .value!
            .first
            .exercises
            .first;
        expect(updated.name, 'Incline Barbell Press');
        expect(updated.note, 'Focus on upper chest');
        expect(updated.id, exercise.id);
      });

      test('clearing note sets it to null', () async {
        final container = makeSignedInContainer();
        final days = await container.read(routineControllerProvider.future);
        final day = days.first;
        final exercise = day.exercises.first;

        await container
            .read(routineControllerProvider.notifier)
            .updateExercise(
              dayId: day.id,
              exerciseId: exercise.id,
              name: exercise.name,
            );

        final updated = container
            .read(routineControllerProvider)
            .value!
            .first
            .exercises
            .first;
        expect(updated.note, isNull);
      });
    });

    group('removeExercise', () {
      test('removes the specified exercise from the day', () async {
        final container = makeSignedInContainer();
        final days = await container.read(routineControllerProvider.future);
        final day = days.first;
        final target = day.exercises.first;
        final initialCount = day.exercises.length;

        await container
            .read(routineControllerProvider.notifier)
            .removeExercise(
              dayId: day.id,
              exerciseId: target.id,
            );

        final exercises = container
            .read(routineControllerProvider)
            .value!
            .first
            .exercises;
        expect(exercises, hasLength(initialCount - 1));
        expect(exercises.any((e) => e.id == target.id), isFalse);
      });
    });

    group('reorderExercise', () {
      test('moves an exercise from one position to another', () async {
        final container = makeSignedInContainer();
        final days = await container.read(routineControllerProvider.future);
        final day = days.first;
        // Day 1 has 3 exercises; move index 0 to index 2.
        final originalSecond = day.exercises[1].id;
        final originalFirst = day.exercises[0].id;

        await container
            .read(routineControllerProvider.notifier)
            .reorderExercise(
              dayId: day.id,
              oldIndex: 0,
              newIndex: 2,
            );

        final reordered = container
            .read(routineControllerProvider)
            .value!
            .first
            .exercises;
        expect(reordered[0].id, originalSecond);
        expect(reordered[1].id, originalFirst);
      });
    });

    group('routineDayByIdProvider', () {
      test('returns the matching day for a known id', () async {
        final container = makeSignedInContainer();
        final days = await container.read(routineControllerProvider.future);
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

      test('returns null for an unknown id', () async {
        final container = makeSignedInContainer();
        await container.read(routineControllerProvider.future);

        expect(
          container.read(routineDayByIdProvider('nonexistent-id')),
          isNull,
        );
      });
    });
  });
}

class _SignedInAuthController extends AuthController {
  @override
  AuthState build() => const SignedIn('test@example.com');
}

class _SignedOutAuthController extends AuthController {
  @override
  AuthState build() => const SignedOut();
}
