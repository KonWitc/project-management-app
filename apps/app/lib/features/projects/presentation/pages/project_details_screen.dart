import 'package:app/features/projects/presentation/providers/milestones_provider.dart';
import 'package:app/features/projects/presentation/widgets/milestones/milestone_summary_card.dart';
import 'package:app/features/tasks/presentation/providers/project_tasks_provider.dart';
import 'package:app/features/tasks/presentation/providers/project_tasks_state_provider.dart';
import 'package:app/features/tasks/presentation/widgets/summary/task_summary_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProjectDetailsScreen extends ConsumerStatefulWidget {
  final String projectId;
  const ProjectDetailsScreen({super.key, required this.projectId});

  @override
  ConsumerState<ProjectDetailsScreen> createState() =>
      _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends ConsumerState<ProjectDetailsScreen> {
  @override
  void initState() {
    super.initState();

    // Load milestones when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(milestonesProvider(widget.projectId).notifier).loadMilestones();
    });
  }

  void _navigateToMilestones() {
    context.push('/projects/${widget.projectId}/milestones');
  }

  void _navigateToTasks() {
    context.push('/projects/${widget.projectId}/tasks');
  }

  void _refreshTasks() {
    // Invalidate the provider to refresh tasks
    ref.invalidate(projectTasksProvider(widget.projectId));
  }

  @override
  Widget build(BuildContext context) {
    final milestonesState = ref.watch(milestonesProvider(widget.projectId));
    final tasksState = ref.watch(projectTasksStateProvider(widget.projectId));

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          const SliverAppBar.large(
            title: Text('Project Details'),
            floating: true,
            snap: true,
          ),

          // Overview Grid
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 500,
                childAspectRatio: 1.2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildListDelegate([
                // Project Info Card
                _ProjectInfoCard(projectId: widget.projectId),

                // Milestones Summary Card
                MilestoneSummaryCard(
                  milestones: milestonesState.milestones,
                  onViewAll: _navigateToMilestones,
                  isLoading: milestonesState.isLoading,
                ),

                // Tasks Summary Card
                TasksSummaryCard(
                  projectId: widget.projectId,
                  tasks: tasksState.tasks,
                  onViewAll: _navigateToTasks,
                  onRefresh: _refreshTasks,
                  isLoading: tasksState.isLoading,
                ),

                // Timeline Card (Placeholder)
                const _PlaceholderCard(
                  title: 'Timeline',
                  icon: Icons.timeline,
                  description: 'Coming soon...',
                  color: Colors.purple,
                ),

                // Team Card (Placeholder)
                const _PlaceholderCard(
                  title: 'Team',
                  icon: Icons.people_outline,
                  description: 'Coming soon...',
                  color: Colors.teal,
                ),

                // Files Card (Placeholder)
                const _PlaceholderCard(
                  title: 'Files',
                  icon: Icons.folder_outlined,
                  description: 'Coming soon...',
                  color: Colors.blueGrey,
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectInfoCard extends StatelessWidget {
  final String projectId;

  const _ProjectInfoCard({required this.projectId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, size: 24, color: cs.primary),
                const SizedBox(width: 12),
                Text(
                  'Project Info',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 48,
                      color: cs.onSurfaceVariant.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Project details',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Coming soon...',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaceholderCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String description;
  final Color color;

  const _PlaceholderCard({
    required this.title,
    required this.icon,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 24, color: color),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      size: 48,
                      color: cs.onSurfaceVariant.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
