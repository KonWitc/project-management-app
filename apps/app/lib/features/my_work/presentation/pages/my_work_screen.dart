import 'package:app/core/widgets/app_scaffold.dart';
import 'package:app/features/my_work/presentation/widgets/projects_tab/my_projects_tab.dart';
import 'package:app/features/my_work/presentation/widgets/tasks_tab/my_tasks_tab.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MyWorkScreen extends ConsumerStatefulWidget {
  const MyWorkScreen({super.key});

  @override
  ConsumerState<MyWorkScreen> createState() => _MyWorkScreenState();
}

class _MyWorkScreenState extends ConsumerState<MyWorkScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppScaffold(
      body: Column(
        children: [
          Container(
            color: theme.colorScheme.surface,
            child: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(
                  text: 'My Tasks',
                  icon: Icon(Icons.task_alt),
                ),
                Tab(
                  text: 'My Projects',
                  icon: Icon(Icons.dashboard),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                MyTasksTab(),
                MyProjectsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
