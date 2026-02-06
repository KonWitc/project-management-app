import 'package:app/features/my_work/presentation/models/project_task_group.dart';
import 'package:app/features/my_work/presentation/providers/my_projects_provider.dart';
import 'package:app/features/my_work/presentation/providers/my_tasks_provider.dart';
import 'package:app/features/tasks/presentation/models/task_card_model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final tasksGroupedByProjectProvider =
    FutureProvider.family<List<ProjectTaskGroup>, ColorScheme>((
  ref,
  colorScheme,
) async {
  final asyncTasks = await ref.watch(myTasksProvider.future);
  final tasks = asyncTasks.items;

  // Group tasks by projectId
  final Map<String, List<TaskCardModel>> groupedMap = {};
  final List<TaskCardModel> orphanedTasks = [];

  for (final task in tasks) {
    if (task.projectId.isEmpty) {
      orphanedTasks.add(task);
    } else {
      groupedMap.putIfAbsent(task.projectId, () => []).add(task);
    }
  }

  final groups = <ProjectTaskGroup>[];

  // Add orphaned tasks group first if any
  if (orphanedTasks.isNotEmpty) {
    groups.add(ProjectTaskGroup(
      projectId: null,
      projectName: 'No Project',
      tasks: orphanedTasks,
    ));
  }

  // Fetch projects to get names
  final asyncProjects = await ref.watch(myProjectsProvider(colorScheme).future);
  final projectsMap = {
    for (var p in asyncProjects.items) p.id: p.name,
  };

  // Add grouped tasks with project names
  for (final entry in groupedMap.entries) {
    final projectId = entry.key;
    final projectTasks = entry.value;
    final projectName = projectsMap[projectId] ?? 'Project $projectId';

    groups.add(ProjectTaskGroup(
      projectId: projectId,
      projectName: projectName,
      tasks: projectTasks,
    ));
  }

  return groups;
});
