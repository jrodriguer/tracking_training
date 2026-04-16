import '../../workouts/domain/workout_models.dart';

/// A single point in a progress series: a calendar date and a value.
class ProgressPoint {
  const ProgressPoint({required this.date, required this.value});

  final DateTime date;
  final double value;
}

/// Pure-Dart utilities for computing per-exercise progress metrics.
abstract final class ProgressMetrics {
  /// Returns the maximum weight lifted for [exerciseId] on each calendar day
  /// across all [sessions], sorted ascending by date.
  static List<ProgressPoint> maxWeightByDate({
    required String exerciseId,
    required List<WorkoutSession> sessions,
  }) {
    final byDate = <DateTime, double>{};
    for (final session in sessions) {
      final date = _dateOnly(session.startedAt);
      for (final entry in session.entries) {
        if (entry.exerciseTemplateId != exerciseId) continue;
        for (final set in entry.sets) {
          final current = byDate[date] ?? 0;
          if (set.weight > current) byDate[date] = set.weight;
        }
      }
    }
    return _sorted(byDate);
  }

  /// Returns the total volume (Σ reps × weight) for [exerciseId] on each
  /// calendar day across all [sessions], sorted ascending by date.
  static List<ProgressPoint> volumeByDate({
    required String exerciseId,
    required List<WorkoutSession> sessions,
  }) {
    final byDate = <DateTime, double>{};
    for (final session in sessions) {
      final date = _dateOnly(session.startedAt);
      for (final entry in session.entries) {
        if (entry.exerciseTemplateId != exerciseId) continue;
        for (final set in entry.sets) {
          byDate[date] = (byDate[date] ?? 0) + set.reps * set.weight;
        }
      }
    }
    return _sorted(byDate);
  }

  static DateTime _dateOnly(DateTime dt) =>
      DateTime(dt.year, dt.month, dt.day);

  static List<ProgressPoint> _sorted(Map<DateTime, double> byDate) {
    final points = [
      for (final e in byDate.entries) ProgressPoint(date: e.key, value: e.value),
    ];
    points.sort((a, b) => a.date.compareTo(b.date));
    return points;
  }
}
