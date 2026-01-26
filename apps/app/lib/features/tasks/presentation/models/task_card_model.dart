import 'package:flutter/material.dart';

class TaskCardModel {
  final String id;
  final String projectId;
  final String? milestoneId;

  final String title;
  final String? description;

  final String statusLabel;
  final Color statusColor;
  final IconData statusIcon;

  final String priorityLabel;
  final Color priorityColor;
  final IconData priorityIcon;

  final String? dueDateLabel;
  final bool isOverdue;
  final bool isDone;
  final bool isInProgress;

  final String? estimateHoursLabel;
  final String? loggedHoursLabel;
  final double? progressPercentage;

  final List<String> tags;
  final String? taskType;

  /// Convenience getter - same as isDone
  bool get isCompleted => isDone;

  const TaskCardModel({
    required this.id,
    required this.projectId,
    this.milestoneId,
    required this.title,
    this.description,
    required this.statusLabel,
    required this.statusColor,
    required this.statusIcon,
    required this.priorityLabel,
    required this.priorityColor,
    required this.priorityIcon,
    this.dueDateLabel,
    required this.isOverdue,
    required this.isDone,
    required this.isInProgress,
    this.estimateHoursLabel,
    this.loggedHoursLabel,
    this.progressPercentage,
    required this.tags,
    this.taskType,
  });
}