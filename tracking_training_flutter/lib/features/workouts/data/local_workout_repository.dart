import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../routines/domain/routine_models.dart';
import '../domain/workout_models.dart';
import 'workout_repository.dart';

class LocalWorkoutRepository implements WorkoutRepository {
  static const _sessionsKey = 'workout_sessions_v1';

  @override
  Future<WorkoutSession> createSessionFromRoutineDay(RoutineDay day) async {
    final now = DateTime.now();

    return WorkoutSession(
      id: _buildId('session'),
      routineDayId: day.id,
      routineDayTitle: day.title,
      startedAt: now,
      updatedAt: now,
      entries: [
        for (final exercise in day.exercises)
          WorkoutEntry(
            id: _buildId('entry'),
            exerciseTemplateId: exercise.id,
            exerciseName: exercise.name,
            sets: [
              WorkoutSet(id: _buildId('set'), setNumber: 1, reps: 0, weight: 0),
            ],
          ),
      ],
    );
  }

  @override
  Future<List<WorkoutSession>> listSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = prefs.getString(_sessionsKey);

    if (encoded == null || encoded.isEmpty) {
      return const [];
    }

    final rawValues = jsonDecode(encoded) as List<dynamic>;
    final sessions = [
      for (final raw in rawValues)
        WorkoutSession.fromJson(raw as Map<String, dynamic>),
    ];

    sessions.sort((a, b) => b.startedAt.compareTo(a.startedAt));
    return sessions;
  }

  @override
  Future<void> upsertSession(WorkoutSession session) async {
    final prefs = await SharedPreferences.getInstance();
    final sessions = await listSessions();

    final updated = [
      for (final value in sessions)
        if (value.id == session.id) session else value,
      if (!sessions.any((value) => value.id == session.id)) session,
    ];

    final encoded = jsonEncode([for (final value in updated) value.toJson()]);
    await prefs.setString(_sessionsKey, encoded);
  }

  String _buildId(String prefix) {
    final micros = DateTime.now().microsecondsSinceEpoch;
    return '$prefix-$micros';
  }
}
