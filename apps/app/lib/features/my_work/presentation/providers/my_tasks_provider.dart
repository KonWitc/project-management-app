import 'package:app/core/models/paginated_result.dart';
import 'package:app/features/auth/auth_providers.dart';
import 'package:app/features/tasks/domain/models/task_filters.dart';
import 'package:app/features/tasks/domain/providers/get_tasks_usecase_provider.dart';
import 'package:app/features/tasks/presentation/mappers/task_card_mapper.dart';
import 'package:app/features/tasks/presentation/models/task_card_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final myTasksProvider = FutureProvider<PaginatedResult<TaskCardModel>>((
  ref,
) async {
  final authState = ref.watch(authProvider).value;
  final userId = authState?.user?['userId'] as String?;

  if (userId == null) {
    return const PaginatedResult(
      items: [],
      total: 0,
      page: 1,
      limit: 20,
      totalPages: 0,
    );
  }

  final useCase = ref.watch(getTasksUseCaseProvider);
  final filters = TaskFilters(assigneeId: userId, limit: 100);
  final result = await useCase(filters: filters);
  return result.map(TaskCardMapper.mapDomainToPresentation);
});
