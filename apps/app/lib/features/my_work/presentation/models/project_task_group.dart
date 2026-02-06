import 'package:app/features/tasks/presentation/models/task_card_model.dart';

class ProjectTaskGroup {
  final String? projectId; // null for orphaned tasks
  final String projectName;
  final List<TaskCardModel> tasks;

  const ProjectTaskGroup({
    required this.projectId,
    required this.projectName,
    required this.tasks,
  });

  int get taskCount => tasks.length;

  int get completedCount => tasks.where((t) => t.isDone).length;

  int get overdueCount => tasks.where((t) => t.isOverdue).length;
}
