import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:app/features/tasks/domain/models/task.dart';
import 'package:app/features/tasks/domain/models/task_enums.dart';
import 'package:app/features/tasks/presentation/models/task_card_model.dart';

class TaskCardMapper {
  static TaskCardModel mapDomainToPresentation(Task task) {
    // --- Date labels ---
    final dueDateLabel = _formatDate(task.dueDate);
    final isOverdue = task.isOverdue;
    final isDone = task.isDone;
    final isInProgress = task.status == TaskStatus.inProgress;

    // --- Time tracking ---
    final estimateHoursLabel = _formatHours(task.estimateHours);
    final loggedHoursLabel = _formatHours(task.loggedHours);
    final progressPercentage = _calculateProgress(
      task.estimateHours,
      task.loggedHours,
    );

    // --- Status mapping ---
    final statusLabel = _mapStatusLabel(task.status);
    final statusColor = _mapStatusColor(task.status, isOverdue);
    final statusIcon = _mapStatusIcon(task.status);

    // --- Priority mapping ---
    final priorityLabel = _mapPriorityLabel(task.priority);
    final priorityColor = _mapPriorityColor(task.priority);
    final priorityIcon = _mapPriorityIcon(task.priority);

    return TaskCardModel(
      id: task.id,
      projectId: task.projectId,
      milestoneId: task.milestoneId,
      title: task.title,
      description: task.description,
      statusLabel: statusLabel,
      statusColor: statusColor,
      statusIcon: statusIcon,
      priorityLabel: priorityLabel,
      priorityColor: priorityColor,
      priorityIcon: priorityIcon,
      dueDateLabel: dueDateLabel,
      isOverdue: isOverdue,
      isDone: isDone,
      isInProgress: isInProgress,
      estimateHoursLabel: estimateHoursLabel,
      loggedHoursLabel: loggedHoursLabel,
      progressPercentage: progressPercentage,
      tags: task.tags,
      taskType: task.taskType,
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
  // Hours formatting
  // ---------------------------------------------------------------------------

  static String? _formatHours(double? hours) {
    if (hours == null) return null;
    if (hours == hours.toInt()) {
      return '${hours.toInt()}h';
    }
    return '${hours.toStringAsFixed(1)}h';
  }

  static double? _calculateProgress(double? estimate, double? logged) {
    if (estimate == null || logged == null || estimate == 0) return null;
    return (logged / estimate).clamp(0.0, 1.0);
  }

  // ---------------------------------------------------------------------------
  // Status mapping
  // ---------------------------------------------------------------------------

  static String _mapStatusLabel(TaskStatus status) {
    switch (status) {
      case TaskStatus.notStarted:
        return 'Not Started';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.blocked:
        return 'Blocked';
      case TaskStatus.cancelled:
        return 'Cancelled';
      case TaskStatus.done:
        return 'Done';
    }
  }

  static Color _mapStatusColor(TaskStatus status, bool isOverdue) {
    if (isOverdue && status != TaskStatus.done) {
      return Colors.red;
    }

    switch (status) {
      case TaskStatus.notStarted:
        return Colors.grey;
      case TaskStatus.inProgress:
        return Colors.blue;
      case TaskStatus.blocked:
        return Colors.orange;
      case TaskStatus.cancelled:
        return Colors.grey.shade600;
      case TaskStatus.done:
        return Colors.green;
    }
  }

  static IconData _mapStatusIcon(TaskStatus status) {
    switch (status) {
      case TaskStatus.notStarted:
        return Icons.radio_button_unchecked;
      case TaskStatus.inProgress:
        return Icons.pending;
      case TaskStatus.blocked:
        return Icons.block;
      case TaskStatus.cancelled:
        return Icons.cancel_outlined;
      case TaskStatus.done:
        return Icons.check_circle;
    }
  }

  // ---------------------------------------------------------------------------
  // Priority mapping
  // ---------------------------------------------------------------------------

  static String _mapPriorityLabel(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return 'Low';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.high:
        return 'High';
      case TaskPriority.critical:
        return 'Critical';
    }
  }

  static Color _mapPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return Colors.green;
      case TaskPriority.medium:
        return Colors.yellow.shade700;
      case TaskPriority.high:
        return Colors.orange;
      case TaskPriority.critical:
        return Colors.red;
    }
  }

  static IconData _mapPriorityIcon(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return Icons.flag_outlined;
      case TaskPriority.medium:
        return Icons.flag;
      case TaskPriority.high:
        return Icons.flag;
      case TaskPriority.critical:
        return Icons.flag;
    }
  }
}