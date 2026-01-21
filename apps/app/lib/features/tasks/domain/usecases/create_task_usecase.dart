import 'package:app/features/tasks/domain/models/task.dart';
import 'package:app/features/tasks/domain/repositories/task_repository.dart';

class CreateTaskUseCase {
  final TaskRepository _repository;

  CreateTaskUseCase(this._repository);

  Future<Task> call(Task task) {
    return _repository.createTask(task);
  }
}