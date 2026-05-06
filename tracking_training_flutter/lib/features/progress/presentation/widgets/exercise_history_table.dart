import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/progress_metrics.dart';

class ExerciseHistoryTable extends StatelessWidget {
  const ExerciseHistoryTable({
    super.key,
    required this.rows,
  });

  final List<ExerciseHistoryRow> rows;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    if (rows.isEmpty) {
      return Text(
        'No sessions logged yet.',
        style: textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      );
    }

    final displayRows = rows.take(10).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: DefaultTextStyle(
            style: textTheme.bodySmall!.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurfaceVariant,
            ),
            child: const Row(
              children: [
                SizedBox(width: 80, child: Text('Date')),
                SizedBox(width: 8),
                Expanded(flex: 3, child: Text('Sets')),
                SizedBox(width: 8),
                Expanded(flex: 4, child: Text('Notes')),
              ],
            ),
          ),
        ),
        const Divider(height: 1, thickness: 1),
        const SizedBox(height: 8),
        // Data Rows
        ...displayRows.map((row) {
          final dateFormatted = DateFormat('MMM d, yyyy').format(row.date);
          final notes = row.notes?.trim() ?? '';
          final displayNotes = notes.isEmpty ? '—' : notes;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 80,
                  child: Text(
                    dateFormatted,
                    style: textTheme.bodySmall,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 3,
                  child: Text(
                    row.setsSummary,
                    style: textTheme.bodySmall,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 4,
                  child: Text(
                    displayNotes,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        }),
        if (rows.length > 10) ...[
          const SizedBox(height: 12),
          Text(
            'Showing 10 of ${rows.length} sessions',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
