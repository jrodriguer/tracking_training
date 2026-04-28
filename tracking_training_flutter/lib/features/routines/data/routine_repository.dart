import '../domain/routine_models.dart';

/// Repository interface for the weekly routine split.
abstract class RoutineRepository {
  Future<List<RoutineDay>> getRoutineDays();

  Future<void> updateDayMetadata({
    required String dayId,
    required String title,
    required List<String> focusAreas,
  });

  Future<ExerciseTemplate> addExercise({
    required String dayId,
    required String name,
    String? note,
  });

  Future<void> updateExercise({
    required String dayId,
    required String exerciseId,
    required String name,
    String? note,
  });

  Future<void> removeExercise({
    required String dayId,
    required String exerciseId,
  });

  Future<void> reorderExercises({
    required String dayId,
    required int oldIndex,
    required int newIndex,
  });
}
