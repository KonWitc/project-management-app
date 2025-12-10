import 'package:app/features/projects/domain/models/project_filters.dart';
import 'package:app/features/projects/domain/models/project_enums.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProjectFiltersNotifier extends Notifier<ProjectFilters> {
  @override
  ProjectFilters build() {
    return const ProjectFilters();
  }

  // --- SETTERS ---

  void setSearch(String? value) {
    state = state.copyWith(
      search: (value == null || value.isEmpty) ? null : value,
      page: 1,
    );
  }

  void setStatuses(Set<ProjectStatus> statuses) {
    state = state.copyWith(status: statuses, page: 1);
  }

  void toggleStatus(ProjectStatus status) {
    final newSet = state.status.contains(status)
        ? (state.status.toSet()..remove(status))
        : (state.status.toSet()..add(status));

    state = state.copyWith(status: newSet, page: 1);
  }

  void clearStatuses() {
    state = state.copyWith(status: <ProjectStatus>{}, page: 1);
  }

  void setOwner(String? ownerId) {
    state = state.copyWith(ownerId: ownerId, page: 1);
  }

  void setMember(String? memberId) {
    state = state.copyWith(memberId: memberId, page: 1);
  }

  void setTags(List<String> tags) {
    state = state.copyWith(tags: tags, page: 1);
  }

  void setDeadlineRange(DateTime? from, DateTime? to) {
    // clear
    if (from == null && to == null) {
      state = ProjectFilters(
        search: state.search,
        status: state.status,
        ownerId: state.ownerId,
        memberId: state.memberId,
        tags: state.tags,
        deadlineFrom: null,
        deadlineTo: null,
        page: 1,
        limit: state.limit,
        sortBy: state.sortBy,
        sortDir: state.sortDir,
      );
      return;
    }

    state = state.copyWith(
      deadlineFrom: from,
      deadlineTo: to,
      page: 1,
    );
  }

  void setSort({required SortBy sortBy, required SortDir sortDir}) {
    state = state.copyWith(sortBy: sortBy, sortDir: sortDir, page: 1);
  }

  void setPagination({int? page, int? limit}) {
    state = state.copyWith(
      page: page ?? state.page,
      limit: limit ?? state.limit,
    );
  }

  void reset() {
    state = const ProjectFilters();
  }
}

final projectFiltersProvider =
    NotifierProvider<ProjectFiltersNotifier, ProjectFilters>(
      ProjectFiltersNotifier.new,
    );
