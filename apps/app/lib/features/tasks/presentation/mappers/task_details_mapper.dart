import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:app/features/tasks/domain/models/task.dart';
import 'package:app/features/tasks/domain/models/task_enums.dart';
import 'package:app/features/tasks/presentation/models/details/task_details_context_model.dart';
import 'package:app/features/tasks/presentation/models/details/task_details_header_model.dart';
import 'package:app/features/tasks/presentation/models/details/task_details_time_tracking_model.dart';
import 'package:app/features/tasks/presentation/models/details/task_details_timeline_model.dart';
import 'package:app/features/tasks/presentation/models/details/task_details_ui_model.dart';

class TaskDetailsMapper {
  static TaskDetailsUiModel mapDomainToPresentation(
    Task task, {
    String? projectName,
    String? milestoneName,
    String? assigneeName,
    String? reporterName,
  }) {
    return TaskDetailsUiModel(
      taskId: task.id,
      projectId: task.projectId.isEmpty ? null : task.projectId,
      header: _mapHeader(task),
      timeline: _mapTimeline(task),
      timeTracking: _mapTimeTracking(task),
      context: _mapContext(
        task,
        projectName: projectName,
        milestoneName: milestoneName,
        assigneeName: assigneeName,
        reporterName: reporterName,
      ),
    );
  }

  static TaskDetailsHeaderModel _mapHeader(Task task) {
    return TaskDetailsHeaderModel(
      title: task.title,
      description: task.description,
      statusLabel: _mapStatusLabel(task.status),
      statusColor: _mapStatusColor(task.status, task.isOverdue),
      statusIcon: _mapStatusIcon(task.status),
      priorityLabel: _mapPriorityLabel(task.priority),
      priorityColor: _mapPriorityColor(task.priority),
      priorityIcon: _mapPriorityIcon(task.priority),
      taskType: task.taskType,
      tags: task.tags,
      isOverdue: task.isOverdue,
      isDone: task.isDone,
    );
  }

  static TaskDetailsTimelineModel _mapTimeline(Task task) {
    return TaskDetailsTimelineModel(
      startDateLabel: _formatDate(task.startDate),
      dueDateLabel: _formatDate(task.dueDate),
      completedAtLabel: _formatDate(task.completedAt),
      isOverdue: task.isOverdue,
    );
  }

  static TaskDetailsTimeTrackingModel _mapTimeTracking(Task task) {
    final hasTimeData = task.estimateHours != null || task.loggedHours != null;
    return TaskDetailsTimeTrackingModel(
      estimateHoursLabel: _formatHours(task.estimateHours),
      loggedHoursLabel: _formatHours(task.loggedHours),
      progressPercentage: _calculateProgress(task.estimateHours, task.loggedHours),
      hasTimeData: hasTimeData,
    );
  }

  static TaskDetailsContextModel _mapContext(
    Task task, {
    String? projectName,
    String? milestoneName,
    String? assigneeName,
    String? reporterName,
  }) {
    final hasProject = task.projectId.isNotEmpty;
    return TaskDetailsContextModel(
      projectId: hasProject ? task.projectId : null,
      projectName: projectName,
      milestoneId: task.milestoneId?.isNotEmpty == true ? task.milestoneId : null,
      milestoneName: milestoneName,
      assigneeId: task.assigneeId?.isNotEmpty == true ? task.assigneeId : null,
      assigneeName: assigneeName,
      reporterId: task.reporterId?.isNotEmpty == true ? task.reporterId : null,
      reporterName: reporterName,
      hasProject: hasProject,
    );
  }

  // ---------------------------------------------------------------------------
  // Date formatting
  // ---------------------------------------------------------------------------

  static String? _formatDate(DateTime? date) {
    if (date == null) return null;
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
