import 'package:app/features/projects/domain/models/milestone.dart';
import 'package:app/features/projects/domain/models/project_enums.dart';
import 'package:app/features/tasks/presentation/providers/milestone_tasks_provider.dart';
import 'package:app/features/tasks/presentation/widgets/create_task_dialog.dart';
import 'package:app/features/tasks/presentation/widgets/task_card.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MilestoneSection extends ConsumerWidget {
  final String projectId;
  final Milestone milestone;
  final VoidCallback? onTaskCreated;

  const MilestoneSection({
    super.key,
    required this.projectId,
    required this.milestone,
    this.onTaskCreated,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(milestoneTasksProvider(milestone.id));

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        title: Row(
          children: [
            Expanded(
              child: Text(
                milestone.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            _buildStatusBadge(context),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (milestone.description != null) ...[
              const SizedBox(height: 4),
              Text(
                milestone.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: milestone.progress / 100,
              backgroundColor: Colors.grey.shade200,
            ),
            const SizedBox(height: 4),
            Text(
              '${milestone.progress}% complete',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tasks',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Add Task'),
                      onPressed: () => _showCreateTaskDialog(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                tasksAsync.when(
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  error: (error, stack) => Text('Error: $error'),
                  data: (result) {
                    if (result.items.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'No tasks in this milestone yet',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      );
                    }
                    return Column(
                      children: result.items
                          .map((task) => Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: TaskCard(task: task),
                              ))
                          .toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    Color color;
    switch (milestone.status) {
      case MilestoneStatus.notStarted:
        color = Colors.grey;
        break;
      case MilestoneStatus.inProgress:
        color = Colors.blue;
        break;
      case MilestoneStatus.completed:
        color = Colors.green;
        break;
      case MilestoneStatus.cancelled:
        color = Colors.red;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        milestone.status.name.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showCreateTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CreateTaskDialog(
        projectId: projectId,
        milestoneId: milestone.id,
        onTaskCreated: onTaskCreated,
      ),
    );
  }
}