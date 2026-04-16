import '../../workouts/domain/workout_models.dart';

enum ProgressRange {
  all(label: 'All'),
  last30Days(label: '30 days', days: 30),
  last90Days(label: '90 days', days: 90);

  const ProgressRange({required this.label, this.days});

  final String label;
  final int? days;
}

class ExerciseProgressSeries {
  const ExerciseProgressSeries({
    required this.exerciseTemplateId,
    required this.exerciseName,
    required this.records,
  });

  final String exerciseTemplateId;
  final String exerciseName;
  final List<ExerciseProgressRecord> records;
}

class ExerciseProgressRecord {
  const ExerciseProgressRecord({
    required this.sessionId,
    required this.sessionDate,
    required this.totalReps,
    required this.maxWeight,
    required this.totalVolume,
    required this.notes,
  });

  final String sessionId;
  final DateTime sessionDate;
  final int totalReps;
  final double maxWeight;
  final double totalVolume;
  final String? notes;
}

List<ExerciseProgressSeries> buildExerciseProgressSeries(
  List<WorkoutSession> sessions, {
  ProgressRange range = ProgressRange.all,
  DateTime? now,
}) {
  final cutoff = _cutoffFor(range, now: now);
  final byExercise = <String, List<ExerciseProgressRecord>>{};
  final exerciseNames = <String, String>{};

  for (final session in sessions) {
    if (cutoff case final cutoffDate?) {
      if (session.startedAt.isBefore(cutoffDate)) {
        continue;
      }
    }

    for (final entry in session.entries) {
      final totalReps = entry.sets.fold<int>(0, (sum, set) => sum + set.reps);
      final maxWeight = entry.sets.fold<double>(
        0,
        (max, set) => set.weight > max ? set.weight : max,
      );
      final totalVolume = entry.sets.fold<double>(
        0,
        (sum, set) => sum + (set.reps * set.weight),
      );

      final notes = entry.sets
          .map((set) => set.note?.trim())
          .whereType<String>()
          .where((value) => value.isNotEmpty)
          .toSet()
          .join(' | ');

      final record = ExerciseProgressRecord(
        sessionId: session.id,
        sessionDate: session.startedAt,
        totalReps: totalReps,
        maxWeight: maxWeight,
        totalVolume: totalVolume,
        notes: notes.isEmpty ? null : notes,
      );

      exerciseNames[entry.exerciseTemplateId] = entry.exerciseName;
      byExercise.putIfAbsent(entry.exerciseTemplateId, () => []).add(record);
    }
  }

  final results = [
    for (final item in byExercise.entries)
      ExerciseProgressSeries(
        exerciseTemplateId: item.key,
        exerciseName: exerciseNames[item.key] ?? 'Unknown exercise',
        records: [...item.value]
          ..sort((a, b) => a.sessionDate.compareTo(b.sessionDate)),
      ),
  ];

  results.sort((a, b) => a.exerciseName.compareTo(b.exerciseName));
  return results;
}

DateTime? _cutoffFor(ProgressRange range, {DateTime? now}) {
  final days = range.days;

  if (days == null) {
    return null;
  }

  final current = now ?? DateTime.now();
  final startOfDay = DateTime(current.year, current.month, current.day);
  return startOfDay.subtract(Duration(days: days));
}
