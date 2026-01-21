import 'package:app/core/models/paginated_result.dart';
import 'package:app/features/tasks/domain/models/task.dart';
import 'package:app/features/tasks/domain/models/task_filters.dart';
import 'package:app/features/tasks/domain/providers/get_tasks_usecase_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Provider to fetch tasks for a specific project
final projectTasksProvider =
    FutureProvider.family<PaginatedResult<Task>, String>((ref, projectId) async {
  final useCase = ref.watch(getTasksUseCaseProvider);
  final filters = TaskFilters(
    projectId: projectId,
    limit: 100, // Get more tasks for project view
  );
  return await useCase(filters: filters);
});