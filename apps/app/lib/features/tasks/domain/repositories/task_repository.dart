import 'package:app/core/models/paginated_result.dart';
import 'package:app/features/tasks/domain/models/task.dart';
import 'package:app/features/tasks/domain/models/task_filters.dart';

abstract class TaskRepository {
  Future<PaginatedResult<Task>> getTasks({TaskFilters? filters});
  Future<Task> getTaskById(String id);
  Future<Task> createTask(Task task);
  Future<Task> updateTask(String id, Task task);
  Future<void> deleteTask(String id);
  Future<List<String>> getTags({String? projectId});
  Future<List<String>> getTaskTypes({String? projectId});
}
