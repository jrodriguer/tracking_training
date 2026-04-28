import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/application/auth_controller.dart';
import '../data/routine_repository.dart';
import '../domain/routine_models.dart';

/// Default repository – returns the hard-coded seed routine so that all tests
/// work without overrides.  Production code overrides this with
/// [ServerpodRoutineRepository] in `main.dart`.
final routineRepositoryProvider = Provider<RoutineRepository>(
  (ref) => const FakeRoutineRepository(),
);

final routineControllerProvider =
    AsyncNotifierProvider<RoutineController, List<RoutineDay>>(
      RoutineController.new,
    );

final routineDayByIdProvider = Provider.family<RoutineDay?, String>((ref, id) {
  final days = ref.watch(routineControllerProvider).value ?? const [];
  for (final day in days) {
    if (day.id == id) return day;
  }
  return null;
});

class RoutineController extends AsyncNotifier<List<RoutineDay>> {
  RoutineRepository get _repository => ref.read(routineRepositoryProvider);

  @override
  Future<List<RoutineDay>> build() async {
    final authState = ref.watch(authControllerProvider);
    if (authState is! SignedIn) return const [];
    return _repository.getRoutineDays();
  }

  Future<void> updateDayMetadata({
    required String dayId,
    required String title,
    required List<String> focusAreas,
  }) async {
    await _repository.updateDayMetadata(
      dayId: dayId,
      title: title,
      focusAreas: focusAreas,
    );
    state = AsyncData([
      for (final day in state.requireValue)
        if (day.id == dayId)
          day.copyWith(title: title, focusAreas: focusAreas)
        else
          day,
    ]);
  }

  Future<void> addExercise({
    required String dayId,
    required String name,
    String? note,
  }) async {
    final newExercise = await _repository.addExercise(
      dayId: dayId,
      name: name,
      note: note,
    );
    state = AsyncData([
      for (final day in state.requireValue)
        if (day.id == dayId)
          day.copyWith(exercises: [...day.exercises, newExercise])
        else
          day,
    ]);
  }

  Future<void> updateExercise({
    required String dayId,
    required String exerciseId,
    required String name,
    String? note,
  }) async {
    await _repository.updateExercise(
      dayId: dayId,
      exerciseId: exerciseId,
      name: name,
      note: note,
    );
    state = AsyncData([
      for (final day in state.requireValue)
        if (day.id == dayId)
          day.copyWith(
            exercises: [
              for (final exercise in day.exercises)
                if (exercise.id == exerciseId)
                  exercise.copyWith(name: name, note: note)
                else
                  exercise,
            ],
          )
        else
          day,
    ]);
  }

  Future<void> removeExercise({
    required String dayId,
    required String exerciseId,
  }) async {
    await _repository.removeExercise(
      dayId: dayId,
      exerciseId: exerciseId,
    );
    state = AsyncData([
      for (final day in state.requireValue)
        if (day.id == dayId)
          day.copyWith(
            exercises: [
              for (final exercise in day.exercises)
                if (exercise.id != exerciseId) exercise,
            ],
          )
        else
          day,
    ]);
  }

  Future<void> reorderExercise({
    required String dayId,
    required int oldIndex,
    required int newIndex,
  }) async {
    await _repository.reorderExercises(
      dayId: dayId,
      oldIndex: oldIndex,
      newIndex: newIndex,
    );
    state = AsyncData([
      for (final day in state.requireValue)
        if (day.id == dayId)
          day.copyWith(
            exercises: _reorder(
              day.exercises,
              oldIndex: oldIndex,
              newIndex: newIndex,
            ),
          )
        else
          day,
    ]);
  }

  List<ExerciseTemplate> _reorder(
    List<ExerciseTemplate> exercises, {
    required int oldIndex,
    required int newIndex,
  }) {
    final values = [...exercises];
    var targetIndex = newIndex;

    if (targetIndex > oldIndex) {
      targetIndex -= 1;
    }

    final moved = values.removeAt(oldIndex);
    values.insert(targetIndex, moved);
    return values;
  }
}

// ── Fake repository ──────────────────────────────────────────────────────────

/// In-memory repository that returns the hard-coded seed routine.
/// Used as the default so that unit and widget tests require no overrides.
class FakeRoutineRepository implements RoutineRepository {
  const FakeRoutineRepository();

  @override
  Future<List<RoutineDay>> getRoutineDays() async => _seedRoutine;

  @override
  Future<void> updateDayMetadata({
    required String dayId,
    required String title,
    required List<String> focusAreas,
  }) async {}

  @override
  Future<ExerciseTemplate> addExercise({
    required String dayId,
    required String name,
    String? note,
  }) async {
    final micros = DateTime.now().microsecondsSinceEpoch;
    return ExerciseTemplate(id: 'exercise-$micros', name: name, note: note);
  }

  @override
  Future<void> updateExercise({
    required String dayId,
    required String exerciseId,
    required String name,
    String? note,
  }) async {}

  @override
  Future<void> removeExercise({
    required String dayId,
    required String exerciseId,
  }) async {}

  @override
  Future<void> reorderExercises({
    required String dayId,
    required int oldIndex,
    required int newIndex,
  }) async {}
}

const _seedRoutine = [
  RoutineDay(
    id: 'day-1',
    title: 'Day 1',
    focusAreas: ['Chest', 'Shoulders', 'Triceps'],
    exercises: [
      ExerciseTemplate(id: 'd1-ex1', name: 'Barbell Bench Press'),
      ExerciseTemplate(id: 'd1-ex2', name: 'Seated Dumbbell Shoulder Press'),
      ExerciseTemplate(id: 'd1-ex3', name: 'Cable Triceps Pushdown'),
    ],
  ),
  RoutineDay(
    id: 'day-2',
    title: 'Day 2',
    focusAreas: ['Back', 'Biceps'],
    exercises: [
      ExerciseTemplate(id: 'd2-ex1', name: 'Lat Pulldown'),
      ExerciseTemplate(id: 'd2-ex2', name: 'Chest-Supported Row'),
      ExerciseTemplate(id: 'd2-ex3', name: 'Dumbbell Hammer Curl'),
    ],
  ),
  RoutineDay(
    id: 'day-3',
    title: 'Day 3',
    focusAreas: ['Legs', 'Abs'],
    exercises: [
      ExerciseTemplate(id: 'd3-ex1', name: 'Back Squat'),
      ExerciseTemplate(id: 'd3-ex2', name: 'Romanian Deadlift'),
      ExerciseTemplate(id: 'd3-ex3', name: 'Hanging Knee Raise'),
    ],
  ),
  RoutineDay(
    id: 'day-4',
    title: 'Day 4',
    focusAreas: ['Cardio'],
    exercises: [
      ExerciseTemplate(
        id: 'd4-ex1',
        name: 'Incline Treadmill Walk',
        note: 'Steady 20-30 minutes',
      ),
    ],
  ),
];
