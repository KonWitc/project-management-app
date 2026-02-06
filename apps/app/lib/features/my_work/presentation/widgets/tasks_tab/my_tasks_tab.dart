import 'package:app/features/my_work/presentation/providers/tasks_grouped_by_project_provider.dart';
import 'package:app/features/my_work/presentation/widgets/summary/task_status_summary_card.dart';
import 'package:app/features/my_work/presentation/widgets/summary/time_tracking_summary_card.dart';
import 'package:app/features/my_work/presentation/widgets/summary/upcoming_deadlines_card.dart';
import 'package:app/features/my_work/presentation/widgets/tasks_tab/tasks_grouped_by_project.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MyTasksTab extends ConsumerWidget {
  const MyTasksTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final asyncGroups = ref.watch(tasksGroupedByProjectProvider(colorScheme));

    return asyncGroups.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error loading tasks: $error'),
          ],
        ),
      ),
      data: (groups) {
        if (groups.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.task_alt,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No tasks assigned to you',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
          );
        }

        return CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    TaskStatusSummaryCard(),
                    SizedBox(height: 16),
                    UpcomingDeadlinesCard(),
                    SizedBox(height: 16),
                    TimeTrackingSummaryCard(),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  'Tasks by Project',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return TasksGroupedByProject(
                      groups: groups,
                      onTaskTap: (taskId, projectId) => context.push('/tasks/$taskId'),
                    );
                  },
                  childCount: 1,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
