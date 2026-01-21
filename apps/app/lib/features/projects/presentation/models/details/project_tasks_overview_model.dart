class ProjectTasksOverviewModel {
  final int tasksCount;
  final int openTasksCount;
  final int completedTasksCount;
  final List<TaskOverviewModel> upcomingTasks;

  const ProjectTasksOverviewModel({
    required this.tasksCount,
    required this.openTasksCount,
    required this.completedTasksCount,
    required this.upcomingTasks,
  });
}

class TaskOverviewModel {
  final String title;
  final String? dueDateLabel;
  final String statusLabel;
  final String priorityLabel;
  final bool isOverdue;

  const TaskOverviewModel({
    required this.title,
    this.dueDateLabel,
    required this.statusLabel,
    required this.priorityLabel,
    required this.isOverdue,
  });
}
