import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

// After modifying this file run `serverpod generate` from the server package
// directory to regenerate the client and endpoint dispatcher.

/// Manages the weekly routine split: days, focus areas, and exercises.
class RoutineEndpoint extends Endpoint {
  // ── Days ──────────────────────────────────────────────────────────────────

  /// Returns all routine days ordered by [RoutineDay.sortOrder].
  Future<List<RoutineDay>> getRoutineDays(Session session) async {
    return RoutineDay.db.find(
      session,
      orderBy: (t) => t.sortOrder,
    );
  }

  /// Updates a routine day's display title and focus-area labels.
  Future<void> updateRoutineDay(
    Session session, {
    required int dayId,
    required String title,
    required List<String> focusAreas,
  }) async {
    final day = await RoutineDay.db.findById(session, dayId);
    if (day == null) throw Exception('RoutineDay $dayId not found.');
    await RoutineDay.db.updateRow(
      session,
      day.copyWith(
        title: title,
        focusAreas: focusAreas,
        updatedAt: DateTime.now(),
      ),
    );
  }

  // ── Exercises ─────────────────────────────────────────────────────────────

  /// Returns all exercises for [dayId] ordered by [ExerciseTemplate.sortOrder].
  Future<List<ExerciseTemplate>> getExercises(
    Session session, {
    required int dayId,
  }) async {
    return ExerciseTemplate.db.find(
      session,
      where: (t) => t.routineDayId.equals(dayId),
      orderBy: (t) => t.sortOrder,
    );
  }

  /// Appends a new exercise to [dayId] and returns the persisted record.
  Future<ExerciseTemplate> addExercise(
    Session session, {
    required int dayId,
    required String name,
    String? note,
  }) async {
    final existing = await ExerciseTemplate.db.find(
      session,
      where: (t) => t.routineDayId.equals(dayId),
    );
    final now = DateTime.now();
    return ExerciseTemplate.db.insertRow(
      session,
      ExerciseTemplate(
        routineDayId: dayId,
        name: name,
        note: note,
        sortOrder: existing.length,
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  /// Updates the name and optional note for an exercise.
  Future<void> updateExercise(
    Session session, {
    required int exerciseId,
    required String name,
    String? note,
  }) async {
    final exercise = await ExerciseTemplate.db.findById(session, exerciseId);
    if (exercise == null) {
      throw Exception('ExerciseTemplate $exerciseId not found.');
    }
    await ExerciseTemplate.db.updateRow(
      session,
      exercise.copyWith(name: name, note: note, updatedAt: DateTime.now()),
    );
  }

  /// Removes an exercise.
  Future<void> removeExercise(
    Session session, {
    required int exerciseId,
  }) async {
    final exercise = await ExerciseTemplate.db.findById(session, exerciseId);
    if (exercise == null) {
      throw Exception('ExerciseTemplate $exerciseId not found.');
    }
    await ExerciseTemplate.db.deleteRow(session, exercise);
  }

  /// Reorders exercises within [dayId] to match [exerciseIdsInOrder].
  ///
  /// Each element of [exerciseIdsInOrder] is assigned a [sortOrder] equal to
  /// its list index.
  Future<void> reorderExercises(
    Session session, {
    required int dayId,
    required List<int> exerciseIdsInOrder,
  }) async {
    final exercises = await ExerciseTemplate.db.find(
      session,
      where: (t) => t.routineDayId.equals(dayId),
    );
    final byId = {for (final e in exercises) e.id!: e};
    final now = DateTime.now();
    final updates = [
      for (var i = 0; i < exerciseIdsInOrder.length; i++)
        if (byId[exerciseIdsInOrder[i]] case final exercise?)
          exercise.copyWith(sortOrder: i, updatedAt: now),
    ];
    if (updates.isNotEmpty) {
      await ExerciseTemplate.db.update(session, updates);
    }
  }
}
