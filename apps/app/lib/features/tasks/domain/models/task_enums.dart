enum TaskStatus {
  notStarted,
  inProgress,
  blocked,
  cancelled,
  done,
}

enum TaskPriority {
  low,
  medium,
  high,
  critical,
}

extension TaskStatusX on TaskStatus {
  String get label {
    switch (this) {
      case TaskStatus.notStarted:
        return 'To do';
      case TaskStatus.inProgress:
        return 'In progress';
      case TaskStatus.blocked:
        return 'Blocked';
      case TaskStatus.cancelled:
        return 'Cancelled';
      case TaskStatus.done:
        return 'Done';
    }
  }
}
