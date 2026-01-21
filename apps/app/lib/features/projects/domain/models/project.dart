import 'package:app/features/projects/domain/models/project_enums.dart';
import 'package:app/features/projects/domain/models/milestone.dart';
import 'package:app/features/tasks/domain/models/task.dart';

class Project {
  // ── core identity
  final String id;
  final String name;
  final String? description;
  final ProjectStatus status;

  // ── ownership / membership
  final String? organizationId;
  final String? ownerId;
  final List<String> memberIds;

  // ── timeline
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? deadline;

  // ── finance
  final double? budget;
  final double? actualCost;
  final double? revenueEstimate;

  // ── classification
  final List<String> tags;
  final ProjectCategory? category;

  // ── milestones
  final ProjectMilestones? milestones;

  // ── tasks overview
  final ProjectTasksOverview? tasksOverview;

  const Project({
    required this.id,
    required this.name,
    this.description,
    required this.status,
    this.organizationId,
    this.ownerId,
    this.memberIds = const [],
    this.startDate,
    this.endDate,
    this.deadline,
    this.budget,
    this.actualCost,
    this.revenueEstimate,
    this.tags = const [],
    this.category,
    this.milestones,
    this.tasksOverview,
  });

  // ───────────────────────── Derived domain helpers ─────────────────────────

  bool get isOverdue =>
      deadline != null &&
      deadline!.isBefore(DateTime.now()) &&
      status != ProjectStatus.completed &&
      status != ProjectStatus.archived;

  double get completionProgress {
    final m = milestones;
    if (m == null) return 0;

    if (m.items.isNotEmpty) {
      final total = m.items.fold<int>(0, (sum, it) => sum + it.progress);
      return m.items.isEmpty ? 0 : total / (m.items.length * 100);
    }

    if (m.count == 0) return 0;
    return (m.completedCount / m.count).clamp(0, 1);
  }

  /// const difference (signed): actual - budget
  double? get signedCostDifference {
    if (budget == null || actualCost == null) return null;
    return actualCost! - budget!;
  }

  double? get costDifferenceAbs => signedCostDifference?.abs();
}

/// Milestones overview:
class ProjectMilestones {
  final int count;
  final int completedCount;
  final List<Milestone> items;

  const ProjectMilestones({
    required this.count,
    required this.completedCount,
    this.items = const [],
  });
}

/// Tasks overview:
class ProjectTasksOverview {
  final int count;
  final int openCount;
  final int completedCount;
  final List<Task> upcomingTasks;

  const ProjectTasksOverview({
    required this.count,
    required this.openCount,
    required this.completedCount,
    this.upcomingTasks = const [],
  });
}
