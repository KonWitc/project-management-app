import 'package:flutter/material.dart';

class ProjectDetailsHeaderModel {
  final String name;
  final String? description;

  final String statusLabel;
  final Color statusColor;

  final String category;

  final List<String> tags;

  const ProjectDetailsHeaderModel({
    required this.name,
    this.description,
    required this.statusLabel,
    required this.statusColor,
    required this.category,
    required this.tags,
  });
}
