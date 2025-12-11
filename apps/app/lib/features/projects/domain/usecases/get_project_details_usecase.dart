import 'package:app/features/projects/domain/models/project.dart';
import 'package:app/features/projects/domain/repository/project_repository.dart';

class GetProjectDetailsUseCase {
  final ProjectRepository _repository;

  GetProjectDetailsUseCase(this._repository);

  Future<Project> call(String id) {
    return _repository.getProjectById(id);
  }
}