import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

// After modifying this file run `serverpod generate` from the server package
// directory to regenerate the client and endpoint dispatcher.

/// Manages dated workout sessions and their set-level history.
///
/// Session data is stored independently of routine templates so that editing
/// or removing a routine day never mutates historical workout records.
class WorkoutEndpoint extends Endpoint {
  // ── Sessions ──────────────────────────────────────────────────────────────

  /// Returns all sessions ordered newest first.
  Future<List<WorkoutSession>> listSessions(Session session) async {
    return WorkoutSession.db.find(
      session,
      orderBy: (t) => t.startedAt,
      orderDescending: true,
    );
  }

  /// Returns a single session by ID, or `null` when not found.
  Future<WorkoutSession?> getSession(
    Session session, {
    required int sessionId,
  }) async {
    return WorkoutSession.db.findById(session, sessionId);
  }

  /// Creates a new workout session from a routine day.
  ///
  /// Snapshots the routine day title and exercise names at creation time so
  /// subsequent routine edits do not affect this historical record.  One
  /// default set is created for each exercise entry.
  Future<WorkoutSession> createSessionFromRoutineDay(
    Session session, {
    required int routineDayId,
    required DateTime workoutDate,
  }) async {
    final day = await RoutineDay.db.findById(session, routineDayId);
    if (day == null) throw Exception('RoutineDay $routineDayId not found.');

    final exercises = await ExerciseTemplate.db.find(
      session,
      where: (t) => t.routineDayId.equals(routineDayId),
      orderBy: (t) => t.sortOrder,
    );

    final now = DateTime.now();
    final newSession = await WorkoutSession.db.insertRow(
      session,
      WorkoutSession(
        routineDayId: routineDayId,
        routineDayTitle: day.title,
        startedAt: workoutDate,
        createdAt: now,
        updatedAt: now,
      ),
    );

    for (final exercise in exercises) {
      final entry = await WorkoutEntry.db.insertRow(
        session,
        WorkoutEntry(
          sessionId: newSession.id!,
          exerciseTemplateId: exercise.id!,
          exerciseName: exercise.name,
        ),
      );
      await WorkoutSet.db.insertRow(
        session,
        WorkoutSet(
          entryId: entry.id!,
          setNumber: 1,
          reps: 0,
          weight: 0,
        ),
      );
    }

    return newSession;
  }

  /// Updates the metadata for an existing session row (title, startedAt).
  ///
  /// This only updates the [WorkoutSession] row. To modify entries and sets
  /// use [saveSet] and [deleteSet].
  Future<void> updateSessionMetadata(
    Session session, {
    required WorkoutSession workoutSession,
  }) async {
    final id = workoutSession.id;
    if (id == null) {
      await WorkoutSession.db.insertRow(session, workoutSession);
      return;
    }
    await WorkoutSession.db.updateRow(
      session,
      workoutSession.copyWith(updatedAt: DateTime.now()),
    );
  }

  /// Deletes a session and all its entries and sets.
  Future<void> deleteSession(
    Session session, {
    required int sessionId,
  }) async {
    // Delete sets first (child of entries).
    final entries = await WorkoutEntry.db.find(
      session,
      where: (t) => t.sessionId.equals(sessionId),
    );
    for (final entry in entries) {
      await WorkoutSet.db.deleteWhere(
        session,
        where: (t) => t.entryId.equals(entry.id!),
      );
    }
    // Delete entries.
    await WorkoutEntry.db.deleteWhere(
      session,
      where: (t) => t.sessionId.equals(sessionId),
    );
    // Delete session.
    final s = await WorkoutSession.db.findById(session, sessionId);
    if (s != null) await WorkoutSession.db.deleteRow(session, s);
  }

  // ── Entries ───────────────────────────────────────────────────────────────

  /// Returns all entries for [sessionId].
  Future<List<WorkoutEntry>> getEntries(
    Session session, {
    required int sessionId,
  }) async {
    return WorkoutEntry.db.find(
      session,
      where: (t) => t.sessionId.equals(sessionId),
    );
  }

  // ── Sets ──────────────────────────────────────────────────────────────────

  /// Returns all sets for [entryId].
  Future<List<WorkoutSet>> getSets(
    Session session, {
    required int entryId,
  }) async {
    return WorkoutSet.db.find(
      session,
      where: (t) => t.entryId.equals(entryId),
      orderBy: (t) => t.setNumber,
    );
  }

  /// Upserts a single set.
  Future<WorkoutSet> saveSet(
    Session session, {
    required WorkoutSet workoutSet,
  }) async {
    if (workoutSet.id == null) {
      return WorkoutSet.db.insertRow(session, workoutSet);
    }
    return WorkoutSet.db.updateRow(session, workoutSet);
  }

  /// Removes a set by ID.
  Future<void> deleteSet(
    Session session, {
    required int setId,
  }) async {
    final s = await WorkoutSet.db.findById(session, setId);
    if (s != null) await WorkoutSet.db.deleteRow(session, s);
  }
}
