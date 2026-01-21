import 'package:app/features/tasks/data/providers/task_repository_provider.dart';
import 'package:app/features/tasks/domain/usecases/get_tasks_usecase.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final getTasksUseCaseProvider = Provider<GetTasksUseCase>((ref) {
  final repo = ref.read(taskRepositoryProvider);
  return GetTasksUseCase(repo);
});