import 'package:app/core/widgets/app_scaffold.dart';
import 'package:app/features/tasks/presentation/providers/tasks_provider.dart';
import 'package:app/features/tasks/presentation/widgets/task_card.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TasksScreen extends StatelessWidget {
  final String? projectId;
  final String? milestoneId;

  const TasksScreen({
    super.key,
    this.projectId,
    this.milestoneId,
  });

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      body: Column(
        children: [
          Expanded(child: TasksList()),
        ],
      ),
    );
  }
}

class TasksList extends ConsumerWidget {
  const TasksList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncTasks = ref.watch(tasksListProvider);

    return asyncTasks.when(
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
      error: (error, stack) {
        return Center(child: Text('Error: $error'));
      },
      data: (page) {
        if (page.items.isEmpty) {
          return const Center(child: Text('No Tasks Found'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: page.items.length,
          itemBuilder: (BuildContext context, int index) {
            final task = page.items[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: TaskCard(task: task),
            );
          },
        );
      },
    );
  }
}