import 'package:app/core/models/paginated_result.dart';
import 'package:app/features/projects/domain/models/milestone.dart';
import 'package:app/features/projects/domain/repository/milestone_repository.dart';

class GetMilestonesUseCase {
  final MilestoneRepository _repository;

  GetMilestonesUseCase(this._repository);

  Future<PaginatedResult<Milestone>> call({
    required String projectId,
    String? status,
    String? search,
    int? page,
    int? limit,
    String? sortBy,
    String? sortDir,
  }) {
    return _repository.getMilestones(
      projectId: projectId,
      status: status,
      search: search,
      page: page,
      limit: limit,
      sortBy: sortBy,
      sortDir: sortDir,
    );
  }
}