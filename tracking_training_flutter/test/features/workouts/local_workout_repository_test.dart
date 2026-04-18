import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tracking_training_flutter/features/routines/domain/routine_models.dart';
import 'package:tracking_training_flutter/features/workouts/data/local_workout_repository.dart';
import 'package:tracking_training_flutter/features/workouts/domain/workout_models.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('LocalWorkoutRepository', () {
    test('upsertSession and listSessions round-trip', () async {
      final repo = LocalWorkoutRepository();

      final session = await repo.createSessionFromRoutineDay(_fixtureDay());
      await repo.upsertSession(session);

      final sessions = await repo.listSessions();
      expect(sessions, hasLength(1));
      expect(sessions.first.id, session.id);
      expect(sessions.first.routineDayTitle, session.routineDayTitle);
      expect(sessions.first.createdAt, session.createdAt);
      expect(sessions.first.startedAt, session.startedAt);
      expect(sessions.first.entries, hasLength(session.entries.length));
    });

    test(
      'upsertSession updates existing session in place without duplicating',
      () async {
        final repo = LocalWorkoutRepository();

        final original = await repo.createSessionFromRoutineDay(_fixtureDay());
        await repo.upsertSession(original);

        final modified = original.copyWith(routineDayTitle: 'Updated title');
        await repo.upsertSession(modified);

        final sessions = await repo.listSessions();
        expect(sessions, hasLength(1));
        expect(sessions.first.routineDayTitle, 'Updated title');
      },
    );

    test(
      'listSessions returns sessions sorted by startedAt descending',
      () async {
        final repo = LocalWorkoutRepository();

        final earlier = await repo.createSessionFromRoutineDay(
          _fixtureDay(),
          workoutDate: DateTime(2026, 3, 1),
        );
        final later = await repo.createSessionFromRoutineDay(
          _fixtureDay(),
          workoutDate: DateTime(2026, 4, 1),
        );

        await repo.upsertSession(earlier);
        await repo.upsertSession(later);

        final sessions = await repo.listSessions();
        expect(sessions, hasLength(2));
        expect(sessions.first.startedAt, DateTime(2026, 4, 1));
        expect(sessions.last.startedAt, DateTime(2026, 3, 1));
      },
    );

    test('deleteSession removes the correct session', () async {
      final repo = LocalWorkoutRepository();

      final sessionA = await repo.createSessionFromRoutineDay(_fixtureDay());
      final sessionB = await repo.createSessionFromRoutineDay(_fixtureDay());

      await repo.upsertSession(sessionA);
      await repo.upsertSession(sessionB);

      await repo.deleteSession(sessionA.id);

      final sessions = await repo.listSessions();
      expect(sessions, hasLength(1));
      expect(sessions.first.id, sessionB.id);
    });

    test('deleteSession with unknown id leaves sessions unchanged', () async {
      final repo = LocalWorkoutRepository();

      final session = await repo.createSessionFromRoutineDay(_fixtureDay());
      await repo.upsertSession(session);

      await repo.deleteSession('nonexistent-id');

      final sessions = await repo.listSessions();
      expect(sessions, hasLength(1));
    });

    test('createSessionFromRoutineDay uses workoutDate as startedAt', () async {
      final repo = LocalWorkoutRepository();
      final pastDate = DateTime(2026, 1, 15);

      final session = await repo.createSessionFromRoutineDay(
        _fixtureDay(),
        workoutDate: pastDate,
      );

      expect(session.startedAt, pastDate);
      expect(session.createdAt.isAfter(pastDate), isTrue);
    });

    test(
      'WorkoutSession serialises and deserialises createdAt correctly',
      () async {
        final repo = LocalWorkoutRepository();

        final session = await repo.createSessionFromRoutineDay(_fixtureDay());
        await repo.upsertSession(session);

        final loaded = (await repo.listSessions()).first;
        expect(loaded.createdAt, session.createdAt);
      },
    );

    test('fromJson migration fallback sets createdAt to startedAt', () {
      final json = <String, dynamic>{
        'id': 'old-1',
        'routineDayId': 'd-1',
        'routineDayTitle': 'Day 1',
        'startedAt': '2025-12-01T10:00:00.000',
        'updatedAt': '2025-12-01T10:05:00.000',
        'entries': <dynamic>[],
        // intentionally no 'createdAt' key — simulates old stored data
      };

      final session = WorkoutSession.fromJson(json);

      expect(session.createdAt, session.startedAt);
    });
  });
}

RoutineDay _fixtureDay() {
  return const RoutineDay(
    id: 'day-1',
    title: 'Chest Day',
    focusAreas: ['Chest'],
    exercises: [
      ExerciseTemplate(id: 'ex-1', name: 'Bench Press'),
    ],
  );
}
