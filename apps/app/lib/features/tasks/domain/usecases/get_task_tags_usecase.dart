import 'package:app/features/tasks/domain/repositories/task_repository.dart';

class GetTaskTagsUseCase {
  final TaskRepository _repository;

  GetTaskTagsUseCase(this._repository);

  Future<List<String>> call({String? projectId}) {
    return _repository.getTags(projectId: projectId);
  }
}