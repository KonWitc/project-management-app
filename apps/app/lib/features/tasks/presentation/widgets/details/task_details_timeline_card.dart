import 'package:app/features/tasks/presentation/models/details/task_details_timeline_model.dart';
import 'package:flutter/material.dart';

class TaskDetailsTimelineCard extends StatelessWidget {
  final TaskDetailsTimelineModel model;

  const TaskDetailsTimelineCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Timeline',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _DateRow(
              icon: Icons.play_arrow,
              label: 'Start',
              value: model.startDateLabel ?? 'Not set',
              isSet: model.startDateLabel != null,
            ),
            const SizedBox(height: 12),
            _DateRow(
              icon: Icons.flag,
              label: 'Due',
              value: model.dueDateLabel ?? 'Not set',
              isSet: model.dueDateLabel != null,
              isOverdue: model.isOverdue,
            ),
            if (model.completedAtLabel != null) ...[
              const SizedBox(height: 12),
              _DateRow(
                icon: Icons.check_circle,
                label: 'Completed',
                value: model.completedAtLabel!,
                isSet: true,
                isCompleted: true,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DateRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isSet;
  final bool isOverdue;
  final bool isCompleted;

  const _DateRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.isSet,
    this.isOverdue = false,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color valueColor;
    if (isCompleted) {
      valueColor = Colors.green;
    } else if (isOverdue) {
      valueColor = Colors.red;
    } else if (!isSet) {
      valueColor = colorScheme.onSurface.withValues(alpha: 0.5);
    } else {
      valueColor = colorScheme.onSurface;
    }

    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 18,
            color: isOverdue ? Colors.red : colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: valueColor,
                  fontWeight: isOverdue ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
        if (isOverdue)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Overdue',
              style: TextStyle(
                color: Colors.red,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}
