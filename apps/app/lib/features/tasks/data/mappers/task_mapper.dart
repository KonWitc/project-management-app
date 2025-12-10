import 'package:app/features/tasks/domain/models/task.dart';
import 'package:app/features/tasks/domain/models/task_enums.dart';
import 'package:app/features/tasks/data/dto/task_dto.dart';

TaskStatus _mapStatus(String value) {
  switch (value) {
    case 'not_started':
      return TaskStatus.notStarted;
    case 'in_progress':
      return TaskStatus.inProgress;
    case 'blocked':
      return TaskStatus.blocked;
    case 'cancelled':
      return TaskStatus.cancelled;
    case 'done':
      return TaskStatus.done;
    default:
      return TaskStatus.notStarted;
  }
}

TaskPriority _mapPriority(String value) {
  switch (value) {
    case 'low':
      return TaskPriority.low;
    case 'medium':
      return TaskPriority.medium;
    case 'high':
      return TaskPriority.high;
    case 'critical':
      return TaskPriority.critical;
    default:
      return TaskPriority.medium;
  }
}

Task mapTaskDtoToDomain(TaskDto dto) {
  return Task(
    id: dto.id,
    projectId: dto.projectId,
    milestoneId: dto.milestoneId,
    assigneeId: dto.assigneeId,
    reporterId: dto.reporterId,
    title: dto.title,
    description: dto.description,
    status: _mapStatus(dto.status),
    priority: _mapPriority(dto.priority),
    orderIndex: dto.orderIndex ?? 0,
    startDate: dto.startDate,
    dueDate: dto.dueDate,
    completedAt: dto.completedAt,
    estimateHours: dto.estimateHours,
    loggedHours: dto.loggedHours,
    tags: List.unmodifiable(dto.tags),
    taskType: dto.taskType,
  );
}
