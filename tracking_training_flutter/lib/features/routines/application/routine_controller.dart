import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/routine_models.dart';

final routineControllerProvider =
    NotifierProvider<RoutineController, List<RoutineDay>>(
      RoutineController.new,
    );

final routineDayByIdProvider = Provider.family<RoutineDay?, String>((ref, id) {
  final days = ref.watch(routineControllerProvider);

  for (final day in days) {
    if (day.id == id) {
      return day;
    }
  }

  return null;
});

class RoutineController extends Notifier<List<RoutineDay>> {
  @override
  List<RoutineDay> build() => _seedRoutine;

  void updateDayMetadata({
    required String dayId,
    required String title,
    required List<String> focusAreas,
  }) {
    state = [
      for (final day in state)
        if (day.id == dayId)
          day.copyWith(title: title, focusAreas: focusAreas)
        else
          day,
    ];
  }

  void addExercise({
    required String dayId,
    required String name,
    String? note,
  }) {
    final newExercise = ExerciseTemplate(
      id: _buildId('exercise'),
      name: name,
      note: note,
    );

    state = [
      for (final day in state)
        if (day.id == dayId)
          day.copyWith(exercises: [...day.exercises, newExercise])
        else
          day,
    ];
  }

  void updateExercise({
    required String dayId,
    required String exerciseId,
    required String name,
    String? note,
  }) {
    state = [
      for (final day in state)
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
    ];
  }

  void removeExercise({required String dayId, required String exerciseId}) {
    state = [
      for (final day in state)
        if (day.id == dayId)
          day.copyWith(
            exercises: [
              for (final exercise in day.exercises)
                if (exercise.id != exerciseId) exercise,
            ],
          )
        else
          day,
    ];
  }

  void reorderExercise({
    required String dayId,
    required int oldIndex,
    required int newIndex,
  }) {
    state = [
      for (final day in state)
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
    ];
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

  String _buildId(String prefix) {
    final micros = DateTime.now().microsecondsSinceEpoch;
    return '$prefix-$micros';
  }
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
