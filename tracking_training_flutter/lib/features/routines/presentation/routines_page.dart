import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/utils/breakpoints.dart';
import '../application/routine_controller.dart';
import '../domain/routine_models.dart';

class RoutinesPage extends ConsumerStatefulWidget {
  const RoutinesPage({super.key});

  @override
  ConsumerState<RoutinesPage> createState() => _RoutinesPageState();
}

class _RoutinesPageState extends ConsumerState<RoutinesPage> {
  String? _selectedDayId;

  @override
  Widget build(BuildContext context) {
    final daysAsync = ref.watch(routineControllerProvider);

    return daysAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) =>
          Center(child: Text('Error loading routines: $error')),
      data: (days) {
        if (days.isEmpty) {
          return const Center(child: Text('No routine days yet.'));
        }

        _selectedDayId ??= days.first.id;

        return LayoutBuilder(
          builder: (context, constraints) {
            final breakpoint = breakpointForWidth(constraints.maxWidth);

            return switch (breakpoint) {
              AppBreakpoint.phone => _buildPhoneList(context, days),
              AppBreakpoint.tablet ||
              AppBreakpoint.desktop => _buildWideLayout(context, days),
            };
          },
        );
      },
    );
  }

  Widget _buildPhoneList(BuildContext context, List<RoutineDay> days) {
    return ListView.separated(
      itemCount: days.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final day = days[index];

        return _RoutineDayCard(
          day: day,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => _RoutineDayDetailScreen(dayId: day.id),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildWideLayout(BuildContext context, List<RoutineDay> days) {
    final selectedDay = _dayById(days, _selectedDayId) ?? days.first;

    return Row(
      children: [
        Expanded(
          flex: 5,
          child: ListView.separated(
            itemCount: days.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final day = days[index];

              return _RoutineDayCard(
                day: day,
                selected: day.id == selectedDay.id,
                onTap: () {
                  setState(() {
                    _selectedDayId = day.id;
                  });
                },
              );
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 7,
          child: _RoutineDayDetail(dayId: selectedDay.id, embeddedInCard: true),
        ),
      ],
    );
  }

  RoutineDay? _dayById(List<RoutineDay> days, String? id) {
    if (id == null) {
      return null;
    }

    for (final day in days) {
      if (day.id == id) {
        return day;
      }
    }

    return null;
  }
}

class _RoutineDayCard extends StatelessWidget {
  const _RoutineDayCard({
    required this.day,
    required this.onTap,
    this.selected = false,
  });

  final RoutineDay day;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: selected
            ? BorderSide(color: colorScheme.primary, width: 1.5)
            : BorderSide.none,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(day.title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final focus in day.focusAreas)
                    Chip(
                      label: Text(focus),
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text('${day.exercises.length} exercises'),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoutineDayDetailScreen extends StatelessWidget {
  const _RoutineDayDetailScreen({required this.dayId});

  final String dayId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Routine Day')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _RoutineDayDetail(dayId: dayId),
        ),
      ),
    );
  }
}

class _RoutineDayDetail extends ConsumerWidget {
  const _RoutineDayDetail({required this.dayId, this.embeddedInCard = false});

  final String dayId;
  final bool embeddedInCard;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final day = ref.watch(routineDayByIdProvider(dayId));

    if (day == null) {
      return const Center(child: Text('Routine day not found.'));
    }

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                day.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            IconButton(
              onPressed: () => _showEditDayDialog(context, ref, day),
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Edit day details',
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final focus in day.focusAreas)
              Chip(label: Text(focus), visualDensity: VisualDensity.compact),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Text('Exercises', style: Theme.of(context).textTheme.titleMedium),
            const Spacer(),
            FilledButton.icon(
              onPressed: () => _showAddExerciseDialog(context, ref, day.id),
              icon: const Icon(Icons.add),
              label: const Text('Add exercise'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (day.exercises.isEmpty)
          const Expanded(
            child: Center(
              child: Text('No exercises yet. Add your first exercise.'),
            ),
          )
        else
          Expanded(
            child: ReorderableListView.builder(
              itemCount: day.exercises.length,
              onReorder: (oldIndex, newIndex) {
                ref
                    .read(routineControllerProvider.notifier)
                    .reorderExercise(
                      dayId: day.id,
                      oldIndex: oldIndex,
                      newIndex: newIndex,
                    );
              },
              itemBuilder: (context, index) {
                final exercise = day.exercises[index];

                return Card(
                  key: ValueKey(exercise.id),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    leading: ReorderableDragStartListener(
                      index: index,
                      child: const Icon(Icons.drag_indicator),
                    ),
                    title: Text(exercise.name),
                    subtitle: switch (exercise.note) {
                      final note? => Text(note),
                      null => const Text('No note'),
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => _showEditExerciseDialog(
                            context,
                            ref,
                            day.id,
                            exercise,
                          ),
                          icon: const Icon(Icons.edit_outlined),
                          tooltip: 'Edit exercise',
                        ),
                        IconButton(
                          onPressed: () => ref
                              .read(routineControllerProvider.notifier)
                              .removeExercise(
                                dayId: day.id,
                                exerciseId: exercise.id,
                              ),
                          icon: const Icon(Icons.delete_outline),
                          tooltip: 'Remove exercise',
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );

    if (embeddedInCard) {
      return Card(
        child: Padding(padding: const EdgeInsets.all(16), child: content),
      );
    }

    return content;
  }

  Future<void> _showEditDayDialog(
    BuildContext context,
    WidgetRef ref,
    RoutineDay day,
  ) async {
    final result = await _showDayEditor(
      context,
      title: day.title,
      focusAreas: day.focusAreas,
    );

    if (result == null) {
      return;
    }

    ref
        .read(routineControllerProvider.notifier)
        .updateDayMetadata(
          dayId: day.id,
          title: result.title,
          focusAreas: result.focusAreas,
        );
  }

  Future<void> _showAddExerciseDialog(
    BuildContext context,
    WidgetRef ref,
    String dayId,
  ) async {
    final result = await _showExerciseEditor(context);

    if (result == null) {
      return;
    }

    ref
        .read(routineControllerProvider.notifier)
        .addExercise(dayId: dayId, name: result.name, note: result.note);
  }

  Future<void> _showEditExerciseDialog(
    BuildContext context,
    WidgetRef ref,
    String dayId,
    ExerciseTemplate exercise,
  ) async {
    final result = await _showExerciseEditor(
      context,
      initialName: exercise.name,
      initialNote: exercise.note,
    );

    if (result == null) {
      return;
    }

    ref
        .read(routineControllerProvider.notifier)
        .updateExercise(
          dayId: dayId,
          exerciseId: exercise.id,
          name: result.name,
          note: result.note,
        );
  }
}

Future<({String title, List<String> focusAreas})?> _showDayEditor(
  BuildContext context, {
  required String title,
  required List<String> focusAreas,
}) {
  final titleController = TextEditingController(text: title);
  final focusController = TextEditingController(text: focusAreas.join(', '));

  return showDialog<({String title, List<String> focusAreas})>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Edit routine day'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Day title'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: focusController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Focus areas',
                helperText: 'Use comma separated values',
              ),
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
              final nextTitle = titleController.text.trim();
              final nextFocus = _parseCommaSeparated(focusController.text);

              if (nextTitle.isEmpty || nextFocus.isEmpty) {
                return;
              }

              Navigator.of(
                context,
              ).pop((title: nextTitle, focusAreas: nextFocus));
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}

Future<({String name, String? note})?> _showExerciseEditor(
  BuildContext context, {
  String initialName = '',
  String? initialNote,
}) {
  final nameController = TextEditingController(text: initialName);
  final noteController = TextEditingController(text: initialNote ?? '');

  return showDialog<({String name, String? note})>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(initialName.isEmpty ? 'Add exercise' : 'Edit exercise'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Exercise name'),
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
              final name = nameController.text.trim();

              if (name.isEmpty) {
                return;
              }

              final note = noteController.text.trim();
              Navigator.of(
                context,
              ).pop((name: name, note: note.isEmpty ? null : note));
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}

List<String> _parseCommaSeparated(String raw) {
  return [
    for (final value in raw.split(','))
      if (value.trim().isNotEmpty) value.trim(),
  ];
}
