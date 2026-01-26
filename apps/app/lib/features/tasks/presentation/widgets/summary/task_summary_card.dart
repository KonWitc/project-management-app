import 'package:app/core/theme/app_theme.dart';
import 'package:app/features/tasks/presentation/models/task_card_model.dart';
import 'package:app/features/tasks/presentation/widgets/create_task_dialog.dart';
import 'package:flutter/material.dart';

class TasksSummaryCard extends StatelessWidget {
  final String projectId;
  final List<TaskCardModel> tasks;
  final VoidCallback? onViewAll;
  final VoidCallback? onRefresh;
  final bool isLoading;

  const TasksSummaryCard({
    super.key,
    required this.projectId,
    required this.tasks,
    this.onViewAll,
    this.onRefresh,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    // Calculate statistics
    final totalTasks = tasks.length;
    final completedTasks = tasks.where((t) => t.isCompleted).length;
    final inProgressTasks = tasks.where((t) => t.isInProgress).length;
    final overdueTasks = tasks.where((t) => t.isOverdue).length;

    return Card(
      child: InkWell(
        onTap: onViewAll,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Icon(Icons.task_outlined, size: 24, color: cs.ceruleanBlue),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Tasks',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: cs.onSurfaceVariant,
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Content
                if (isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (totalTasks == 0)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.task_outlined,
                            size: 48,
                            color: cs.onSurfaceVariant.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No tasks yet',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 16),
                          FilledButton.tonalIcon(
                            onPressed: () => _showCreateTaskDialog(context),
                            icon: const Icon(Icons.add),
                            label: const Text('Create Task'),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Progress Bar
                      LinearProgressIndicator(
                        value: totalTasks > 0 ? completedTasks / totalTasks : 0,
                        backgroundColor: cs.surfaceContainerHighest,
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$completedTasks of $totalTasks completed',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Statistics Grid - Responsive
                      LayoutBuilder(
                        builder: (context, constraints) {
                          // Use single column on very small screens
                          if (constraints.maxWidth < 300) {
                            return Column(
                              children: [
                                _StatItem(
                                  label: 'Total',
                                  value: totalTasks.toString(),
                                  icon: Icons.checklist,
                                  color: cs.ceruleanBlue,
                                ),
                                const SizedBox(height: 12),
                                _StatItem(
                                  label: 'In Progress',
                                  value: inProgressTasks.toString(),
                                  icon: Icons.pending_actions,
                                  color: Colors.blue,
                                ),
                                const SizedBox(height: 12),
                                _StatItem(
                                  label: 'Completed',
                                  value: completedTasks.toString(),
                                  icon: Icons.check_circle,
                                  color: Colors.green,
                                ),
                                const SizedBox(height: 12),
                                _StatItem(
                                  label: 'Overdue',
                                  value: overdueTasks.toString(),
                                  icon: Icons.warning,
                                  color: cs.racingRed,
                                ),
                              ],
                            );
                          }

                          // Use 2x2 grid for normal screens
                          return Column(
                            children: [
                              IntrinsicHeight(
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      child: _StatItem(
                                        label: 'Total',
                                        value: totalTasks.toString(),
                                        icon: Icons.checklist,
                                        color: cs.ceruleanBlue,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _StatItem(
                                        label: 'In Progress',
                                        value: inProgressTasks.toString(),
                                        icon: Icons.pending_actions,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              IntrinsicHeight(
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      child: _StatItem(
                                        label: 'Completed',
                                        value: completedTasks.toString(),
                                        icon: Icons.check_circle,
                                        color: Colors.green,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _StatItem(
                                        label: 'Overdue',
                                        value: overdueTasks.toString(),
                                        icon: Icons.warning,
                                        color: cs.racingRed,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCreateTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) =>
          CreateTaskDialog(projectId: projectId, onTaskCreated: onRefresh),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Important: Natural height
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
              maxLines: 2, // Prevent text overflow
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
