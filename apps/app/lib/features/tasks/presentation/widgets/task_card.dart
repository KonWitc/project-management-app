import 'package:app/features/tasks/presentation/models/task_card_model.dart';
import 'package:flutter/material.dart';
class TaskCard extends StatelessWidget {
  final TaskCardModel task;
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
                        decoration: task.isCompleted
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
                  if (task.dueDateLabel != null) _buildDueDateChip(context),
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

    return Chip(
      label: Text(task.statusLabel, style: const TextStyle(fontSize: 12)),
      backgroundColor: task.statusColor.withValues(alpha: 0.2),
      labelStyle: TextStyle(color: task.statusColor),
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }

  Widget _buildPriorityChip(BuildContext context) {

    return Chip(
      avatar: Icon(task.priorityIcon, size: 16, color: task.priorityColor),
      label: Text(task.priorityLabel, style: const TextStyle(fontSize: 12)),
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }

  Widget _buildDueDateChip(BuildContext context) {
    return Chip(
      avatar: Icon(
        Icons.calendar_today,
        size: 16,
        color: task.isOverdue ? Colors.red : Colors.blue,
      ),
      label: Text(
        task.dueDateLabel!,
        style: TextStyle(
          fontSize: 12,
          color: task.isOverdue ? Colors.red : null,
          fontWeight: task.isOverdue ? FontWeight.bold : null,
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
