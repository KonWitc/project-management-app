class TimeTrackingSummary {
  final double totalEstimatedHours;
  final double totalLoggedHours;
  final double remainingHours;

  const TimeTrackingSummary({
    required this.totalEstimatedHours,
    required this.totalLoggedHours,
    required this.remainingHours,
  });

  factory TimeTrackingSummary.empty() {
    return const TimeTrackingSummary(
      totalEstimatedHours: 0,
      totalLoggedHours: 0,
      remainingHours: 0,
    );
  }

  double get progressPercentage =>
      totalEstimatedHours == 0
          ? 0
          : (totalLoggedHours / totalEstimatedHours * 100).clamp(0, 100);

  bool get isOvertime => totalLoggedHours > totalEstimatedHours;
}
