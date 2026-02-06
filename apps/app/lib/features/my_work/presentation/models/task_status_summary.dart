class TaskStatusSummary {
  final int total;
  final int notStarted;
  final int inProgress;
  final int blocked;
  final int done;
  final int overdue;

  const TaskStatusSummary({
    required this.total,
    required this.notStarted,
    required this.inProgress,
    required this.blocked,
    required this.done,
    required this.overdue,
  });

  factory TaskStatusSummary.empty() {
    return const TaskStatusSummary(
      total: 0,
      notStarted: 0,
      inProgress: 0,
      blocked: 0,
      done: 0,
      overdue: 0,
    );
  }

  int get activeCount => notStarted + inProgress + blocked;

  double get completionPercentage =>
      total == 0 ? 0 : (done / total * 100);
}
