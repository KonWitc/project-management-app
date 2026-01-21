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
    case 'completed':
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
    tags: List.unmodifiable(dto.tags ?? []),
    taskType: dto.taskType,
  );
}

String _statusToString(TaskStatus status) {
  switch (status) {
    case TaskStatus.notStarted:
      return 'not_started';
    case TaskStatus.inProgress:
      return 'in_progress';
    case TaskStatus.blocked:
      return 'blocked';
    case TaskStatus.cancelled:
      return 'cancelled';
    case TaskStatus.done:
      return 'completed';
  }
}

String _priorityToString(TaskPriority priority) {
  switch (priority) {
    case TaskPriority.low:
      return 'low';
    case TaskPriority.medium:
      return 'medium';
    case TaskPriority.high:
      return 'high';
    case TaskPriority.critical:
      return 'critical';
  }
}

Map<String, dynamic> mapTaskDomainToCreateDto(Task task) {
  return {
    'title': task.title,
    'description': task.description,
    'projectId': task.projectId,
    if (task.milestoneId != null) 'milestoneId': task.milestoneId,
    if (task.assigneeId != null) 'assigneeId': task.assigneeId,
    if (task.reporterId != null) 'reporterId': task.reporterId,
    'status': _statusToString(task.status),
    'priority': _priorityToString(task.priority),
    'orderIndex': task.orderIndex,
    if (task.startDate != null) 'startDate': task.startDate!.toIso8601String(),
    if (task.dueDate != null) 'dueDate': task.dueDate!.toIso8601String(),
    if (task.estimateHours != null) 'estimateHours': task.estimateHours,
    if (task.loggedHours != null) 'loggedHours': task.loggedHours,
    'tags': task.tags,
    if (task.taskType != null) 'taskType': task.taskType,
  };
}

Map<String, dynamic> mapTaskDomainToUpdateDto(Task task) {
  return {
    if (task.title.isNotEmpty) 'title': task.title,
    'description': task.description,
    if (task.projectId.isNotEmpty) 'projectId': task.projectId,
    'milestoneId': task.milestoneId,
    'assigneeId': task.assigneeId,
    'reporterId': task.reporterId,
    'status': _statusToString(task.status),
    'priority': _priorityToString(task.priority),
    'orderIndex': task.orderIndex,
    'startDate': task.startDate?.toIso8601String(),
    'dueDate': task.dueDate?.toIso8601String(),
    if (task.completedAt != null)
      'completedAt': task.completedAt!.toIso8601String(),
    'estimateHours': task.estimateHours,
    'loggedHours': task.loggedHours,
    'tags': task.tags,
    'taskType': task.taskType,
  };
}
