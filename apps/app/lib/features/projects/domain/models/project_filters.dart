import 'package:app/features/projects/domain/models/project_enums.dart';

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
    String? search,
    Set<ProjectStatus>? status,
    String? ownerId,
    String? memberId,
    List<String>? tags,
    DateTime? deadlineFrom,
    DateTime? deadlineTo,
    int? page,
    int? limit,
    SortBy? sortBy,
    SortDir? sortDir,
  }) {
    return ProjectFilters(
      search: search ?? this.search,
      status: status ?? this.status,
      ownerId: ownerId ?? this.ownerId,
      memberId: memberId ?? this.memberId,
      tags: tags ?? this.tags,
      deadlineFrom: deadlineFrom ?? this.deadlineFrom,
      deadlineTo: deadlineTo ?? this.deadlineTo,
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
