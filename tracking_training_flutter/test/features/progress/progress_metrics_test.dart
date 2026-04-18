import 'package:flutter_test/flutter_test.dart';

import 'package:tracking_training_flutter/features/progress/domain/progress_metrics.dart';
import 'package:tracking_training_flutter/features/workouts/domain/workout_models.dart';

void main() {
  group('ProgressMetrics.maxWeightByDate', () {
    test('returns empty list when sessions is empty', () {
      final points = ProgressMetrics.maxWeightByDate(
        exerciseId: 'ex-1',
        sessions: const [],
      );
      expect(points, isEmpty);
    });

    test('returns empty list when exercise is not in sessions', () {
      final points = ProgressMetrics.maxWeightByDate(
        exerciseId: 'ex-99',
        sessions: [_session('s-1', DateTime(2026, 1, 10), 'ex-1', 80)],
      );
      expect(points, isEmpty);
    });

    test('returns a single point for one session', () {
      final points = ProgressMetrics.maxWeightByDate(
        exerciseId: 'ex-1',
        sessions: [_session('s-1', DateTime(2026, 1, 10), 'ex-1', 80)],
      );
      expect(points, hasLength(1));
      expect(points.first.value, 80);
      expect(points.first.date, DateTime(2026, 1, 10));
    });

    test(
      'picks the maximum weight when multiple sets logged on the same day',
      () {
        final session = WorkoutSession(
          id: 's-1',
          routineDayId: 'd-1',
          routineDayTitle: 'Day 1',
          createdAt: DateTime(2026, 1, 10),
          startedAt: DateTime(2026, 1, 10, 9),
          updatedAt: DateTime(2026, 1, 10, 10),
          entries: [
            WorkoutEntry(
              id: 'e-1',
              exerciseTemplateId: 'ex-1',
              exerciseName: 'Squat',
              sets: const [
                WorkoutSet(id: 'set-1', setNumber: 1, reps: 5, weight: 60),
                WorkoutSet(id: 'set-2', setNumber: 2, reps: 5, weight: 80),
                WorkoutSet(id: 'set-3', setNumber: 3, reps: 3, weight: 90),
              ],
            ),
          ],
        );

        final points = ProgressMetrics.maxWeightByDate(
          exerciseId: 'ex-1',
          sessions: [session],
        );

        expect(points, hasLength(1));
        expect(points.first.value, 90);
      },
    );

    test('collapses two sessions on the same day to one point (max)', () {
      final points = ProgressMetrics.maxWeightByDate(
        exerciseId: 'ex-1',
        sessions: [
          _session('s-1', DateTime(2026, 1, 10, 9), 'ex-1', 80),
          _session('s-2', DateTime(2026, 1, 10, 18), 'ex-1', 95),
        ],
      );

      expect(points, hasLength(1));
      expect(points.first.value, 95);
    });

    test('returns points sorted ascending by date', () {
      final points = ProgressMetrics.maxWeightByDate(
        exerciseId: 'ex-1',
        sessions: [
          _session('s-3', DateTime(2026, 1, 20), 'ex-1', 100),
          _session('s-1', DateTime(2026, 1, 10), 'ex-1', 80),
          _session('s-2', DateTime(2026, 1, 15), 'ex-1', 90),
        ],
      );

      expect(points.map((p) => p.value), orderedEquals([80, 90, 100]));
    });

    test('ignores sessions for other exercises', () {
      final points = ProgressMetrics.maxWeightByDate(
        exerciseId: 'ex-1',
        sessions: [
          _session('s-1', DateTime(2026, 1, 10), 'ex-2', 200),
          _session('s-2', DateTime(2026, 1, 11), 'ex-1', 85),
        ],
      );

      expect(points, hasLength(1));
      expect(points.first.value, 85);
    });
  });

  group('ProgressMetrics.volumeByDate', () {
    test('returns empty list when sessions is empty', () {
      final points = ProgressMetrics.volumeByDate(
        exerciseId: 'ex-1',
        sessions: const [],
      );
      expect(points, isEmpty);
    });

    test('computes volume as sum of reps × weight for a single session', () {
      final session = WorkoutSession(
        id: 's-1',
        routineDayId: 'd-1',
        routineDayTitle: 'Day 1',
        createdAt: DateTime(2026, 1, 10),
        startedAt: DateTime(2026, 1, 10),
        updatedAt: DateTime(2026, 1, 10),
        entries: [
          WorkoutEntry(
            id: 'e-1',
            exerciseTemplateId: 'ex-1',
            exerciseName: 'Deadlift',
            sets: const [
              WorkoutSet(id: 'set-1', setNumber: 1, reps: 5, weight: 100),
              WorkoutSet(id: 'set-2', setNumber: 2, reps: 5, weight: 110),
            ],
          ),
        ],
      );

      final points = ProgressMetrics.volumeByDate(
        exerciseId: 'ex-1',
        sessions: [session],
      );

      // 5×100 + 5×110 = 500 + 550 = 1050
      expect(points, hasLength(1));
      expect(points.first.value, 1050);
    });

    test('accumulates volume across two sessions on the same day', () {
      final points = ProgressMetrics.volumeByDate(
        exerciseId: 'ex-1',
        sessions: [
          _session('s-1', DateTime(2026, 1, 10, 9), 'ex-1', 100, reps: 5),
          _session('s-2', DateTime(2026, 1, 10, 18), 'ex-1', 80, reps: 3),
        ],
      );

      // 5×100 + 3×80 = 500 + 240 = 740
      expect(points, hasLength(1));
      expect(points.first.value, 740);
    });

    test('returns points sorted ascending by date', () {
      final points = ProgressMetrics.volumeByDate(
        exerciseId: 'ex-1',
        sessions: [
          _session('s-2', DateTime(2026, 1, 15), 'ex-1', 90, reps: 5),
          _session('s-1', DateTime(2026, 1, 10), 'ex-1', 80, reps: 5),
        ],
      );

      expect(points.map((p) => p.date.day), orderedEquals([10, 15]));
    });
  });
}

// ── Helpers ────────────────────────────────────────────────────────────────

/// Creates a [WorkoutSession] with a single entry for [exerciseId] and one set.
WorkoutSession _session(
  String id,
  DateTime date,
  String exerciseId,
  double weight, {
  int reps = 5,
}) {
  return WorkoutSession(
    id: id,
    routineDayId: 'd-1',
    routineDayTitle: 'Day 1',
    createdAt: date,
    startedAt: date,
    updatedAt: date,
    entries: [
      WorkoutEntry(
        id: 'entry-$id',
        exerciseTemplateId: exerciseId,
        exerciseName: 'Exercise',
        sets: [
          WorkoutSet(
            id: 'set-$id',
            setNumber: 1,
            reps: reps,
            weight: weight,
          ),
        ],
      ),
    ],
  );
}
