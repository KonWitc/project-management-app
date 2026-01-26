import 'package:json_annotation/json_annotation.dart';

part 'task_dto.g.dart';

@JsonSerializable()
class TaskDto {
  @JsonKey(name: '_id')
  final String id;

  final String projectId;
  final String? milestoneId;
  final String? assigneeId;
  final String? reporterId;

  final String title;
  final String? description;

  final String status; // 'todo' | 'in_progress' | 'blocked' | 'done'
  final String priority; // 'low' | 'medium' | 'high' | 'critical'

  final int? orderIndex;

  final DateTime? startDate;
  final DateTime? dueDate;
  final DateTime? completedAt;

  final double? estimateHours;
  final double? loggedHours;

  @JsonKey(defaultValue: [])
  final List<String>? tags;
  final String? taskType;

  TaskDto({
    required this.id,
    required this.projectId,
    this.milestoneId,
    this.assigneeId,
    this.reporterId,
    required this.title,
    this.description,
    required this.status,
    required this.priority,
    this.orderIndex,
    this.startDate,
    this.dueDate,
    this.completedAt,
    this.estimateHours,
    this.loggedHours,
    this.tags = const [],
    this.taskType,
  });

  factory TaskDto.fromJson(Map<String, dynamic> json) =>
      _$TaskDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TaskDtoToJson(this);
}
