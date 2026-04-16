import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/progress_metrics.dart';

/// A line chart that plots a series of [ProgressPoint]s over time.
///
/// Axis layout, label padding, and grid styling are tuned for readability:
/// - Left axis shows numeric values with right-side padding.
/// - Bottom axis shows short date labels with top-side padding.
/// - Horizontal grid lines only; no vertical clutter.
/// - Right and top axes are hidden.
class ProgressChart extends StatelessWidget {
  const ProgressChart({
    super.key,
    required this.points,
    this.yLabel = 'kg',
  });

  final List<ProgressPoint> points;

  /// Unit label appended to each left-axis tick (e.g. "kg" or "vol").
  final String yLabel;

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return const SizedBox(
        height: 160,
        child: Center(
          child: Text('No data yet.', style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    final primary = Theme.of(context).colorScheme.primary;
    final maxY = points.map((p) => p.value).reduce((a, b) => a > b ? a : b);
    final yInterval = _yInterval(maxY);
    final axisLabelStyle = Theme.of(context)
        .textTheme
        .bodySmall!
        .copyWith(color: Colors.grey.shade600, fontSize: 10);

    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: (points.length - 1).toDouble(),
          minY: 0,
          maxY: maxY + yInterval,
          // ── Line series ────────────────────────────────────────────────
          lineBarsData: [
            LineChartBarData(
              spots: [
                for (var i = 0; i < points.length; i++)
                  FlSpot(i.toDouble(), points[i].value),
              ],
              isCurved: points.length > 2,
              color: primary,
              barWidth: 2.5,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, pct, bar, idx) => FlDotCirclePainter(
                  radius: 3.5,
                  color: primary,
                  strokeWidth: 0,
                  strokeColor: Colors.transparent,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                color: primary.withValues(alpha: 0.08),
              ),
            ),
          ],
          // ── Axis titles ─────────────────────────────────────────────────
          titlesData: FlTitlesData(
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            // Left axis: numeric value + unit label with right padding.
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 56,
                interval: yInterval,
                getTitlesWidget: (value, meta) {
                  if (value == 0) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(
                      '${value.toInt()} $yLabel',
                      style: axisLabelStyle,
                      textAlign: TextAlign.right,
                    ),
                  );
                },
              ),
            ),
            // Bottom axis: short date label with top padding.
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 36,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final index = value.round();
                  if (index < 0 || index >= points.length) {
                    return const SizedBox.shrink();
                  }
                  // Only render every Nth label to avoid crowding.
                  final step = _labelStep(points.length);
                  if (index % step != 0 && index != points.length - 1) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      DateFormat('M/d').format(points[index].date),
                      style: axisLabelStyle,
                    ),
                  );
                },
              ),
            ),
          ),
          // ── Grid styling ────────────────────────────────────────────────
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            drawVerticalLine: false,
            horizontalInterval: yInterval,
            getDrawingHorizontalLine: (_) => const FlLine(
              color: Color(0xFFE0E0E0),
              strokeWidth: 0.8,
            ),
          ),
          // ── Border ──────────────────────────────────────────────────────
          borderData: FlBorderData(
            show: true,
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade300, width: 1),
              left: BorderSide(color: Colors.grey.shade300, width: 1),
              right: BorderSide.none,
              top: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }

  /// Chooses a human-friendly y-axis tick interval based on [maxY].
  static double _yInterval(double maxY) {
    if (maxY <= 0) return 10;
    if (maxY <= 20) return 5;
    if (maxY <= 50) return 10;
    if (maxY <= 100) return 20;
    if (maxY <= 200) return 50;
    if (maxY <= 500) return 100;
    return 200;
  }

  /// Returns a step so that at most ~5 bottom labels are visible.
  static int _labelStep(int count) {
    if (count <= 5) return 1;
    if (count <= 10) return 2;
    if (count <= 20) return 4;
    return (count / 5).ceil();
  }
}
