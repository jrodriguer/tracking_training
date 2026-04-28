import 'package:tracking_training_client/tracking_training_client.dart' as sp;

import '../domain/routine_models.dart';
import 'routine_repository.dart';

/// Server-backed implementation of [RoutineRepository].
///
/// Maps between the Serverpod generated types (integer IDs) and the Flutter
/// domain models (string IDs).
class ServerpodRoutineRepository implements RoutineRepository {
  ServerpodRoutineRepository(this._client);

  final sp.Client _client;

  @override
  Future<List<RoutineDay>> getRoutineDays() async {
    final serverDays = await _client.routine.getRoutineDays();
    return Future.wait([
      for (final day in serverDays) _fetchDayWithExercises(day),
    ]);
  }

  Future<RoutineDay> _fetchDayWithExercises(sp.RoutineDay day) async {
    final exercises = await _client.routine.getExercises(dayId: day.id!);
    return RoutineDay(
      id: day.id!.toString(),
      title: day.title,
      focusAreas: day.focusAreas,
      exercises: [
        for (final ex in exercises)
          ExerciseTemplate(
            id: ex.id!.toString(),
            name: ex.name,
            note: ex.note,
          ),
      ],
    );
  }

  @override
  Future<void> updateDayMetadata({
    required String dayId,
    required String title,
    required List<String> focusAreas,
  }) {
    return _client.routine.updateRoutineDay(
      dayId: int.parse(dayId),
      title: title,
      focusAreas: focusAreas,
    );
  }

  @override
  Future<ExerciseTemplate> addExercise({
    required String dayId,
    required String name,
    String? note,
  }) async {
    final ex = await _client.routine.addExercise(
      dayId: int.parse(dayId),
      name: name,
      note: note,
    );
    return ExerciseTemplate(
      id: ex.id!.toString(),
      name: ex.name,
      note: ex.note,
    );
  }

  @override
  Future<void> updateExercise({
    required String dayId,
    required String exerciseId,
    required String name,
    String? note,
  }) {
    return _client.routine.updateExercise(
      exerciseId: int.parse(exerciseId),
      name: name,
      note: note,
    );
  }

  @override
  Future<void> removeExercise({
    required String dayId,
    required String exerciseId,
  }) {
    return _client.routine.removeExercise(exerciseId: int.parse(exerciseId));
  }

  @override
  Future<void> reorderExercises({
    required String dayId,
    required int oldIndex,
    required int newIndex,
  }) async {
    final exercises = await _client.routine.getExercises(
      dayId: int.parse(dayId),
    );
    final ids = [...exercises.map((e) => e.id!)];

    var targetIndex = newIndex;
    if (targetIndex > oldIndex) targetIndex -= 1;

    final moved = ids.removeAt(oldIndex);
    ids.insert(targetIndex, moved);

    await _client.routine.reorderExercises(
      dayId: int.parse(dayId),
      exerciseIdsInOrder: ids,
    );
  }
}
