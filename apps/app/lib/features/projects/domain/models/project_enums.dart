enum ProjectStatus { draft, active, completed, archived }

extension ProjectStatusX on ProjectStatus {
  String get label {
    switch (this) {
      case ProjectStatus.draft:
        return 'Draft';
      case ProjectStatus.active:
        return 'Active';
      case ProjectStatus.completed:
        return 'Completed';
      case ProjectStatus.archived:
        return 'Archived';
    }
  }
}

enum MilestoneStatus { notStarted, inProgress, completed, cancelled }

enum ProjectCategory {
  it,
  construction,
  eCommerce,
  rd,
  marketing,
  education,
  production,
  administration,
  logistics,
  energy,
  other,
}

enum SortBy { createdAt, startDate, deadline, name, status }

extension SortByX on SortBy {
  String get label {
    switch (this) {
      case SortBy.createdAt:
        return 'Created At';
      case SortBy.startDate:
        return 'Start Date';
      case SortBy.deadline:
        return 'Deadline';
      case SortBy.name:
        return 'Project Name';
      case SortBy.status:
        return 'Status';
    }
  }
}

enum SortDir { asc, desc }

extension SortDirX on SortDir {
  String get label {
    switch (this) {
      case SortDir.asc:
        return 'Ascending';
      case SortDir.desc:
        return 'Descending';
    }
  }
}

typedef ProjectId = String;
typedef UserId = String;
