import 'package:app/features/projects/domain/repository/project_repository.dart';

class GetProjectTagsUseCase {
  final ProjectRepository _repository;

  GetProjectTagsUseCase(this._repository);

  Future<List<String>> call() {
    return _repository.getTags();
  }
}