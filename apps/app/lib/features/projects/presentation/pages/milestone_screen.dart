import 'package:app/features/projects/domain/models/project_enums.dart';
import 'package:app/features/projects/presentation/providers/milestones_provider.dart';
import 'package:app/features/projects/presentation/widgets/milestones/create_milestone_dialog.dart';
import 'package:app/features/projects/presentation/widgets/milestones/milestones_list.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MilestonesPage extends ConsumerStatefulWidget {
  final String projectId;

  const MilestonesPage({super.key, required this.projectId});

  @override
  ConsumerState<MilestonesPage> createState() => _MilestonesPageState();
}

class _MilestonesPageState extends ConsumerState<MilestonesPage> {
  MilestoneStatus? _selectedFilter;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(milestonesProvider(widget.projectId).notifier).loadMilestones();
    });
  }

  void _showCreateMilestoneDialog() {
    showDialog(
      context: context,
      builder: (context) => CreateMilestoneDialog(
        projectId: widget.projectId,
        onCreateMilestone:
            ({
              required String projectId,
              required String name,
              String? description,
              String? status,
              DateTime? dueDate,
            }) async {
              await ref
                  .read(milestonesProvider(widget.projectId).notifier)
                  .createMilestone(
                    name: name,
                    description: description,
                    status: status,
                    dueDate: dueDate,
                  );
            },
      ),
    ).then((created) {
      if (created == true && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Milestone created successfully')),
        );
      }
    });
  }

  List<Widget> _buildFilterChips() {
    return [
      FilterChip(
        label: const Text('All'),
        selected: _selectedFilter == null,
        onSelected: (selected) {
          setState(() {
            _selectedFilter = null;
          });
        },
      ),
      FilterChip(
        label: const Text('Not Started'),
        selected: _selectedFilter == MilestoneStatus.notStarted,
        onSelected: (selected) {
          setState(() {
            _selectedFilter = selected ? MilestoneStatus.notStarted : null;
          });
        },
      ),
      FilterChip(
        label: const Text('In Progress'),
        selected: _selectedFilter == MilestoneStatus.inProgress,
        onSelected: (selected) {
          setState(() {
            _selectedFilter = selected ? MilestoneStatus.inProgress : null;
          });
        },
      ),
      FilterChip(
        label: const Text('Completed'),
        selected: _selectedFilter == MilestoneStatus.completed,
        selectedColor: Colors.green.withValues(alpha: 0.2),
        onSelected: (selected) {
          setState(() {
            _selectedFilter = selected ? MilestoneStatus.completed : null;
          });
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final milestonesState = ref.watch(milestonesProvider(widget.projectId));
    final filteredMilestones = _selectedFilter == null
        ? milestonesState.milestones
        : milestonesState.milestones
              .where((m) => m.status == _selectedFilter)
              .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Milestones')),
      body: Column(
        children: [
          // Filter chips
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _buildFilterChips()
                    .map(
                      (chip) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: chip,
                      ),
                    )
                    .toList(),
              ),
            ),
          ),

          // Milestones list
          Expanded(
            child: MilestonesList(
              milestones: filteredMilestones,
              isLoading: milestonesState.isLoading,
              onRefresh: () {
                ref
                    .read(milestonesProvider(widget.projectId).notifier)
                    .loadMilestones();
              },
              onMilestoneTap: (milestone) {
                // TODO: Navigate to milestone details or show edit dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Tapped: ${milestone.name}')),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateMilestoneDialog,
        icon: const Icon(Icons.add),
        label: const Text('New Milestone'),
      ),
    );
  }
}
