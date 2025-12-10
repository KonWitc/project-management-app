import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:app/features/projects/domain/models/project.dart';
import 'package:app/features/projects/domain/models/project_enums.dart';
import 'package:app/features/projects/presentation/models/project_card_model.dart';

class ProjectCardMapper {
  static ProjectCardModel mapDomainToPresentation(Project project) {
    // --- Date labels ---
    final startDateLabel = _formatDate(project.startDate);
    final endDateLabel = _formatDate(project.endDate);
    final deadlineLabel = _formatDate(project.deadline);

    final isOverdue = project.isOverdue;

    // --- Revenue estimate (EUR, English) ---
    final String? revenueEstimateLabel = project.revenueEstimate != null
        ? _formatMoney(project.revenueEstimate!)
        : null;

    // --- Cost difference (budget vs actualCost) ---
    // signedDiff > 0 → actualCost > budget → over budget
    // signedDiff < 0 → actualCost < budget → under budget
    double? costDifference;
    double? signedCostDiff;

    if (project.budget != null && project.actualCost != null) {
      signedCostDiff = project.actualCost! - project.budget!;
      costDifference = signedCostDiff.abs();
    }

    final Color? costDifferenceColor = _mapCostDifferenceColor(signedCostDiff);
    final IconData costDifferenceIcon = _mapCostDifferenceIcon(signedCostDiff);

    // --- Status mapping ---
    final String statusLabel = project.status.label;
    final Color statusColor = _mapStatusToColor(project.status, isOverdue);

    return ProjectCardModel(
      id: project.id,
      name: project.name,
      description: project.description,

      statusLabel: statusLabel,
      statusColor: statusColor,

      startDateLabel: startDateLabel,
      endDateLabel: endDateLabel,
      deadlineLabel: deadlineLabel,
      isOverdue: isOverdue,

      revenueEstimateLabel: revenueEstimateLabel,
      costDifference: costDifference,
      costDifferenceColor: costDifferenceColor,
      costDifferenceIcon: costDifferenceIcon,

      tags: project.tags,
      category: project.category?.name ?? 'Uncategorized',
    );
  }

  // ---------------------------------------------------------------------------
  // Date → formatted string
  // ---------------------------------------------------------------------------

  static String? _formatDate(DateTime? date) {
    if (date == null) return null;
    // example: 05 Dec 2025
    return DateFormat('dd MMM yyyy').format(date);
  }

  // ---------------------------------------------------------------------------
  // Money formatting
  // ---------------------------------------------------------------------------

  static String _formatMoney(double value) {
    final formatter = NumberFormat.currency(
      locale: 'pl_PL',
      symbol: '€',
      decimalDigits: 2,
    );
    return formatter.format(value);
  }

  // ---------------------------------------------------------------------------
  // Status color (presentation-level)
  // ---------------------------------------------------------------------------

  static Color _mapStatusToColor(ProjectStatus status, bool isOverdue) {
    // You can later replace these with your ColorScheme values
    if (isOverdue && status == ProjectStatus.active) {
      return Colors.red;
    }

    switch (status) {
      case ProjectStatus.draft:
        return Colors.amber;
      case ProjectStatus.active:
        return Colors.green;
      case ProjectStatus.completed:
        return Colors.blueAccent;
      case ProjectStatus.archived:
        return Colors.grey.shade600;
    }
  }

  // ---------------------------------------------------------------------------
  // Cost difference styling
  //
  // signedDiff == null → no data
  // signedDiff == 0    → on budget
  // signedDiff > 0     → over budget (actual > budget)
  // signedDiff < 0     → under budget (actual < budget)
  // ---------------------------------------------------------------------------

  static Color? _mapCostDifferenceColor(double? signedDiff) {
    if (signedDiff == null) return null;
    if (signedDiff == 0) return Colors.grey;

    // later: use colorScheme.error / colorScheme.tertiary, etc.
    return signedDiff > 0 ? Colors.red : Colors.green;
  }

  static IconData _mapCostDifferenceIcon(double? signedDiff) {
    if (signedDiff == null) return Icons.horizontal_rule_rounded;
    if (signedDiff == 0) return Icons.horizontal_rule_rounded;

    return signedDiff > 0
        ? Icons
              .trending_up_rounded // costs went up → over budget
        : Icons.trending_down_rounded; // costs went down → under budget
  }
}
