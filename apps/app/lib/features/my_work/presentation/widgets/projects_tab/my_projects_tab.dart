import 'package:app/core/routing/navigation_service_provider.dart';
import 'package:app/features/my_work/presentation/providers/my_projects_provider.dart';
import 'package:app/features/my_work/presentation/widgets/summary/project_summary_card.dart';
import 'package:app/features/projects/presentation/widgets/card/project_card.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MyProjectsTab extends ConsumerWidget {
  const MyProjectsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final asyncProjects = ref.watch(myProjectsProvider(colorScheme));

    return asyncProjects.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error loading projects: $error'),
          ],
        ),
      ),
      data: (result) {
        if (result.items.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.dashboard,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No projects assigned to you',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
          );
        }

        return CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: ProjectSummaryCard(),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 4 / 3,
                  maxCrossAxisExtent: 400,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final project = result.items[index];
                    return ProjectCard(
                      project: project,
                      onTap: () {
                        final navigationService =
                            ref.read(navigationServiceProvider);
                        navigationService.goToProjectDetails(project.id);
                      },
                    );
                  },
                  childCount: result.items.length,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
