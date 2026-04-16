import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../workouts/application/workout_controller.dart';
import '../../workouts/domain/workout_models.dart';
import '../domain/progress_metrics.dart';
import 'widgets/progress_chart.dart';

class ProgressPage extends ConsumerWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutStateValue = ref.watch(workoutControllerProvider);

    return workoutStateValue.when(
      data: (state) => _buildBody(context, state.sessions),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) =>
          Center(child: Text('Error loading progress: $error')),
    );
  }

  Widget _buildBody(BuildContext context, List<WorkoutSession> sessions) {
    if (sessions.isEmpty) {
      return ListView(
        children: const [
          Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Log some workouts to see your progress charts here.',
              ),
            ),
          ),
        ],
      );
    }

    // Collect unique exercises (preserves first-seen order).
    final seen = <String>{};
    final exercises = <({String id, String name})>[];
    for (final session in sessions) {
      for (final entry in session.entries) {
        if (seen.add(entry.exerciseTemplateId)) {
          exercises.add((
            id: entry.exerciseTemplateId,
            name: entry.exerciseName,
          ));
        }
      }
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: exercises.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final exercise = exercises[index];
        final points = ProgressMetrics.maxWeightByDate(
          exerciseId: exercise.id,
          sessions: sessions,
        );

        return Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise.name,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  'Max weight per session',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall!.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 16),
                ProgressChart(points: points),
              ],
            ),
          ),
        );
      },
    );
  }
}
