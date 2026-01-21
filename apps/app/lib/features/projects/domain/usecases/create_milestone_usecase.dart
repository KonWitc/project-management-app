import 'package:app/features/projects/domain/models/milestone.dart';
import 'package:app/features/projects/domain/repository/milestone_repository.dart';

class CreateMilestoneUseCase {
  final MilestoneRepository _repository;

  CreateMilestoneUseCase(this._repository);

  Future<Milestone> call({
    required String projectId,
    required String name,
    String? description,
    String? status,
    DateTime? dueDate,
    List<String>? tags,
    String? ownerId,
  }) {
    return _repository.createMilestone(
      projectId: projectId,
      name: name,
      description: description,
      status: status,
      dueDate: dueDate,
      tags: tags,
      ownerId: ownerId,
    );
  }
}