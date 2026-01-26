import 'package:app/features/tasks/presentation/models/task_card_model.dart';
import 'package:app/features/tasks/presentation/providers/project_tasks_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProjectTasksState {
  final List<TaskCardModel> tasks;
  final bool isLoading;
  final String? error;

  const ProjectTasksState({
    this.tasks = const [],
    this.isLoading = false,
    this.error,
  });

  ProjectTasksState copyWith({
    List<TaskCardModel>? tasks,
    bool? isLoading,
    String? error,
  }) {
    return ProjectTasksState(
      tasks: tasks ?? this.tasks,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// Provider that exposes project tasks state
final projectTasksStateProvider =
    Provider.family<ProjectTasksState, String>((ref, projectId) {
  final asyncTasks = ref.watch(projectTasksProvider(projectId));

  return asyncTasks.when(
    data: (result) => ProjectTasksState(
      tasks: result.items,
      isLoading: false,
    ),
    loading: () => const ProjectTasksState(isLoading: true),
    error: (error, _) =>
        ProjectTasksState(error: error.toString(), isLoading: false),
  );
});
