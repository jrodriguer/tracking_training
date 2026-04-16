class RoutineDay {
  const RoutineDay({
    required this.id,
    required this.title,
    required this.focusAreas,
    required this.exercises,
  });

  final String id;
  final String title;
  final List<String> focusAreas;
  final List<ExerciseTemplate> exercises;

  RoutineDay copyWith({
    String? title,
    List<String>? focusAreas,
    List<ExerciseTemplate>? exercises,
  }) {
    return RoutineDay(
      id: id,
      title: title ?? this.title,
      focusAreas: focusAreas ?? this.focusAreas,
      exercises: exercises ?? this.exercises,
    );
  }
}

class ExerciseTemplate {
  const ExerciseTemplate({required this.id, required this.name, this.note});

  final String id;
  final String name;
  final String? note;

  ExerciseTemplate copyWith({String? name, String? note}) {
    return ExerciseTemplate(
      id: id,
      name: name ?? this.name,
      note: note ?? this.note,
    );
  }
}
