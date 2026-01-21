import 'package:app/features/tasks/domain/models/task_enums.dart';

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
  final int? page;
  final int? limit;

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
    this.page,
    this.limit,
  });

  TaskFilters copyWith({
    String? projectId,
    String? milestoneId,
    String? assigneeId,
    String? reporterId,
    TaskStatus? status,
    TaskPriority? priority,
    String? search,
    List<String>? tags,
    String? taskType,
    String? sortBy,
    String? sortOrder,
    int? page,
    int? limit,
  }) {
    return TaskFilters(
      projectId: projectId ?? this.projectId,
      milestoneId: milestoneId ?? this.milestoneId,
      assigneeId: assigneeId ?? this.assigneeId,
      reporterId: reporterId ?? this.reporterId,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      search: search ?? this.search,
      tags: tags ?? this.tags,
      taskType: taskType ?? this.taskType,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
      page: page ?? this.page,
      limit: limit ?? this.limit,
    );
  }

  Map<String, dynamic> toQueryParameters() {
    final params = <String, dynamic>{};

    if (projectId != null) params['projectId'] = projectId;
    if (milestoneId != null) params['milestoneId'] = milestoneId;
    if (assigneeId != null) params['assigneeId'] = assigneeId;
    if (reporterId != null) params['reporterId'] = reporterId;
    if (status != null) params['status'] = _statusToString(status!);
    if (priority != null) params['priority'] = _priorityToString(priority!);
    if (search != null && search!.isNotEmpty) params['search'] = search;
    if (tags != null && tags!.isNotEmpty) params['tags'] = tags!.join(',');
    if (taskType != null) params['taskType'] = taskType;
    if (sortBy != null) params['sortBy'] = sortBy;
    if (sortOrder != null) params['sortOrder'] = sortOrder;
    if (page != null) params['page'] = page;
    if (limit != null) params['limit'] = limit;

    return params;
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
