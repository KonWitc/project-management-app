import 'package:app/features/tasks/data/dto/task_dto.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:app/features/projects/data/dto/milestone_dto.dart';

part 'project_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class ProjectDto {
  final String id;

  final String name;
  final String? description;
  final String status; // 'draft' | 'active' | 'completed' | 'archived'

  final String? organizationId;
  final String ownerId;
  final List<String> memberIds;

  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? deadline;

  final int milestonesCount;
  final int completedMilestonesCount;
  final List<MilestoneDto> milestones;

  final int tasksCount;
  final int openTasksCount;
  final int completedTasksCount;
  final List<TaskDto> upcomingTasks;

  final double? budget;
  final double? actualCost;
  final double? revenueEstimate;

  final List<String> tags;
  final String? category;

  ProjectDto({
    required this.id,
    required this.name,
    this.description,
    required this.status,
    this.organizationId,
    required this.ownerId,
    required this.memberIds,
    this.startDate,
    this.endDate,
    this.deadline,
    required this.milestones,
    required this.upcomingTasks,
    this.budget,
    this.actualCost,
    this.revenueEstimate,
    required this.tags,
    this.category,
    required this.milestonesCount,
    required this.completedMilestonesCount,
    required this.tasksCount,
    required this.openTasksCount,
    required this.completedTasksCount,
  });

  factory ProjectDto.fromJson(Map<String, dynamic> json) =>
      _$ProjectDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectDtoToJson(this);
}
