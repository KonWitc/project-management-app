import 'package:app/features/my_work/presentation/providers/my_time_summary_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TimeTrackingSummaryCard extends ConsumerWidget {
  const TimeTrackingSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(myTimeSummaryProvider);
    final theme = Theme.of(context);

    if (summary.totalEstimatedHours == 0) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Time Tracking',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _TimeCard(
                    label: 'Estimated',
                    hours: summary.totalEstimatedHours,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _TimeCard(
                    label: 'Logged',
                    hours: summary.totalLoggedHours,
                    color: summary.isOvertime ? Colors.red : Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: summary.progressPercentage / 100,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                summary.isOvertime ? Colors.red : Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              summary.isOvertime
                  ? 'Over by ${summary.remainingHours.abs().toStringAsFixed(1)}h'
                  : '${summary.remainingHours.toStringAsFixed(1)}h remaining',
              style: theme.textTheme.bodySmall?.copyWith(
                color: summary.isOvertime ? Colors.red : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeCard extends StatelessWidget {
  final String label;
  final double hours;
  final Color color;

  const _TimeCard({
    required this.label,
    required this.hours,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 4),
          Text(
            '${hours.toStringAsFixed(1)}h',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
