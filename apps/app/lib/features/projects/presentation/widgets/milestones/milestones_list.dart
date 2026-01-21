import 'package:app/features/projects/domain/models/milestone.dart';
import 'package:app/features/projects/presentation/widgets/milestones/milestone_card.dart';
import 'package:flutter/material.dart';

class MilestonesList extends StatelessWidget {
  final List<Milestone> milestones;
  final bool isLoading;
  final VoidCallback? onRefresh;
  final void Function(Milestone)? onMilestoneTap;

  const MilestonesList({
    super.key,
    required this.milestones,
    this.isLoading = false,
    this.onRefresh,
    this.onMilestoneTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (milestones.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.flag_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No milestones yet',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create a milestone to track major goals',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        onRefresh?.call();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: milestones.length,
        itemBuilder: (context, index) {
          final milestone = milestones[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: MilestoneCard(
              milestone: milestone,
              onTap: onMilestoneTap != null
                  ? () => onMilestoneTap!(milestone)
                  : null,
            ),
          );
        },
      ),
    );
  }
}