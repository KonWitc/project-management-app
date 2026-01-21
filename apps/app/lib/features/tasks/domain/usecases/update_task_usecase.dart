import 'package:app/features/tasks/domain/models/task.dart';
import 'package:app/features/tasks/domain/repositories/task_repository.dart';

class UpdateTaskUseCase {
  final TaskRepository _repository;

  UpdateTaskUseCase(this._repository);

  Future<Task> call(String id, Task task) {
    return _repository.updateTask(id, task);
  }
}