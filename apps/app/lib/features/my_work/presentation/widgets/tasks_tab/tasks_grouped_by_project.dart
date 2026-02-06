import 'package:app/features/my_work/presentation/models/project_task_group.dart';
import 'package:app/features/my_work/presentation/widgets/tasks_tab/project_group_card.dart';
import 'package:flutter/material.dart';

class TasksGroupedByProject extends StatelessWidget {
  final List<ProjectTaskGroup> groups;
  final void Function(String taskId, String? projectId)? onTaskTap;

  const TasksGroupedByProject({
    super.key,
    required this.groups,
    this.onTaskTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: groups.length,
      itemBuilder: (context, index) {
        return ProjectGroupCard(
          group: groups[index],
          onTaskTap: onTaskTap,
        );
      },
    );
  }
}
