import 'package:app/core/models/paginated_result.dart';
import 'package:app/features/tasks/domain/models/task.dart';
import 'package:app/features/tasks/domain/models/task_filters.dart';
import 'package:app/features/tasks/domain/repositories/task_repository.dart';

class GetTasksUseCase {
  final TaskRepository _repository;

  GetTasksUseCase(this._repository);

  Future<PaginatedResult<Task>> call({
    TaskFilters? filters,
  }) {
    return _repository.getTasks(filters: filters);
  }
}