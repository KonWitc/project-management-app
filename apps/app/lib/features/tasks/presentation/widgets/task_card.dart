import 'package:app/features/tasks/domain/models/task.dart';
import 'package:app/features/tasks/domain/models/task_enums.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;

  const TaskCard({super.key, required this.task, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and Status Row
              Row(
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        decoration: task.isDone
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildStatusChip(context),
                ],
              ),
              if (task.description != null && task.description!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  task.description!,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 12),
              // Priority, Due Date, and Tags Row
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildPriorityChip(context),
                  if (task.dueDate != null) _buildDueDateChip(context),
                  ...task.tags
                      .take(3)
                      .map((tag) => _buildTagChip(context, tag)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    Color color;
    switch (task.status) {
      case TaskStatus.notStarted:
        color = Colors.grey;
        break;
      case TaskStatus.inProgress:
        color = Colors.blue;
        break;
      case TaskStatus.blocked:
        color = Colors.red;
        break;
      case TaskStatus.cancelled:
        color = Colors.orange;
        break;
      case TaskStatus.done:
        color = Colors.green;
        break;
    }

    return Chip(
      label: Text(task.status.label, style: const TextStyle(fontSize: 12)),
      backgroundColor: color.withValues(alpha: 0.2),
      labelStyle: TextStyle(color: color),
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }

  Widget _buildPriorityChip(BuildContext context) {
    Color color;
    String label;
    switch (task.priority) {
      case TaskPriority.low:
        color = Colors.green;
        label = 'Low';
        break;
      case TaskPriority.medium:
        color = Colors.yellow.shade700;
        label = 'Medium';
        break;
      case TaskPriority.high:
        color = Colors.orange;
        label = 'High';
        break;
      case TaskPriority.critical:
        color = Colors.red;
        label = 'Critical';
        break;
    }

    return Chip(
      avatar: Icon(Icons.flag, size: 16, color: color),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }

  Widget _buildDueDateChip(BuildContext context) {
    final dueDate = task.dueDate!;
    final formattedDate = DateFormat('MMM d, y').format(dueDate);
    final isOverdue = task.isOverdue;

    return Chip(
      avatar: Icon(
        Icons.calendar_today,
        size: 16,
        color: isOverdue ? Colors.red : Colors.blue,
      ),
      label: Text(
        formattedDate,
        style: TextStyle(
          fontSize: 12,
          color: isOverdue ? Colors.red : null,
          fontWeight: isOverdue ? FontWeight.bold : null,
        ),
      ),
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }

  Widget _buildTagChip(BuildContext context, String tag) {
    return Chip(
      label: Text(tag, style: const TextStyle(fontSize: 11)),
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.symmetric(horizontal: 6),
    );
  }
}
