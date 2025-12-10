import 'package:app/features/projects/domain/models/project_enums.dart';

class Milestone {
  final String id;
  final String name;
  final String? description;
  final MilestoneStatus status;
  final DateTime? dueDate;
  final int progress; // 0–100%

  const Milestone({
    required this.id,
    required this.name,
    this.description,
    required this.status,
    this.dueDate,
    required this.progress,
  });

  bool get isDone => status == MilestoneStatus.completed;
  bool get isOverdue =>
      !isDone && dueDate != null && dueDate!.isBefore(DateTime.now());
}
