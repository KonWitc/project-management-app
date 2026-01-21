class MilestonesOverviewModel {
  final int milestonesCount;
  final int completedMilestonesCount;
  final double completedMilestonesPercentage;
  final List<MilestoneUiModel> milestones;

  const MilestonesOverviewModel({
    required this.milestonesCount,
    required this.completedMilestonesCount,
    required this.completedMilestonesPercentage,
    required this.milestones,
  });
}

class MilestoneUiModel {
  final String name;
  final String? description;
  final String statusLabel;

  final String? dueDateLabel;
  final bool isOverdue;

  final int progress;

  const MilestoneUiModel({
    required this.name,
    this.description,
    required this.statusLabel,
    this.dueDateLabel,
    required this.isOverdue,
    required this.progress,
  });
}
