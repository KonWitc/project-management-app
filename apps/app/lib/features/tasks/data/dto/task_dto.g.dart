// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskDto _$TaskDtoFromJson(Map<String, dynamic> json) => TaskDto(
  id: json['_id'] as String,
  projectId: json['projectId'] as String,
  milestoneId: json['milestoneId'] as String?,
  assigneeId: json['assigneeId'] as String?,
  reporterId: json['reporterId'] as String?,
  title: json['title'] as String,
  description: json['description'] as String?,
  status: json['status'] as String,
  priority: json['priority'] as String,
  orderIndex: (json['orderIndex'] as num?)?.toInt(),
  startDate: json['startDate'] == null
      ? null
      : DateTime.parse(json['startDate'] as String),
  dueDate: json['dueDate'] == null
      ? null
      : DateTime.parse(json['dueDate'] as String),
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
  estimateHours: (json['estimateHours'] as num?)?.toDouble(),
  loggedHours: (json['loggedHours'] as num?)?.toDouble(),
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
  taskType: json['taskType'] as String?,
);

Map<String, dynamic> _$TaskDtoToJson(TaskDto instance) => <String, dynamic>{
  '_id': instance.id,
  'projectId': instance.projectId,
  'milestoneId': instance.milestoneId,
  'assigneeId': instance.assigneeId,
  'reporterId': instance.reporterId,
  'title': instance.title,
  'description': instance.description,
  'status': instance.status,
  'priority': instance.priority,
  'orderIndex': instance.orderIndex,
  'startDate': instance.startDate?.toIso8601String(),
  'dueDate': instance.dueDate?.toIso8601String(),
  'completedAt': instance.completedAt?.toIso8601String(),
  'estimateHours': instance.estimateHours,
  'loggedHours': instance.loggedHours,
  'tags': instance.tags,
  'taskType': instance.taskType,
};
