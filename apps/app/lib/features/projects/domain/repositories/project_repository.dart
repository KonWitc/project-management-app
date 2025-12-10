import 'package:app/core/models/paginated_result.dart';
import 'package:app/features/projects/domain/models/project_filters.dart';
import 'package:app/features/projects/domain/models/project.dart';

abstract class ProjectRepository {
  Future<PaginatedResult<Project>> getProjects({ProjectFilters? filters});
  Future<Project> getOneProject();

  Future<List<String>> getTags();
}
