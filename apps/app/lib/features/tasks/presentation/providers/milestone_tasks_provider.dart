import 'package:app/core/models/paginated_result.dart';
import 'package:app/features/tasks/domain/models/task_filters.dart';
import 'package:app/features/tasks/domain/providers/get_tasks_usecase_provider.dart';
import 'package:app/features/tasks/presentation/mappers/task_card_mapper.dart';
import 'package:app/features/tasks/presentation/models/task_card_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Provider to fetch tasks for a specific milestone
final milestoneTasksProvider = FutureProvider.family<PaginatedResult<TaskCardModel>, String>(
  (ref, milestoneId) async {
    final useCase = ref.watch(getTasksUseCaseProvider);
    final filters = TaskFilters(
      milestoneId: milestoneId,
      limit: 100,
    );
    final result = await useCase(filters: filters);
    return result.map(TaskCardMapper.mapDomainToPresentation);
  },
);