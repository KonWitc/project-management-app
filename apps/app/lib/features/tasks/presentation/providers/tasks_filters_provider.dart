import 'package:app/features/tasks/domain/models/task_enums.dart';
import 'package:app/features/tasks/domain/models/task_filters.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TaskFiltersNotifier extends Notifier<TaskFilters> {
  @override
  TaskFilters build() {
    return const TaskFilters();
  }

  // --- SETTERS ---

  void setProjectId(String? projectId) {
    state = state.copyWith(
      projectId: projectId,
      page: 1,
    );
  }

  void setMilestoneId(String? milestoneId) {
    state = state.copyWith(
      milestoneId: milestoneId,
      page: 1,
    );
  }

  void setAssigneeId(String? assigneeId) {
    state = state.copyWith(
      assigneeId: assigneeId,
      page: 1,
    );
  }

  void setReporterId(String? reporterId) {
    state = state.copyWith(
      reporterId: reporterId,
      page: 1,
    );
  }

  void setStatus(TaskStatus? status) {
    state = state.copyWith(
      status: status,
      page: 1,
    );
  }

  void setPriority(TaskPriority? priority) {
    state = state.copyWith(
      priority: priority,
      page: 1,
    );
  }

  void setSearch(String? value) {
    final v = value?.trim();
    state = state.copyWith(
      search: (v == null || v.isEmpty) ? null : v,
      page: 1,
    );
  }

  void setTags(List<String>? tags) {
    state = state.copyWith(
      tags: tags,
      page: 1,
    );
  }

  void setTaskType(String? taskType) {
    state = state.copyWith(
      taskType: taskType,
      page: 1,
    );
  }

  void setSort({String? sortBy, String? sortOrder}) {
    state = state.copyWith(
      sortBy: sortBy,
      sortOrder: sortOrder,
      page: 1,
    );
  }

  void setPagination({int? page, int? limit}) {
    state = state.copyWith(
      page: page ?? state.page,
      limit: limit ?? state.limit,
    );
  }

  void reset() {
    state = const TaskFilters();
  }
}

final taskFiltersProvider =
    NotifierProvider<TaskFiltersNotifier, TaskFilters>(
  TaskFiltersNotifier.new,
);