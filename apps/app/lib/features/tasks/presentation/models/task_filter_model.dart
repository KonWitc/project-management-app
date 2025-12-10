import 'package:app/features/tasks/domain/models/task_enums.dart';

enum TaskSortField {
  dueDate,
  priority,
  status,
  createdAt,
}

enum SortDirection { asc, desc }

class TaskSortOption {
  final TaskSortField field;
  final SortDirection direction;
  const TaskSortOption({
    required this.field,
    required this.direction,
  });
}

class TaskFilter {
  final String? searchText;
  final Set<TaskStatus> statuses;
  final Set<TaskPriority> priorities;
  final String? assigneeId;
  final String? tag;
  final TaskSortOption sortOption;

  const TaskFilter({
    this.searchText,
    this.statuses = const {},
    this.priorities = const {},
    this.assigneeId,
    this.tag,
    this.sortOption = const TaskSortOption(
      field: TaskSortField.dueDate,
      direction: SortDirection.asc,
    ),
  });

  TaskFilter copyWith({
    String? searchText,
    Set<TaskStatus>? statuses,
    Set<TaskPriority>? priorities,
    String? assigneeId,
    String? tag,
    TaskSortOption? sortOption,
  }) {
    return TaskFilter(
      searchText: searchText ?? this.searchText,
      statuses: statuses ?? this.statuses,
      priorities: priorities ?? this.priorities,
      assigneeId: assigneeId ?? this.assigneeId,
      tag: tag ?? this.tag,
      sortOption: sortOption ?? this.sortOption,
    );
  }
}
