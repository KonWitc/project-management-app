import 'package:app/features/tasks/domain/models/task_enums.dart';

class _Unset {
  const _Unset();
}

const _unset = _Unset();

class TaskFilters {
  final String? projectId;
  final String? milestoneId;
  final String? assigneeId;
  final String? reporterId;
  final TaskStatus? status;
  final TaskPriority? priority;
  final String? search;
  final List<String>? tags;
  final String? taskType;
  final String? sortBy;
  final String? sortOrder;
  final int page;
  final int limit;

  const TaskFilters({
    this.projectId,
    this.milestoneId,
    this.assigneeId,
    this.reporterId,
    this.status,
    this.priority,
    this.search,
    this.tags,
    this.taskType,
    this.sortBy,
    this.sortOrder,
    this.page = 1,
    this.limit = 20,
  });

  TaskFilters copyWith({
    Object? projectId = _unset,
    Object? milestoneId = _unset,
    Object? assigneeId = _unset,
    Object? reporterId = _unset,
    Object? status = _unset,
    Object? priority = _unset,
    Object? search = _unset,
    Object? tags = _unset,
    Object? taskType = _unset,
    Object? sortBy = _unset,
    Object? sortOrder = _unset,
    int? page,
    int? limit,
  }) {
    return TaskFilters(
      projectId: identical(projectId, _unset)
          ? this.projectId
          : projectId as String?,
      milestoneId: identical(milestoneId, _unset)
          ? this.milestoneId
          : milestoneId as String?,
      assigneeId: identical(assigneeId, _unset)
          ? this.assigneeId
          : assigneeId as String?,
      reporterId: identical(reporterId, _unset)
          ? this.reporterId
          : reporterId as String?,
      status:
          identical(status, _unset) ? this.status : status as TaskStatus?,
      priority: identical(priority, _unset)
          ? this.priority
          : priority as TaskPriority?,
      search:
          identical(search, _unset) ? this.search : search as String?,
      tags: identical(tags, _unset)
          ? this.tags
          : tags as List<String>?,
      taskType: identical(taskType, _unset)
          ? this.taskType
          : taskType as String?,
      sortBy:
          identical(sortBy, _unset) ? this.sortBy : sortBy as String?,
      sortOrder: identical(sortOrder, _unset)
          ? this.sortOrder
          : sortOrder as String?,
      page: page ?? this.page,
      limit: limit ?? this.limit,
    );
  }

  Map<String, dynamic> toQueryParameters() {
    return <String, dynamic>{
      if (projectId != null) 'projectId': projectId,
      if (milestoneId != null) 'milestoneId': milestoneId,
      if (assigneeId != null) 'assigneeId': assigneeId,
      if (reporterId != null) 'reporterId': reporterId,
      if (status != null) 'status': _statusToString(status!),
      if (priority != null) 'priority': _priorityToString(priority!),
      if (search != null && search!.isNotEmpty) 'search': search,
      if (tags != null && tags!.isNotEmpty) 'tags': tags!.join(','),
      if (taskType != null) 'taskType': taskType,
      if (sortBy != null) 'sortBy': sortBy,
      if (sortOrder != null) 'sortOrder': sortOrder,
      'page': page,
      'limit': limit,
    };
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
}