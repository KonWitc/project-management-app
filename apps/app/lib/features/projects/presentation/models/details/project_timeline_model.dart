class ProjectDetailsTimelineModel {
  final String? startDateLabel;
  final String? endDateLabel;
  final String? deadlineLabel;
  final bool isOverdue;

  const ProjectDetailsTimelineModel({
    this.startDateLabel,
    this.endDateLabel,
    this.deadlineLabel,
    required this.isOverdue,
  });
}
