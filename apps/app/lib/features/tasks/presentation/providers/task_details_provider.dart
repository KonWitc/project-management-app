import 'package:app/features/tasks/data/providers/task_repository_provider.dart';
import 'package:app/features/tasks/presentation/mappers/task_details_mapper.dart';
import 'package:app/features/tasks/presentation/models/details/task_details_ui_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final taskDetailsProvider = FutureProvider.family<TaskDetailsUiModel, String>((
  ref,
  taskId,
) async {
  final repository = ref.watch(taskRepositoryProvider);
  final task = await repository.getTaskById(taskId);

  return TaskDetailsMapper.mapDomainToPresentation(task);
});
