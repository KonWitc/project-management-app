import 'package:app/features/comments/presentation/widgets/task_comments_card.dart';
import 'package:app/features/tasks/presentation/providers/task_details_provider.dart';
import 'package:app/features/tasks/presentation/widgets/details/task_details_context_card.dart';
import 'package:app/features/tasks/presentation/widgets/details/task_details_header.dart';
import 'package:app/features/tasks/presentation/widgets/details/task_details_time_tracking_card.dart';
import 'package:app/features/tasks/presentation/widgets/details/task_details_timeline_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TaskDetailsScreen extends ConsumerWidget {
  final String taskId;

  const TaskDetailsScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncDetails = ref.watch(taskDetailsProvider(taskId));

    return Scaffold(
      body: asyncDetails.when(
        loading: () => const _LoadingState(),
        error: (error, stack) => _ErrorState(
          error: error,
          onRetry: () => ref.invalidate(taskDetailsProvider(taskId)),
        ),
        data: (details) => CustomScrollView(
          slivers: [
            SliverAppBar.large(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
              title: Text(
                details.header.title,
                style: details.header.isDone
                    ? const TextStyle(decoration: TextDecoration.lineThrough)
                    : null,
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () {
                    // TODO: Navigate to edit task
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Edit task coming soon')),
                    );
                  },
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    // TODO: Handle menu actions
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('$value coming soon')),
                    );
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'duplicate',
                      child: ListTile(
                        leading: Icon(Icons.copy),
                        title: Text('Duplicate'),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: ListTile(
                        leading: Icon(Icons.delete_outline, color: Colors.red),
                        title: Text('Delete', style: TextStyle(color: Colors.red)),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverLayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.crossAxisExtent > 600;

                  if (isWide) {
                    return SliverGrid(
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 400,
                        childAspectRatio: 1.3,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      delegate: SliverChildListDelegate([
                        TaskDetailsHeader(model: details.header),
                        TaskDetailsTimelineCard(model: details.timeline),
                        TaskDetailsTimeTrackingCard(model: details.timeTracking),
                        TaskDetailsContextCard(
                          model: details.context,
                          onProjectTap: details.context.projectId != null
                              ? () => context.push('/projects/${details.context.projectId}')
                              : null,
                        ),
                      ]),
                    );
                  }

                  return SliverList(
                    delegate: SliverChildListDelegate([
                      TaskDetailsHeader(model: details.header),
                      const SizedBox(height: 16),
                      TaskDetailsTimelineCard(model: details.timeline),
                      const SizedBox(height: 16),
                      TaskDetailsTimeTrackingCard(model: details.timeTracking),
                      const SizedBox(height: 16),
                      TaskDetailsContextCard(
                        model: details.context,
                        onProjectTap: details.context.projectId != null
                            ? () => context.push('/projects/${details.context.projectId}')
                            : null,
                      ),
                    ]),
                  );
                },
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              sliver: SliverToBoxAdapter(
                child: TaskCommentsCard(taskId: taskId),
              ),
            ),
          ],
        ),
      ),
    );
  }
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
          Text('Loading task details...'),
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
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: colorScheme.error),
            const SizedBox(height: 16),
            Text('Failed to load task', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Go Back'),
                ),
                const SizedBox(width: 12),
                FilledButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
