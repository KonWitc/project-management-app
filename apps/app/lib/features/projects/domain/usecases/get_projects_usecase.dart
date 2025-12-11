import 'package:app/core/models/paginated_result.dart';
import 'package:app/features/projects/domain/models/project.dart';
import 'package:app/features/projects/domain/models/project_filters.dart';
import 'package:app/features/projects/domain/repository/project_repository.dart';

class GetProjectsUseCase {
  final ProjectRepository _repository;

  GetProjectsUseCase(this._repository);

  Future<PaginatedResult<Project>> call({
    ProjectFilters? filters,
  }) {
    return _repository.getProjects(filters: filters);
  }
}