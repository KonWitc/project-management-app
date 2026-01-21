import 'package:app/features/projects/domain/models/milestone.dart';
import 'package:app/features/projects/domain/repository/milestone_repository.dart';

class UpdateMilestoneUseCase {
  final MilestoneRepository _repository;

  UpdateMilestoneUseCase(this._repository);

  Future<Milestone> call({
    required String projectId,
    required String milestoneId,
    String? name,
    String? description,
    String? status,
    DateTime? dueDate,
    List<String>? tags,
    String? ownerId,
    int? progress,
  }) {
    return _repository.updateMilestone(
      projectId: projectId,
      milestoneId: milestoneId,
      name: name,
      description: description,
      status: status,
      dueDate: dueDate,
      tags: tags,
      ownerId: ownerId,
      progress: progress,
    );
  }
}
