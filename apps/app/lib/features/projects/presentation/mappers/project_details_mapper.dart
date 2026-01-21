import 'package:app/features/projects/domain/models/milestone.dart';
import 'package:app/features/projects/domain/models/project.dart';
import 'package:app/features/projects/domain/models/project_enums.dart';
import 'package:app/features/projects/presentation/models/details/milestones_overview_model.dart';
import 'package:app/features/projects/presentation/models/details/project_budget_model.dart';
import 'package:app/features/projects/presentation/models/details/project_details_header_model.dart';
import 'package:app/features/projects/presentation/models/details/project_details_ui_model.dart';
import 'package:app/features/projects/presentation/models/details/project_tasks_overview_model.dart';
import 'package:app/features/projects/presentation/models/details/project_timeline_model.dart';
import 'package:app/features/tasks/domain/models/task.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProjectDetailsMapper {
  static ProjectDetailsUiModel mapDomainToPresentation(Project project) {
    return ProjectDetailsUiModel(
      projectId: project.id,
      header: _mapHeader(project),
      timeline: _mapTimeline(project),
      budget: _mapBudget(project),
      tasksOverview: _mapTasksOverview(project),
      milestonesOverview: _mapMilestonesOverview(project),
    );
  }

  // ───────────────────────── HEADER ─────────────────────────

  static ProjectDetailsHeaderModel _mapHeader(Project project) {
    return ProjectDetailsHeaderModel(
      name: project.name,
      description: project.description,
      statusLabel: _statusLabel(project.status),
      statusColor: _statusColor(project.status, project.isOverdue),
      category: project.category?.name ?? 'Uncategorized',
      tags: project.tags,
    );
  }

  // ───────────────────────── TIMELINE ─────────────────────────

  static ProjectDetailsTimelineModel _mapTimeline(Project project) {
    return ProjectDetailsTimelineModel(
      startDateLabel: _formatDate(project.startDate),
      endDateLabel: _formatDate(project.endDate),
      deadlineLabel: _formatDate(project.deadline),
      isOverdue: project.isOverdue,
    );
  }

  // ───────────────────────── BUDGET ─────────────────────────

  static ProjectBudgetModel _mapBudget(Project project) {
    final budget = project.budget;
    final actual = project.actualCost;
    final revenue = project.revenueEstimate;

    double? signedDiff;
    double? diff;

    if (budget != null && actual != null) {
      signedDiff = actual - budget;
      diff = signedDiff.abs();
    }

    return ProjectBudgetModel(
      budgetLabel: budget != null ? _formatMoney(budget) : null,
      actualCostLabel: actual != null ? _formatMoney(actual) : null,
      revenueEstimateLabel: revenue != null ? _formatMoney(revenue) : null,

      costDifference: diff,
      costDifferenceLabel: diff != null ? _formatMoney(diff) : null,
      costDifferenceColor: _costDiffColor(signedDiff),
      costDifferenceIcon: _costDiffIcon(signedDiff),
    );
  }

  // ───────────────────────── TASKS ─────────────────────────

  static ProjectTasksOverviewModel _mapTasksOverview(Project project) {
    final overview = project.tasksOverview;

    if (overview == null) {
      return const ProjectTasksOverviewModel(
        tasksCount: 0,
        openTasksCount: 0,
        completedTasksCount: 0,
        upcomingTasks: [],
      );
    }

    final upcoming = overview.upcomingTasks;

    return ProjectTasksOverviewModel(
      tasksCount: overview.count,
      openTasksCount: overview.openCount,
      completedTasksCount: overview.completedCount,
      upcomingTasks: upcoming
          .take(5)
          .map(_mapTaskOverview)
          .toList(growable: false),
    );
  }

  static TaskOverviewModel _mapTaskOverview(Task task) {
    return TaskOverviewModel(
      title: task.title,
      dueDateLabel: _formatDate(task.dueDate),
      isOverdue: task.isOverdue,
      statusLabel: task.status.name,
      priorityLabel: task.priority.name,
    );
  }

  // ───────────────────────── MILESTONES ─────────────────────────

  static MilestonesOverviewModel _mapMilestonesOverview(Project project) {
    final m = project.milestones;

    if (m == null) {
      return const MilestonesOverviewModel(
        milestonesCount: 0,
        completedMilestonesCount: 0,
        completedMilestonesPercentage: 0,
        milestones: [],
      );
    }

    final double percentage = m.count == 0 ? 0 : (m.completedCount / m.count);

    return MilestonesOverviewModel(
      milestonesCount: m.count,
      completedMilestonesCount: m.completedCount,
      completedMilestonesPercentage: percentage,
      milestones: m.items.map(_mapMilestone).toList(growable: false),
    );
  }

  static MilestoneUiModel _mapMilestone(Milestone milestone) {
    return MilestoneUiModel(
      name: milestone.name,
      description: milestone.description,
      statusLabel: milestone.progress >= 100 ? 'Completed' : 'In progress',
      dueDateLabel: _formatDate(milestone.dueDate),
      isOverdue: milestone.isOverdue,
      progress: milestone.progress,
    );
  }

  // ───────────────────────── HELPERS ─────────────────────────

  static String? _formatDate(DateTime? date) {
    if (date == null) return null;
    return DateFormat('dd MM yyyy').format(date);
  }

  static String _formatMoney(double value) {
    return NumberFormat.currency(symbol: '€', decimalDigits: 2).format(value);
  }

  static String _statusLabel(ProjectStatus status) {
    switch (status) {
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

  static Color _statusColor(ProjectStatus status, bool isOverdue) {
    if (isOverdue && status == ProjectStatus.active) {
      return Colors.red;
    }

    switch (status) {
      case ProjectStatus.draft:
        return Colors.amber.shade600;
      case ProjectStatus.active:
        return Colors.green;
      case ProjectStatus.completed:
        return Colors.blueAccent;
      case ProjectStatus.archived:
        return Colors.grey.shade600;
    }
  }

  static Color? _costDiffColor(double? signedDiff) {
    if (signedDiff == null || signedDiff == 0) return null;
    return signedDiff > 0 ? Colors.red : Colors.green;
  }

  static IconData _costDiffIcon(double? signedDiff) {
    if (signedDiff == null || signedDiff == 0) {
      return Icons.horizontal_rule_rounded;
    }
    return signedDiff > 0
        ? Icons.trending_up_rounded
        : Icons.trending_down_rounded;
  }
}
