import 'package:app/features/my_work/presentation/providers/my_tasks_summary_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TaskStatusSummaryCard extends ConsumerWidget {
  const TaskStatusSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(myTasksSummaryProvider);
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Task Summary',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            _StatusRow(
              label: 'Total',
              count: summary.total,
              color: Colors.grey,
            ),
            const SizedBox(height: 8),
            _StatusRow(
              label: 'Not Started',
              count: summary.notStarted,
              color: Colors.grey[600]!,
            ),
            const SizedBox(height: 8),
            _StatusRow(
              label: 'In Progress',
              count: summary.inProgress,
              color: Colors.blue,
            ),
            const SizedBox(height: 8),
            _StatusRow(
              label: 'Blocked',
              count: summary.blocked,
              color: Colors.orange,
            ),
            const SizedBox(height: 8),
            _StatusRow(
              label: 'Done',
              count: summary.done,
              color: Colors.green,
            ),
            if (summary.overdue > 0) ...[
              const SizedBox(height: 8),
              _StatusRow(
                label: 'Overdue',
                count: summary.overdue,
                color: Colors.red,
                isHighlight: true,
              ),
            ],
            if (summary.total > 0) ...[
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: summary.completionPercentage / 100,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
              ),
              const SizedBox(height: 8),
              Text(
                '${summary.completionPercentage.toStringAsFixed(0)}% Complete',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final bool isHighlight;

  const _StatusRow({
    required this.label,
    required this.count,
    required this.color,
    this.isHighlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: isHighlight ? FontWeight.w600 : null,
            ),
          ),
        ),
        Text(
          count.toString(),
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: isHighlight ? color : null,
          ),
        ),
      ],
    );
  }
}
