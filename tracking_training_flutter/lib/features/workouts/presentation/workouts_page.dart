import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../routines/application/routine_controller.dart';
import '../../routines/domain/routine_models.dart';
import '../application/workout_controller.dart';
import '../domain/workout_models.dart';

class WorkoutsPage extends ConsumerStatefulWidget {
  const WorkoutsPage({super.key});

  @override
  ConsumerState<WorkoutsPage> createState() => _WorkoutsPageState();
}

class _WorkoutsPageState extends ConsumerState<WorkoutsPage> {
  String? _selectedDayId;
  DateTime _selectedWorkoutDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  Widget build(BuildContext context) {
    final days = ref.watch(routineControllerProvider);
    final workoutStateValue = ref.watch(workoutControllerProvider);

    _selectedDayId ??= days.isNotEmpty ? days.first.id : null;

    return workoutStateValue.when(
      data: (workoutState) => _buildBody(context, days, workoutState),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) =>
          Center(child: Text('Error loading workouts: $error')),
    );
  }

  Widget _buildBody(
    BuildContext context,
    List<RoutineDay> days,
    WorkoutState workoutState,
  ) {
    final selectedDay = _resolveSelectedDay(days);
    final isEditingSavedSession =
        workoutState.activeSession != null &&
        workoutState.sessions.any(
          (session) => session.id == workoutState.activeSession!.id,
        );

    return ListView(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Start session',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Routine day',
                    border: OutlineInputBorder(),
                  ),
                  child: DropdownButton<String>(
                    value: selectedDay?.id,
                    isExpanded: true,
                    underline: const SizedBox.shrink(),
                    items: [
                      for (final day in days)
                        DropdownMenuItem(value: day.id, child: Text(day.title)),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedDayId = value;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 12),
                _DatePickerField(
                  label: 'Workout date',
                  date: _selectedWorkoutDate,
                  onChanged: (date) {
                    setState(() => _selectedWorkoutDate = date);
                  },
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed:
                      selectedDay == null || workoutState.activeSession != null
                      ? null
                      : () => ref
                            .read(workoutControllerProvider.notifier)
                            .startSession(
                              selectedDay,
                              workoutDate: _selectedWorkoutDate,
                            ),
                  icon: const Icon(Icons.play_arrow_outlined),
                  label: const Text('Start workout session'),
                ),
                if (workoutState.activeSession != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Save or discard the active session before starting a new one.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (workoutState.activeSession case final activeSession?)
          _ActiveSessionCard(session: activeSession)
        else
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'No active session. Start a workout from a routine day above.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
        if (!isEditingSavedSession) ...[
          const SizedBox(height: 12),
          _SessionHistoryCard(sessions: workoutState.sessions),
        ],
      ],
    );
  }

  RoutineDay? _resolveSelectedDay(List<RoutineDay> days) {
    final selectedDayId = _selectedDayId;

    if (selectedDayId == null) {
      return null;
    }

    for (final day in days) {
      if (day.id == selectedDayId) {
        return day;
      }
    }

    return days.isEmpty ? null : days.first;
  }
}

class _ActiveSessionCard extends ConsumerWidget {
  const _ActiveSessionCard({required this.session});

  final WorkoutSession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateLabel = DateFormat('EEE, MMM d yyyy').format(session.startedAt);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Active session: ${session.routineDayTitle}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(child: Text(dateLabel)),
                IconButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: session.startedAt,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (picked == null || !context.mounted) return;
                    ref
                        .read(workoutControllerProvider.notifier)
                        .updateSessionDate(picked);
                  },
                  icon: const Icon(Icons.edit_calendar_outlined),
                  tooltip: 'Change workout date',
                ),
              ],
            ),
            const SizedBox(height: 12),
            for (final entry in session.entries)
              _ExerciseEntryEditor(entry: entry, sessionId: session.id),
            const SizedBox(height: 8),
            Row(
              children: [
                OutlinedButton(
                  onPressed: () => ref
                      .read(workoutControllerProvider.notifier)
                      .discardActiveSession(),
                  child: const Text('Discard'),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () async {
                    await ref
                        .read(workoutControllerProvider.notifier)
                        .saveActiveSession();

                    if (!context.mounted) {
                      return;
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Workout session saved.')),
                    );
                  },
                  child: const Text('Save session'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ExerciseEntryEditor extends ConsumerWidget {
  const _ExerciseEntryEditor({required this.entry, required this.sessionId});

  final WorkoutEntry entry;
  final String sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    entry.exerciseName,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                TextButton.icon(
                  onPressed: () async {
                    final input = await _showSetEditorDialog(context);

                    if (input == null) {
                      return;
                    }

                    ref
                        .read(workoutControllerProvider.notifier)
                        .addSet(
                          entryId: entry.id,
                          setNumber: input.setNumber,
                          reps: input.reps,
                          weight: input.weight,
                          note: input.note,
                        );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add set'),
                ),
              ],
            ),
            if (entry.sets.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text('No sets yet.'),
              )
            else
              for (final set in entry.sets)
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Set ${set.setNumber}: ${set.reps} reps @ ${set.weight.toStringAsFixed(1)} kg',
                  ),
                  subtitle: switch (set.note) {
                    final note? => Text(note),
                    null => const Text('No note'),
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () async {
                          final input = await _showSetEditorDialog(
                            context,
                            initialSetNumber: set.setNumber,
                            initialReps: set.reps,
                            initialWeight: set.weight,
                            initialNote: set.note,
                          );

                          if (input == null) {
                            return;
                          }

                          ref
                              .read(workoutControllerProvider.notifier)
                              .updateSet(
                                entryId: entry.id,
                                setId: set.id,
                                setNumber: input.setNumber,
                                reps: input.reps,
                                weight: input.weight,
                                note: input.note,
                              );
                        },
                        icon: const Icon(Icons.edit_outlined),
                        tooltip: 'Edit set',
                      ),
                      IconButton(
                        onPressed: () => ref
                            .read(workoutControllerProvider.notifier)
                            .removeSet(entryId: entry.id, setId: set.id),
                        icon: const Icon(Icons.delete_outline),
                        tooltip: 'Delete set',
                      ),
                    ],
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

class _SessionHistoryCard extends ConsumerWidget {
  const _SessionHistoryCard({required this.sessions});

  final List<WorkoutSession> sessions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutValue = ref.watch(workoutControllerProvider).value;
    final hasActiveSession = workoutValue?.activeSession != null;
    final activeSessionId = workoutValue?.activeSession?.id;

    final visibleSessions = [
      for (final session in sessions)
        if (session.id != activeSessionId) session,
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Session history',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            if (visibleSessions.isEmpty)
              const Text('No sessions logged yet.')
            else
              for (final session in visibleSessions)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(session.routineDayTitle),
                  subtitle: Text(
                    '${DateFormat('EEE, MMM d yyyy').format(session.startedAt)}'
                    ' · ${session.entries.length} exercises',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        tooltip: 'Edit session',
                        onPressed: () => _onEditSession(
                          context,
                          ref,
                          session,
                          hasActiveSession,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        tooltip: 'Delete session',
                        onPressed: () =>
                            _onDeleteSession(context, ref, session),
                      ),
                    ],
                  ),
                  onTap: () {
                    showModalBottomSheet<void>(
                      context: context,
                      showDragHandle: true,
                      builder: (_) => _SessionDetailSheet(session: session),
                    );
                  },
                ),
          ],
        ),
      ),
    );
  }

  Future<void> _onEditSession(
    BuildContext context,
    WidgetRef ref,
    WorkoutSession session,
    bool hasActiveSession,
  ) async {
    if (hasActiveSession) {
      final action = await _showActiveSessionConflictDialog(context);
      if (!context.mounted) return;
      switch (action) {
        case _ConflictAction.save:
          await ref
              .read(workoutControllerProvider.notifier)
              .saveActiveSession();
          if (!context.mounted) return;
        case _ConflictAction.discard:
          ref.read(workoutControllerProvider.notifier).discardActiveSession();
        case null:
          return;
      }
    }
    ref.read(workoutControllerProvider.notifier).editSavedSession(session);
  }

  Future<void> _onDeleteSession(
    BuildContext context,
    WidgetRef ref,
    WorkoutSession session,
  ) async {
    final dateLabel = DateFormat('MMM d yyyy').format(session.startedAt);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete session'),
        content: Text(
          'Delete the ${session.routineDayTitle} session on '
          '$dateLabel? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;
    await ref
        .read(workoutControllerProvider.notifier)
        .deleteSession(session.id);
  }

  Future<_ConflictAction?> _showActiveSessionConflictDialog(
    BuildContext context,
  ) {
    return showDialog<_ConflictAction>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Unsaved session'),
        content: const Text(
          'You have an unsaved active session. '
          'Save or discard it before editing another.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          OutlinedButton(
            onPressed: () => Navigator.of(ctx).pop(_ConflictAction.discard),
            child: const Text('Discard'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(_ConflictAction.save),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

enum _ConflictAction { save, discard }

class _SessionDetailSheet extends StatelessWidget {
  const _SessionDetailSheet({required this.session});

  final WorkoutSession session;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              session.routineDayTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('EEE, MMM d yyyy').format(session.startedAt),
            ),
            const SizedBox(height: 16),
            for (final entry in session.entries)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.exerciseName,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),
                      for (final set in entry.sets)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            'Set ${set.setNumber}: ${set.reps} reps @ ${set.weight.toStringAsFixed(1)} kg${set.note == null ? '' : ' (${set.note})'}',
                          ),
                        ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DatePickerField extends StatelessWidget {
  const _DatePickerField({
    required this.label,
    required this.date,
    required this.onChanged,
  });

  final String label;
  final DateTime date;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(4),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        );
        if (picked == null || !context.mounted) return;
        onChanged(picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.calendar_today_outlined),
        ),
        child: Text(DateFormat('EEE, MMM d yyyy').format(date)),
      ),
    );
  }
}

Future<({int setNumber, int reps, double weight, String? note})?>
_showSetEditorDialog(
  BuildContext context, {
  int initialSetNumber = 1,
  int initialReps = 0,
  double initialWeight = 0,
  String? initialNote,
}) {
  final setController = TextEditingController(
    text: initialSetNumber.toString(),
  );
  final repsController = TextEditingController(text: initialReps.toString());
  final weightController = TextEditingController(
    text: initialWeight.toStringAsFixed(1),
  );
  final noteController = TextEditingController(text: initialNote ?? '');

  return showDialog<({int setNumber, int reps, double weight, String? note})>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Set details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: setController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Set number'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: repsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Reps'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: weightController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(labelText: 'Weight (kg)'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: noteController,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(labelText: 'Note (optional)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final setNumber = int.tryParse(setController.text.trim());
              final reps = int.tryParse(repsController.text.trim());
              final weight = double.tryParse(weightController.text.trim());

              if (setNumber == null || reps == null || weight == null) {
                return;
              }

              if (setNumber < 1 || reps < 0 || weight < 0) {
                return;
              }

              final note = noteController.text.trim();
              Navigator.of(context).pop((
                setNumber: setNumber,
                reps: reps,
                weight: weight,
                note: note.isEmpty ? null : note,
              ));
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}
