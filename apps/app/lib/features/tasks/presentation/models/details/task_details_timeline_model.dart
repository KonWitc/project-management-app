class TaskDetailsTimelineModel {
  final String? startDateLabel;
  final String? dueDateLabel;
  final String? completedAtLabel;
  final bool isOverdue;

  const TaskDetailsTimelineModel({
    this.startDateLabel,
    this.dueDateLabel,
    this.completedAtLabel,
    required this.isOverdue,
  });
}
