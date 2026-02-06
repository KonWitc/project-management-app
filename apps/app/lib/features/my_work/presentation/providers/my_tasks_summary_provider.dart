import 'package:app/features/my_work/presentation/models/task_status_summary.dart';
import 'package:app/features/my_work/presentation/providers/my_tasks_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final myTasksSummaryProvider = Provider<TaskStatusSummary>((ref) {
  final asyncTasks = ref.watch(myTasksProvider);

  return asyncTasks.when(
    data: (result) {
      final tasks = result.items;

      return TaskStatusSummary(
        total: tasks.length,
        notStarted:
            tasks.where((t) => t.statusLabel == 'Not Started').length,
        inProgress:
            tasks.where((t) => t.statusLabel == 'In Progress').length,
        blocked: tasks.where((t) => t.statusLabel == 'Blocked').length,
        done: tasks.where((t) => t.statusLabel == 'Done').length,
        overdue: tasks.where((t) => t.isOverdue).length,
      );
    },
    loading: () => TaskStatusSummary.empty(),
    error: (_, __) => TaskStatusSummary.empty(),
  );
});
