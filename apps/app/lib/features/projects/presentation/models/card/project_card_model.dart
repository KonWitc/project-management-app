import 'package:flutter/material.dart';

class ProjectCardModel {
  final String id;
  final String name;
  final String? description;

  final String statusLabel;
  final Color statusColor;

  final String? startDateLabel;
  final String? endDateLabel;
  final String? deadlineLabel;
  final bool isOverdue;

  final String? revenueEstimateLabel;
  final double? costDifference;
  final Color? costDifferenceColor;
  final IconData costDifferenceIcon;

  final List<String> tags;
  final String category;

  const ProjectCardModel({
    required this.id,
    required this.name,
    this.description,
    required this.statusLabel,
    required this.statusColor,
    this.startDateLabel,
    this.endDateLabel,
    this.deadlineLabel,
    required this.isOverdue,
    this.revenueEstimateLabel,
    this.costDifference,
    this.costDifferenceColor,
    required this.costDifferenceIcon,
    required this.tags,
    required this.category,
  });
}
