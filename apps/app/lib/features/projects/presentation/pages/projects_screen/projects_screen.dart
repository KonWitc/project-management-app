import 'package:app/core/widgets/app_scaffold.dart';
import 'package:app/features/projects/presentation/pages/projects_screen/project_card.dart';
import 'package:app/features/projects/presentation/pages/projects_screen/filters/project_filters_row.dart';
import 'package:app/features/projects/presentation/providers/project_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      body: Column(
        children: [
          ProjectFiltersRow(),
          Expanded(child: ProjectsGrid()),
        ],
      ),
    );
  }
}

class ProjectsGrid extends ConsumerWidget {
  const ProjectsGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProjects = ref.watch(projectsListProvider);

    return asyncProjects.when(
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
      error: (error, stack) {
        return Center(child: Text('Error: $error'));
      },
      data: (page) {
        if (page.items.isEmpty) {
          return const Center(child: Text('No Projects Found'));
        }

        return GridView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 4 / 3,
            maxCrossAxisExtent: 400,
          ),
          itemCount: page.items.length,
          itemBuilder: (BuildContext context, int index) {
            final project = page.items[index];
            return ProjectCard(project: project);
          },
        );
      },
    );
  }
}
