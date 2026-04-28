import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'require_auth.dart';

// After modifying this file run `serverpod generate` from the server package
// directory to regenerate the client and endpoint dispatcher.

/// App-level authentication endpoint.
///
/// The Flutter client calls [seedDefaultRoutine] immediately after every
/// successful
/// sign-in and after restoring a persisted session.  It seeds the default
/// four-day routine for new users and returns `false` for returning users.
class AppAuthEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Seeds the default four-day routine for first-time users.
  ///
  /// Returns `true` when data was seeded, `false` for returning users.
  Future<bool> seedDefaultRoutine(Session session) async {
    final userId = await requireUserId(session);

    final existing = await RoutineDay.db.find(
      session,
      where: (t) => t.userId.equals(userId),
      limit: 1,
    );
    if (existing.isNotEmpty) return false;

    await _seedDefaultRoutine(session, userId);
    return true;
  }

  Future<void> _seedDefaultRoutine(Session session, UuidValue userId) async {
    final now = DateTime.now();

    await _insertDay(
      session,
      userId,
      now,
      sortOrder: 0,
      title: 'Day 1',
      focusAreas: ['Chest', 'Shoulders', 'Triceps'],
      exercises: const [
        'Barbell Bench Press',
        'Seated Dumbbell Shoulder Press',
        'Cable Triceps Pushdown',
      ],
    );
    await _insertDay(
      session,
      userId,
      now,
      sortOrder: 1,
      title: 'Day 2',
      focusAreas: ['Back', 'Biceps'],
      exercises: const [
        'Lat Pulldown',
        'Chest-Supported Row',
        'Dumbbell Hammer Curl',
      ],
    );
    await _insertDay(
      session,
      userId,
      now,
      sortOrder: 2,
      title: 'Day 3',
      focusAreas: ['Legs', 'Abs'],
      exercises: const [
        'Back Squat',
        'Romanian Deadlift',
        'Hanging Knee Raise',
      ],
    );
    await _insertDay(
      session,
      userId,
      now,
      sortOrder: 3,
      title: 'Day 4',
      focusAreas: ['Cardio'],
      exercises: const ['Incline Treadmill Walk'],
    );
  }

  Future<void> _insertDay(
    Session session,
    UuidValue userId,
    DateTime now, {
    required int sortOrder,
    required String title,
    required List<String> focusAreas,
    required List<String> exercises,
  }) async {
    final day = await RoutineDay.db.insertRow(
      session,
      RoutineDay(
        userId: userId,
        title: title,
        sortOrder: sortOrder,
        focusAreas: focusAreas,
        createdAt: now,
        updatedAt: now,
      ),
    );

    for (var i = 0; i < exercises.length; i++) {
      await ExerciseTemplate.db.insertRow(
        session,
        ExerciseTemplate(
          routineDayId: day.id!,
          name: exercises[i],
          sortOrder: i,
          createdAt: now,
          updatedAt: now,
        ),
      );
    }
  }
}
