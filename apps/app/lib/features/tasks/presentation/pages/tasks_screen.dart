import 'package:app/core/widgets/app_scaffold.dart';
import 'package:app/features/tasks/presentation/providers/tasks_filters_provider.dart';
import 'package:app/features/tasks/presentation/providers/tasks_provider.dart';
import 'package:app/features/tasks/presentation/widgets/create_task_dialog.dart';
import 'package:app/features/tasks/presentation/widgets/filters/task_filters_row.dart';
import 'package:app/features/tasks/presentation/widgets/task_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TasksScreen extends ConsumerStatefulWidget {
  final String? projectId;
  final String? milestoneId;

  const TasksScreen({super.key, this.projectId, this.milestoneId});
  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize filters with projectId and milestoneId if provided
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final filtersNotifier = ref.read(taskFiltersProvider.notifier);
      if (widget.projectId != null) {
        filtersNotifier.setProjectId(widget.projectId);
      }
      if (widget.milestoneId != null) {
        filtersNotifier.setMilestoneId(widget.milestoneId);
      }
    });
  }

  void _showCreateTaskDialog() {
    final filters = ref.read(taskFiltersProvider);
    showDialog(
      context: context,
      builder: (context) => CreateTaskDialog(
        projectId: widget.projectId ?? filters.projectId ?? '',
        milestoneId: widget.milestoneId ?? filters.milestoneId,
        onTaskCreated: () {
          // Refresh the tasks list
          ref.invalidate(tasksListProvider);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateTaskDialog,
        icon: const Icon(Icons.add),
        label: const Text('New Task'),
      ),
      body: Column(
        children: [
          const TaskFiltersRow(),
          Expanded(
            child: TasksList(
              projectId: widget.projectId,
              onRefresh: () async {
                ref.invalidate(tasksListProvider);
                // Wait for the provider to complete
                await ref.read(tasksListProvider.future);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TasksList extends ConsumerWidget {
  final String? projectId;
  final Future<void> Function()? onRefresh;

  const TasksList({super.key, this.projectId, this.onRefresh});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncTasks = ref.watch(tasksListProvider);

    return asyncTasks.when(
      loading: () => const _LoadingState(),
      error: (error, stack) => _ErrorState(
        error: error,
        onRetry: () => ref.invalidate(tasksListProvider),
      ),
      data: (page) {
        if (page.items.isEmpty) {
          return _EmptyState(
            onCreateTask: () => _showCreateTaskDialog(context, ref, projectId),
          );
        }

        final listView = ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: page.items.length,
          itemBuilder: (BuildContext context, int index) {
            final task = page.items[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: TaskCard(
                task: task,
                onTap: () => _onTaskTap(context, ref, task.id),
              ),
            );
          },
        );

        if (onRefresh != null) {
          return RefreshIndicator(onRefresh: onRefresh!, child: listView);
        }

        return listView;
      },
    );
  }
}

void _onTaskTap(BuildContext context, WidgetRef ref, String taskId) {
  context.push('/tasks/$taskId');
}

void _showCreateTaskDialog(
  BuildContext context,
  WidgetRef ref,
  String? projectId,
) {
  final filters = ref.read(taskFiltersProvider);
  showDialog(
    context: context,
    builder: (ctx) => CreateTaskDialog(
      projectId: projectId ?? filters.projectId ?? '',
      milestoneId: filters.milestoneId,
      onTaskCreated: () {
        ref.invalidate(tasksListProvider);
      },
    ),
  );
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading tasks...'),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;

  const _ErrorState({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: cs.error),
            const SizedBox(height: 16),
            Text('Something went wrong', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onCreateTask;

  const _EmptyState({required this.onCreateTask});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.task_outlined,
              size: 80,
              color: cs.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 24),
            Text('No tasks found', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'Create your first task to get started\nor adjust your filters',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onCreateTask,
              icon: const Icon(Icons.add),
              label: const Text('Create Task'),
            ),
          ],
        ),
      ),
    );
  }
}
