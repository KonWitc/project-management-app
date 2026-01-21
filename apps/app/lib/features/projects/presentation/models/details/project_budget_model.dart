import 'package:flutter/material.dart';

class ProjectBudgetModel {
  final String? budgetLabel;
  final String? actualCostLabel;
  final String? revenueEstimateLabel;

  final double? costDifference;
  final String? costDifferenceLabel;
  final Color? costDifferenceColor;
  final IconData costDifferenceIcon;

  const ProjectBudgetModel({
    this.budgetLabel,
    this.actualCostLabel,
    this.revenueEstimateLabel,
    this.costDifference,
    this.costDifferenceLabel,
    this.costDifferenceColor,
    required this.costDifferenceIcon,
  });
}