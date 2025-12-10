import 'package:app/features/tasks/domain/models/task_enums.dart';

class Task {
  final String id;
  final String projectId;
  final String? milestoneId;
  final String? assigneeId;
  final String? reporterId;

  final String title;
  final String? description;

  final TaskStatus status;
  final TaskPriority priority;

  final int orderIndex;

  final DateTime? startDate;
  final DateTime? dueDate;
  final DateTime? completedAt;

  final double? estimateHours;
  final double? loggedHours;

  final List<String> tags;
  final String? taskType;

  const Task({
    required this.id,
    required this.projectId,
    this.milestoneId,
    this.assigneeId,
    this.reporterId,
    required this.title,
    this.description,
    required this.status,
    required this.priority,
    required this.orderIndex,
    this.startDate,
    this.dueDate,
    this.completedAt,
    this.estimateHours,
    this.loggedHours,
    required this.tags,
    this.taskType,
  });

  bool get isDone => status == TaskStatus.done;

  bool get isOverdue =>
      !isDone && dueDate != null && dueDate!.isBefore(DateTime.now());
}
