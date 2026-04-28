import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../auth/require_auth.dart';

// After modifying this file run `serverpod generate` from the server package
// directory to regenerate the client and endpoint dispatcher.

/// Manages dated workout sessions and their set-level history.
///
/// Session data is stored independently of routine templates so that editing
/// or removing a routine day never mutates historical workout records.
class WorkoutEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;
  // ── Sessions ──────────────────────────────────────────────────────────────

  /// Returns all sessions ordered newest first.
  Future<List<WorkoutSession>> listSessions(Session session) async {
    final userId = await requireUserId(session);
    return WorkoutSession.db.find(
      session,
      where: (t) => t.userId.equals(userId),
      orderBy: (t) => t.startedAt,
      orderDescending: true,
    );
  }

  /// Returns a single session by ID, or `null` when not found.
  Future<WorkoutSession?> getSession(
    Session session, {
    required int sessionId,
  }) async {
    final userId = await requireUserId(session);
    final target = await WorkoutSession.db.findById(session, sessionId);
    if (target == null || target.userId != userId) return null;
    return target;
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
    final userId = await requireUserId(session);
    final day = await RoutineDay.db.findById(session, routineDayId);
    if (day == null || day.userId != userId) {
      throw Exception('Not authorized');
    }

    final exercises = await ExerciseTemplate.db.find(
      session,
      where: (t) => t.routineDayId.equals(routineDayId),
      orderBy: (t) => t.sortOrder,
    );

    final now = DateTime.now();
    final newSession = await WorkoutSession.db.insertRow(
      session,
      WorkoutSession(
        userId: userId,
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
    final userId = await requireUserId(session);
    final id = workoutSession.id;
    if (id == null) {
      await WorkoutSession.db.insertRow(
        session,
        workoutSession.copyWith(userId: userId),
      );
      return;
    }
    final existing = await WorkoutSession.db.findById(session, id);
    if (existing == null || existing.userId != userId) return;
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
    final userId = await requireUserId(session);
    final target = await WorkoutSession.db.findById(session, sessionId);
    if (target == null || target.userId != userId) return;
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
    // Delete session row.
    await WorkoutSession.db.deleteRow(session, target);
  }

  // ── Entries ───────────────────────────────────────────────────────────────

  /// Returns all entries for [sessionId].
  Future<List<WorkoutEntry>> getEntries(
    Session session, {
    required int sessionId,
  }) async {
    final userId = await requireUserId(session);
    final parentSession = await WorkoutSession.db.findById(session, sessionId);
    if (parentSession == null || parentSession.userId != userId) {
      throw Exception('Not authorized');
    }
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
    final userId = await requireUserId(session);
    final entry = await WorkoutEntry.db.findById(session, entryId);
    if (entry == null) throw Exception('Not authorized');
    final parentSession = await WorkoutSession.db.findById(
      session,
      entry.sessionId,
    );
    if (parentSession == null || parentSession.userId != userId) {
      throw Exception('Not authorized');
    }
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
    final userId = await requireUserId(session);
    if (workoutSet.id == null) {
      final parentEntry = await WorkoutEntry.db.findById(session, workoutSet.entryId);
      if (parentEntry == null) throw Exception('Not authorized');
      final parentSession = await WorkoutSession.db.findById(
        session,
        parentEntry.sessionId,
      );
      if (parentSession == null || parentSession.userId != userId) {
        throw Exception('Not authorized');
      }
      return WorkoutSet.db.insertRow(session, workoutSet);
    }
    final existingSet = await WorkoutSet.db.findById(session, workoutSet.id!);
    if (existingSet == null) throw Exception('Not authorized');
    final parentEntry = await WorkoutEntry.db.findById(
      session,
      existingSet.entryId,
    );
    if (parentEntry == null) throw Exception('Not authorized');
    final parentSession = await WorkoutSession.db.findById(
      session,
      parentEntry.sessionId,
    );
    if (parentSession == null || parentSession.userId != userId) {
      throw Exception('Not authorized');
    }
    return WorkoutSet.db.updateRow(
      session,
      workoutSet.copyWith(entryId: existingSet.entryId),
    );
  }

  /// Removes a set by ID.
  Future<void> deleteSet(
    Session session, {
    required int setId,
  }) async {
    final userId = await requireUserId(session);
    final s = await WorkoutSet.db.findById(session, setId);
    if (s == null) throw Exception('Not authorized');
    final parentEntry = await WorkoutEntry.db.findById(session, s.entryId);
    if (parentEntry == null) throw Exception('Not authorized');
    final parentSession = await WorkoutSession.db.findById(
      session,
      parentEntry.sessionId,
    );
    if (parentSession == null || parentSession.userId != userId) {
      throw Exception('Not authorized');
    }
    await WorkoutSet.db.deleteRow(session, s);
  }
}
