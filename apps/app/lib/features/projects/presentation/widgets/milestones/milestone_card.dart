import 'package:app/features/projects/domain/models/milestone.dart';
import 'package:app/features/projects/domain/models/project_enums.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MilestoneCard extends StatelessWidget {
  final Milestone milestone;
  final VoidCallback? onTap;

  const MilestoneCard({
    super.key,
    required this.milestone,
    this.onTap,
  });

  Color _getStatusColor(BuildContext context, MilestoneStatus status) {
    final cs = Theme.of(context).colorScheme;
    return switch (status) {
      MilestoneStatus.notStarted => cs.outline,
      MilestoneStatus.inProgress => Colors.blue,
      MilestoneStatus.completed => Colors.green,
      MilestoneStatus.cancelled => cs.error,
    };
  }

  String _getStatusLabel(MilestoneStatus status) {
    return switch (status) {
      MilestoneStatus.notStarted => 'Not Started',
      MilestoneStatus.inProgress => 'In Progress',
      MilestoneStatus.completed => 'Completed',
      MilestoneStatus.cancelled => 'Cancelled',
    };
  }

  String? _formatDate(DateTime? date) {
    if (date == null) return null;
    return DateFormat('MMM d, y').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final statusColor = _getStatusColor(context, milestone.status);
    final dueDateLabel = _formatDate(milestone.dueDate);

    return Card(
      elevation: 1,
      surfaceTintColor: cs.surfaceTint,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: title + status chip
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      milestone.name,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _StatusChip(
                    label: _getStatusLabel(milestone.status),
                    color: statusColor,
                  ),
                ],
              ),

              // Description
              if (milestone.description != null &&
                  milestone.description!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  milestone.description!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              const SizedBox(height: 12),

              // Progress bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progress',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        '${milestone.progress}%',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: cs.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: milestone.progress / 100,
                      minHeight: 8,
                      backgroundColor: cs.surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        milestone.isDone ? Colors.green : Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),

              // Due date
              if (dueDateLabel != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: milestone.isOverdue ? cs.error : cs.onSurfaceVariant,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Due: $dueDateLabel',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: milestone.isOverdue ? cs.error : cs.onSurfaceVariant,
                        fontWeight: milestone.isOverdue
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                    if (milestone.isOverdue) ...[
                      const SizedBox(width: 6),
                      Text(
                        '(Overdue)',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}