class TaskDetailsContextModel {
  final String? projectId;
  final String? projectName;
  final String? milestoneId;
  final String? milestoneName;
  final String? assigneeId;
  final String? assigneeName;
  final String? reporterId;
  final String? reporterName;
  final bool hasProject;

  const TaskDetailsContextModel({
    this.projectId,
    this.projectName,
    this.milestoneId,
    this.milestoneName,
    this.assigneeId,
    this.assigneeName,
    this.reporterId,
    this.reporterName,
    required this.hasProject,
  });
}
