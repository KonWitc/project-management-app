// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjectDto _$ProjectDtoFromJson(Map<String, dynamic> json) => ProjectDto(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  status: json['status'] as String,
  organizationId: json['organizationId'] as String?,
  ownerId: json['ownerId'] as String,
  memberIds: (json['memberIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  startDate: json['startDate'] == null
      ? null
      : DateTime.parse(json['startDate'] as String),
  endDate: json['endDate'] == null
      ? null
      : DateTime.parse(json['endDate'] as String),
  deadline: json['deadline'] == null
      ? null
      : DateTime.parse(json['deadline'] as String),
  milestones: (json['milestones'] as List<dynamic>)
      .map((e) => MilestoneDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  upcomingTasks: (json['upcomingTasks'] as List<dynamic>)
      .map((e) => TaskDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  budget: (json['budget'] as num?)?.toDouble(),
  actualCost: (json['actualCost'] as num?)?.toDouble(),
  revenueEstimate: (json['revenueEstimate'] as num?)?.toDouble(),
  tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
  category: json['category'] as String?,
  milestonesCount: (json['milestonesCount'] as num).toInt(),
  completedMilestonesCount: (json['completedMilestonesCount'] as num).toInt(),
  tasksCount: (json['tasksCount'] as num).toInt(),
  openTasksCount: (json['openTasksCount'] as num).toInt(),
  completedTasksCount: (json['completedTasksCount'] as num).toInt(),
);

Map<String, dynamic> _$ProjectDtoToJson(ProjectDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'status': instance.status,
      'organizationId': instance.organizationId,
      'ownerId': instance.ownerId,
      'memberIds': instance.memberIds,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'deadline': instance.deadline?.toIso8601String(),
      'milestonesCount': instance.milestonesCount,
      'completedMilestonesCount': instance.completedMilestonesCount,
      'milestones': instance.milestones.map((e) => e.toJson()).toList(),
      'tasksCount': instance.tasksCount,
      'openTasksCount': instance.openTasksCount,
      'completedTasksCount': instance.completedTasksCount,
      'upcomingTasks': instance.upcomingTasks.map((e) => e.toJson()).toList(),
      'budget': instance.budget,
      'actualCost': instance.actualCost,
      'revenueEstimate': instance.revenueEstimate,
      'tags': instance.tags,
      'category': instance.category,
    };
