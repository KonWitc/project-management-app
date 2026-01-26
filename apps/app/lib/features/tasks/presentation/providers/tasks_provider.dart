import 'package:app/core/models/paginated_result.dart';
import 'package:app/features/tasks/domain/providers/get_tasks_usecase_provider.dart';
import 'package:app/features/tasks/presentation/mappers/task_card_mapper.dart';
import 'package:app/features/tasks/presentation/models/task_card_model.dart';
import 'package:app/features/tasks/presentation/providers/tasks_filters_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final tasksListProvider = FutureProvider<PaginatedResult<TaskCardModel>>((
  ref,
) async {
  final useCase = ref.watch(getTasksUseCaseProvider);
  final filters = ref.watch(taskFiltersProvider);
  final result = await useCase(filters: filters);
  return result.map(TaskCardMapper.mapDomainToPresentation);
});
