import 'package:app/features/projects/domain/repository/milestone_repository.dart';

class DeleteMilestoneUseCase {
  final MilestoneRepository _repository;

  DeleteMilestoneUseCase(this._repository);

  Future<void> call({
    required String projectId,
    required String milestoneId,
  }) {
    return _repository.deleteMilestone(
      projectId: projectId,
      milestoneId: milestoneId,
    );
  }
}