import '../../routines/domain/routine_models.dart';
import '../domain/workout_models.dart';

abstract class WorkoutRepository {
  Future<List<WorkoutSession>> listSessions();

  Future<void> upsertSession(WorkoutSession session);

  Future<void> deleteSession(String sessionId);

  Future<WorkoutSession> createSessionFromRoutineDay(
    RoutineDay day, {
    DateTime? workoutDate,
  });
}
