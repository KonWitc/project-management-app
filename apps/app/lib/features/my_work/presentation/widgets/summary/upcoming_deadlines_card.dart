import 'package:app/features/my_work/presentation/providers/my_tasks_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UpcomingDeadlinesCard extends ConsumerWidget {
  const UpcomingDeadlinesCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncTasks = ref.watch(myTasksProvider);
    final theme = Theme.of(context);

    return asyncTasks.when(
      loading: () => const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (_, __) => const SizedBox.shrink(),
      data: (result) {
        // Filter tasks with due dates that are not done
        final upcomingTasks = result.items
            .where((t) => !t.isDone && t.dueDateLabel != null)
            .take(5)
            .toList();

        if (upcomingTasks.isEmpty) {
          return const SizedBox.shrink();
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Upcoming Deadlines',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                ...upcomingTasks.map((task) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Icon(
                            task.isOverdue
                                ? Icons.error_outline
                                : Icons.schedule,
                            size: 16,
                            color: task.isOverdue ? Colors.red : Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              task.title,
                              style: theme.textTheme.bodyMedium,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            task.dueDateLabel!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: task.isOverdue ? Colors.red : null,
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        );
      },
    );
  }
}
