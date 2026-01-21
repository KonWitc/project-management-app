import 'package:app/core/models/paginated_result.dart';
import 'package:app/features/projects/domain/models/milestone.dart';

abstract class MilestoneRepository {
  Future<PaginatedResult<Milestone>> getMilestones({
    required String projectId,
    String? status,
    String? search,
    int? page,
    int? limit,
    String? sortBy,
    String? sortDir,
  });

  Future<Milestone> getMilestoneById({
    required String projectId,
    required String milestoneId,
  });

  Future<Milestone> createMilestone({
    required String projectId,
    required String name,
    String? description,
    String? status,
    DateTime? dueDate,
    List<String>? tags,
    String? ownerId,
  });

  Future<Milestone> updateMilestone({
    required String projectId,
    required String milestoneId,
    String? name,
    String? description,
    String? status,
    DateTime? dueDate,
    List<String>? tags,
    String? ownerId,
    int? progress,
  });

  Future<void> deleteMilestone({
    required String projectId,
    required String milestoneId,
  });

  Future<int> calculateProgress({
    required String milestoneId,
  });
}