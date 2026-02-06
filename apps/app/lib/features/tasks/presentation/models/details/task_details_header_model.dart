import 'package:flutter/material.dart';

class TaskDetailsHeaderModel {
  final String title;
  final String? description;
  final String statusLabel;
  final Color statusColor;
  final IconData statusIcon;
  final String priorityLabel;
  final Color priorityColor;
  final IconData priorityIcon;
  final String? taskType;
  final List<String> tags;
  final bool isOverdue;
  final bool isDone;

  const TaskDetailsHeaderModel({
    required this.title,
    this.description,
    required this.statusLabel,
    required this.statusColor,
    required this.statusIcon,
    required this.priorityLabel,
    required this.priorityColor,
    required this.priorityIcon,
    this.taskType,
    required this.tags,
    required this.isOverdue,
    required this.isDone,
  });
}
