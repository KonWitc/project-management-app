import 'package:app/features/projects/domain/models/project_enums.dart';
import 'package:app/features/projects/domain/models/milestone.dart';
import 'package:app/features/tasks/domain/models/task.dart';

class Project {
  final String id;
  final String name;
  final String? description;
  final ProjectStatus status;

  final String organizationId;
  final String ownerId;
  final List<String> memberIds;

  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? deadline;

  final List<Milestone> milestones;
  final List<Task> tasks;

  final double? budget;
  final double? actualCost;
  final double? revenueEstimate;

  final List<String> tags;
  final ProjectCategory? category;

  const Project({
    required this.id,
    required this.name,
    this.description,
    required this.status,
    required this.organizationId,
    required this.ownerId,
    required this.memberIds,
    this.startDate,
    this.endDate,
    this.deadline,
    required this.milestones,
    required this.tasks,
    this.budget,
    this.actualCost,
    this.revenueEstimate,
    required this.tags,
    this.category,
  });

  double get completionProgress {
    if (milestones.isEmpty) return 0;
    final total = milestones.fold<int>(0, (sum, m) => sum + (m.progress));
    return total / (milestones.length * 100);
  }

  bool get isOverdue =>
      deadline != null && deadline!.isBefore(DateTime.now()) &&
      status != ProjectStatus.completed &&
      status != ProjectStatus.archived;
}
