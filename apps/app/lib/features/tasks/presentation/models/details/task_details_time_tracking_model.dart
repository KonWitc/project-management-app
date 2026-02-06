class TaskDetailsTimeTrackingModel {
  final String? estimateHoursLabel;
  final String? loggedHoursLabel;
  final double? progressPercentage;
  final bool hasTimeData;

  const TaskDetailsTimeTrackingModel({
    this.estimateHoursLabel,
    this.loggedHoursLabel,
    this.progressPercentage,
    required this.hasTimeData,
  });
}
