// NOTE: This file requires `serverpod generate` to compile.
// Run `serverpod generate` from the `tracking_training_server/` directory
// to update the test tools with the `workout` endpoint.

import 'package:test/test.dart';
import 'package:serverpod/serverpod.dart';

import 'package:tracking_training_server/src/generated/protocol.dart';
import 'test_tools/serverpod_test_tools.dart';

/// A stable UUID used as the owner for all test data in this file.
final _testUserId = UuidValue.fromString(
  '00000000-0000-0000-0000-000000000001',
);

final _otherUserId = UuidValue.fromString(
  '00000000-0000-0000-0000-000000000002',
);

void main() {
  // ── Empty-state tests ─────────────────────────────────────────────────────

  withServerpod('Given WorkoutEndpoint with no data', (
    sessionBuilder,
    endpoints,
  ) {
    test('listSessions returns empty list', () async {
      final sessions = await endpoints.workout.listSessions(sessionBuilder);
      expect(sessions, isEmpty);
    });

    test('getSession returns null for unknown id', () async {
      final session = await endpoints.workout.getSession(
        sessionBuilder,
        sessionId: 999999,
      );
      expect(session, isNull);
    });
  });

  // ── Seeded-data tests ─────────────────────────────────────────────────────

  withServerpod('Given WorkoutEndpoint with a seeded routine day', (
    sessionBuilder,
    endpoints,
  ) {
    late RoutineDay testDay;
    late ExerciseTemplate testExercise;
    late TestSessionBuilder authedSession;
    late TestSessionBuilder otherAuthedSession;

    setUp(() async {
      authedSession = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo(
          _testUserId.toString(),
          <Scope>{},
        ),
      );
      otherAuthedSession = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo(
          _otherUserId.toString(),
          <Scope>{},
        ),
      );
      final session = sessionBuilder.build();
      testDay = await RoutineDay.db.insertRow(
        session,
        RoutineDay(
          userId: _testUserId,
          title: 'Push Day',
          sortOrder: 0,
          focusAreas: ['Chest'],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
      testExercise = await ExerciseTemplate.db.insertRow(
        session,
        ExerciseTemplate(
          routineDayId: testDay.id!,
          name: 'Bench Press',
          sortOrder: 0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
    });

    group('createSessionFromRoutineDay', () {
      test('returns a WorkoutSession with the day title snapshot', () async {
        final workoutSession = await endpoints.workout
            .createSessionFromRoutineDay(
              authedSession,
              routineDayId: testDay.id!,
              workoutDate: DateTime(2026, 4, 25),
            );

        expect(workoutSession.id, isNotNull);
        expect(workoutSession.routineDayId, testDay.id);
        expect(workoutSession.routineDayTitle, 'Push Day');
      });

      test('creates one entry per exercise', () async {
        final workoutSession = await endpoints.workout
            .createSessionFromRoutineDay(
              authedSession,
              routineDayId: testDay.id!,
              workoutDate: DateTime(2026, 4, 25),
            );

        final entries = await endpoints.workout.getEntries(
          authedSession,
          sessionId: workoutSession.id!,
        );

        expect(entries.length, 1);
        expect(entries.first.exerciseName, 'Bench Press');
        expect(entries.first.exerciseTemplateId, testExercise.id);
      });

      test('creates one default set per entry', () async {
        final workoutSession = await endpoints.workout
            .createSessionFromRoutineDay(
              authedSession,
              routineDayId: testDay.id!,
              workoutDate: DateTime(2026, 4, 25),
            );

        final entries = await endpoints.workout.getEntries(
          authedSession,
          sessionId: workoutSession.id!,
        );
        final sets = await endpoints.workout.getSets(
          authedSession,
          entryId: entries.first.id!,
        );

        expect(sets.length, 1);
        expect(sets.first.setNumber, 1);
        expect(sets.first.reps, 0);
        expect(sets.first.weight, 0.0);
      });

      test('throws when routineDayId does not exist', () async {
        expect(
          () => endpoints.workout.createSessionFromRoutineDay(
            authedSession,
            routineDayId: 999999,
            workoutDate: DateTime(2026, 4, 25),
          ),
          throwsA(anything),
        );
      });
    });

    group('listSessions', () {
      test('returns sessions ordered newest first', () async {
        final session = sessionBuilder.build();
        final now = DateTime.now();
        await WorkoutSession.db.insertRow(
          session,
          WorkoutSession(
            userId: _testUserId,
            routineDayId: testDay.id!,
            routineDayTitle: 'Push Day',
            startedAt: now.subtract(const Duration(days: 2)),
            createdAt: now,
            updatedAt: now,
          ),
        );
        await WorkoutSession.db.insertRow(
          session,
          WorkoutSession(
            userId: _testUserId,
            routineDayId: testDay.id!,
            routineDayTitle: 'Push Day',
            startedAt: now,
            createdAt: now,
            updatedAt: now,
          ),
        );

        final sessions = await endpoints.workout.listSessions(authedSession);

        expect(sessions.length, 2);
        expect(
          sessions.first.startedAt.isAfter(sessions.last.startedAt),
          isTrue,
        );
      });
    });

    group('getSession', () {
      test('returns session by id', () async {
        final workoutSession = await endpoints.workout
            .createSessionFromRoutineDay(
              authedSession,
              routineDayId: testDay.id!,
              workoutDate: DateTime(2026, 4, 25),
            );

        final fetched = await endpoints.workout.getSession(
          authedSession,
          sessionId: workoutSession.id!,
        );

        expect(fetched, isNotNull);
        expect(fetched!.id, workoutSession.id);
      });

      test('does not return another user\'s session', () async {
        final workoutSession = await endpoints.workout
            .createSessionFromRoutineDay(
              authedSession,
              routineDayId: testDay.id!,
              workoutDate: DateTime(2026, 4, 25),
            );

        final fetched = await endpoints.workout.getSession(
          otherAuthedSession,
          sessionId: workoutSession.id!,
        );

        expect(fetched, isNull);
      });
    });

    group('updateSessionMetadata', () {
      test('updates startedAt on the session row', () async {
        final workoutSession = await endpoints.workout
            .createSessionFromRoutineDay(
              authedSession,
              routineDayId: testDay.id!,
              workoutDate: DateTime(2026, 4, 25),
            );
        final newDate = DateTime(2026, 4, 20);

        await endpoints.workout.updateSessionMetadata(
          authedSession,
          workoutSession: workoutSession.copyWith(startedAt: newDate),
        );

        final updated = await endpoints.workout.getSession(
          authedSession,
          sessionId: workoutSession.id!,
        );
        expect(updated!.startedAt.toUtc(), newDate.toUtc());
      });
    });

    group('saveSet', () {
      late WorkoutSession workoutSession;
      late WorkoutEntry entry;

      setUp(() async {
        workoutSession = await endpoints.workout.createSessionFromRoutineDay(
          authedSession,
          routineDayId: testDay.id!,
          workoutDate: DateTime(2026, 4, 25),
        );
        final entries = await endpoints.workout.getEntries(
          authedSession,
          sessionId: workoutSession.id!,
        );
        entry = entries.first;
      });

      test('creates a new set when id is null', () async {
        final created = await endpoints.workout.saveSet(
          authedSession,
          workoutSet: WorkoutSet(
            entryId: entry.id!,
            setNumber: 2,
            reps: 8,
            weight: 80.0,
          ),
        );

        expect(created.id, isNotNull);
        expect(created.reps, 8);
        expect(created.weight, 80.0);
      });

      test('updates an existing set', () async {
        final sets = await endpoints.workout.getSets(
          authedSession,
          entryId: entry.id!,
        );
        final existingSet = sets.first;

        await endpoints.workout.saveSet(
          authedSession,
          workoutSet: existingSet.copyWith(reps: 12, weight: 60.0),
        );

        final updatedSets = await endpoints.workout.getSets(
          authedSession,
          entryId: entry.id!,
        );
        final updated = updatedSets.firstWhere((s) => s.id == existingSet.id);
        expect(updated.reps, 12);
        expect(updated.weight, 60.0);
      });
    });

    group('deleteSet', () {
      test('removes the set', () async {
        final workoutSession = await endpoints.workout
            .createSessionFromRoutineDay(
              authedSession,
              routineDayId: testDay.id!,
              workoutDate: DateTime(2026, 4, 25),
            );
        final entries = await endpoints.workout.getEntries(
          authedSession,
          sessionId: workoutSession.id!,
        );
        final sets = await endpoints.workout.getSets(
          authedSession,
          entryId: entries.first.id!,
        );

        await endpoints.workout.deleteSet(
          authedSession,
          setId: sets.first.id!,
        );

        final remaining = await endpoints.workout.getSets(
          authedSession,
          entryId: entries.first.id!,
        );
        expect(remaining, isEmpty);
      });

      test('rejects deleting another user\'s set', () async {
        final workoutSession = await endpoints.workout
            .createSessionFromRoutineDay(
              authedSession,
              routineDayId: testDay.id!,
              workoutDate: DateTime(2026, 4, 25),
            );
        final entries = await endpoints.workout.getEntries(
          authedSession,
          sessionId: workoutSession.id!,
        );
        final sets = await endpoints.workout.getSets(
          authedSession,
          entryId: entries.first.id!,
        );

        await expectLater(
          () => endpoints.workout.deleteSet(
            otherAuthedSession,
            setId: sets.first.id!,
          ),
          throwsA(anything),
        );

        final ownerSets = await endpoints.workout.getSets(
          authedSession,
          entryId: entries.first.id!,
        );
        expect(ownerSets.length, 1);
      });
    });

    group('deleteSession', () {
      test('removes session, entries, and sets', () async {
        final workoutSession = await endpoints.workout
            .createSessionFromRoutineDay(
              authedSession,
              routineDayId: testDay.id!,
              workoutDate: DateTime(2026, 4, 25),
            );
        final sessionId = workoutSession.id!;

        await endpoints.workout.deleteSession(
          authedSession,
          sessionId: sessionId,
        );

        final fetched = await endpoints.workout.getSession(
          authedSession,
          sessionId: sessionId,
        );
        expect(fetched, isNull);

        await expectLater(
          () => endpoints.workout.getEntries(
            authedSession,
            sessionId: sessionId,
          ),
          throwsA(anything),
        );
      });
    });
  });
}
