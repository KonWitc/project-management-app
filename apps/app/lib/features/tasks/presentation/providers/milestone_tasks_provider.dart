import 'package:app/core/models/paginated_result.dart';
import 'package:app/features/tasks/domain/models/task.dart';
import 'package:app/features/tasks/domain/models/task_filters.dart';
import 'package:app/features/tasks/domain/providers/get_tasks_usecase_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Provider to fetch tasks for a specific milestone
final milestoneTasksProvider = FutureProvider.family<PaginatedResult<Task>, String>(
  (ref, milestoneId) async {
    final useCase = ref.watch(getTasksUseCaseProvider);
    final filters = TaskFilters(
      milestoneId: milestoneId,
      limit: 100,
    );
    return await useCase(filters: filters);
  },
);