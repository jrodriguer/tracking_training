import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';
import 'package:tracking_training_client/tracking_training_client.dart' as sp;

import '../../routines/domain/routine_models.dart';
import '../data/workout_repository.dart';
import '../domain/workout_models.dart';

/// Server-backed implementation of [WorkoutRepository].
///
/// Maps between Serverpod generated types (integer IDs) and Flutter domain
/// models (string IDs).
class ServerpodWorkoutRepository implements WorkoutRepository {
  ServerpodWorkoutRepository(this._client);

  final sp.Client _client;

  @override
  Future<List<WorkoutSession>> listSessions() async {
    final serverSessions = await _client.workout.listSessions();
    return Future.wait([
      for (final session in serverSessions) _fetchFullSession(session),
    ]);
  }

  @override
  Future<WorkoutSession> createSessionFromRoutineDay(
    RoutineDay day, {
    DateTime? workoutDate,
  }) async {
    final serverSession = await _client.workout.createSessionFromRoutineDay(
      routineDayId: int.parse(day.id),
      workoutDate: workoutDate ?? DateTime.now(),
    );
    return _fetchFullSession(serverSession);
  }

  @override
  Future<void> upsertSession(WorkoutSession session) async {
    await _client.workout.updateSessionMetadata(
      workoutSession: sp.WorkoutSession(
        id: int.parse(session.id),
        userId: _requireAuthUserId(),
        routineDayId: int.parse(session.routineDayId),
        routineDayTitle: session.routineDayTitle,
        startedAt: session.startedAt,
        createdAt: session.createdAt,
        updatedAt: session.updatedAt,
      ),
    );

    for (final entry in session.entries) {
      final entryId = int.parse(entry.id);
      for (final set in entry.sets) {
        final setId = int.tryParse(set.id);
        await _client.workout.saveSet(
          workoutSet: sp.WorkoutSet(
            id: setId,
            entryId: entryId,
            setNumber: set.setNumber,
            reps: set.reps,
            weight: set.weight,
            note: set.note,
          ),
        );
      }
    }
  }

  @override
  Future<void> deleteSession(String sessionId) {
    return _client.workout.deleteSession(sessionId: int.parse(sessionId));
  }

  Future<WorkoutSession> _fetchFullSession(sp.WorkoutSession s) async {
    final serverEntries = await _client.workout.getEntries(sessionId: s.id!);
    final entries = await Future.wait([
      for (final entry in serverEntries) _fetchFullEntry(entry),
    ]);
    return WorkoutSession(
      id: s.id!.toString(),
      routineDayId: s.routineDayId.toString(),
      routineDayTitle: s.routineDayTitle,
      createdAt: s.createdAt,
      startedAt: s.startedAt,
      updatedAt: s.updatedAt,
      entries: entries,
    );
  }

  Future<WorkoutEntry> _fetchFullEntry(sp.WorkoutEntry entry) async {
    final serverSets = await _client.workout.getSets(entryId: entry.id!);
    return WorkoutEntry(
      id: entry.id!.toString(),
      exerciseTemplateId: entry.exerciseTemplateId.toString(),
      exerciseName: entry.exerciseName,
      sets: [
        for (final s in serverSets)
          WorkoutSet(
            id: s.id!.toString(),
            setNumber: s.setNumber,
            reps: s.reps,
            weight: s.weight,
            note: s.note,
          ),
      ],
    );
  }

  sp.UuidValue _requireAuthUserId() {
    final authUserId = _client.auth.authInfo?.authUserId;
    if (authUserId == null) {
      throw StateError(
        'Cannot save workout session metadata without an authenticated user.',
      );
    }
    return authUserId;
  }
}
