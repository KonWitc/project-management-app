import 'package:app/features/projects/domain/models/project_enums.dart';

class _Unset {
  const _Unset();
}

const _unset = _Unset();

class ProjectFilters {
  final String? search;
  final Set<ProjectStatus> status;
  final String? ownerId;
  final String? memberId;
  final List<String> tags;
  final DateTime? deadlineFrom;
  final DateTime? deadlineTo;
  final int page;
  final int limit;
  final SortBy sortBy;
  final SortDir sortDir;

  const ProjectFilters({
    this.search,
    this.ownerId,
    this.memberId,
    this.tags = const <String>[],
    this.deadlineFrom,
    this.deadlineTo,
    this.page = 1,
    this.limit = 20,
    this.sortBy = SortBy.deadline,
    this.sortDir = SortDir.asc,
    this.status = const <ProjectStatus>{},
  });

  ProjectFilters copyWith({
    Object? search = _unset,
    Object? ownerId = _unset,
    Object? memberId = _unset,
    Object? deadlineFrom = _unset,
    Object? deadlineTo = _unset,

    Set<ProjectStatus>? status,
    List<String>? tags,
    int? page,
    int? limit,
    SortBy? sortBy,
    SortDir? sortDir,
  }) {
    return ProjectFilters(
      search: identical(search, _unset) ? this.search : search as String?,
      ownerId: identical(ownerId, _unset) ? this.ownerId : ownerId as String?,
      memberId: identical(memberId, _unset)
          ? this.memberId
          : memberId as String?,
      deadlineFrom: identical(deadlineFrom, _unset)
          ? this.deadlineFrom
          : deadlineFrom as DateTime?,
      deadlineTo: identical(deadlineTo, _unset)
          ? this.deadlineTo
          : deadlineTo as DateTime?,

      status: status ?? this.status,
      tags: tags ?? this.tags,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      sortBy: sortBy ?? this.sortBy,
      sortDir: sortDir ?? this.sortDir,
    );
  }

  Map<String, dynamic> toQueryParameters() {
    return <String, dynamic>{
      if (search != null && search!.isNotEmpty) 'search': search,
      if (status.isNotEmpty) 'status': status.map((s) => s.name).toList(),
      if (ownerId != null) 'ownerId': ownerId,
      if (memberId != null) 'memberId': memberId,
      if (tags.isNotEmpty) 'tags': tags,
      if (deadlineFrom != null) 'deadlineFrom': deadlineFrom!.toIso8601String(),
      if (deadlineTo != null) 'deadlineTo': deadlineTo!.toIso8601String(),
      'page': page,
      'limit': limit,
      'sortBy': sortBy.name,
      'sortDir': sortDir.name,
    };
  }
}
