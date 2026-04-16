class WorkoutSet {
  const WorkoutSet({
    required this.id,
    required this.setNumber,
    required this.reps,
    required this.weight,
    this.note,
  });

  final String id;
  final int setNumber;
  final int reps;
  final double weight;
  final String? note;

  WorkoutSet copyWith({
    int? setNumber,
    int? reps,
    double? weight,
    String? note,
    bool clearNote = false,
  }) {
    return WorkoutSet(
      id: id,
      setNumber: setNumber ?? this.setNumber,
      reps: reps ?? this.reps,
      weight: weight ?? this.weight,
      note: clearNote ? null : (note ?? this.note),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'setNumber': setNumber,
      'reps': reps,
      'weight': weight,
      'note': note,
    };
  }

  factory WorkoutSet.fromJson(Map<String, dynamic> json) {
    return WorkoutSet(
      id: json['id'] as String,
      setNumber: (json['setNumber'] as num).toInt(),
      reps: (json['reps'] as num).toInt(),
      weight: (json['weight'] as num).toDouble(),
      note: json['note'] as String?,
    );
  }
}

class WorkoutEntry {
  const WorkoutEntry({
    required this.id,
    required this.exerciseTemplateId,
    required this.exerciseName,
    required this.sets,
  });

  final String id;
  final String exerciseTemplateId;
  final String exerciseName;
  final List<WorkoutSet> sets;

  WorkoutEntry copyWith({String? exerciseName, List<WorkoutSet>? sets}) {
    return WorkoutEntry(
      id: id,
      exerciseTemplateId: exerciseTemplateId,
      exerciseName: exerciseName ?? this.exerciseName,
      sets: sets ?? this.sets,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'exerciseTemplateId': exerciseTemplateId,
      'exerciseName': exerciseName,
      'sets': [for (final set in sets) set.toJson()],
    };
  }

  factory WorkoutEntry.fromJson(Map<String, dynamic> json) {
    final rawSets = (json['sets'] as List<dynamic>? ?? const []);

    return WorkoutEntry(
      id: json['id'] as String,
      exerciseTemplateId: json['exerciseTemplateId'] as String,
      exerciseName: json['exerciseName'] as String,
      sets: [
        for (final rawSet in rawSets)
          WorkoutSet.fromJson(rawSet as Map<String, dynamic>),
      ],
    );
  }
}

class WorkoutSession {
  const WorkoutSession({
    required this.id,
    required this.routineDayId,
    required this.routineDayTitle,
    required this.startedAt,
    required this.updatedAt,
    required this.entries,
  });

  final String id;
  final String routineDayId;
  final String routineDayTitle;
  final DateTime startedAt;
  final DateTime updatedAt;
  final List<WorkoutEntry> entries;

  WorkoutSession copyWith({
    String? routineDayTitle,
    DateTime? updatedAt,
    List<WorkoutEntry>? entries,
  }) {
    return WorkoutSession(
      id: id,
      routineDayId: routineDayId,
      routineDayTitle: routineDayTitle ?? this.routineDayTitle,
      startedAt: startedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      entries: entries ?? this.entries,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'routineDayId': routineDayId,
      'routineDayTitle': routineDayTitle,
      'startedAt': startedAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'entries': [for (final entry in entries) entry.toJson()],
    };
  }

  factory WorkoutSession.fromJson(Map<String, dynamic> json) {
    final rawEntries = (json['entries'] as List<dynamic>? ?? const []);

    return WorkoutSession(
      id: json['id'] as String,
      routineDayId: json['routineDayId'] as String,
      routineDayTitle: json['routineDayTitle'] as String,
      startedAt: DateTime.parse(json['startedAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      entries: [
        for (final rawEntry in rawEntries)
          WorkoutEntry.fromJson(rawEntry as Map<String, dynamic>),
      ],
    );
  }
}
