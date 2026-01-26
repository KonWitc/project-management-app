import 'package:app/features/projects/domain/models/milestone.dart';
import 'package:app/features/projects/domain/models/project_enums.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MilestoneSummaryCard extends StatelessWidget {
  final List<Milestone> milestones;
  final VoidCallback onViewAll;
  final bool isLoading;

  const MilestoneSummaryCard({
    super.key,
    required this.milestones,
    required this.onViewAll,
    this.isLoading = false,
  });

  int _countByStatus(MilestoneStatus status) {
    return milestones.where((m) => m.status == status).length;
  }

  Milestone? _getNextUpcoming() {
    final upcoming = milestones
        .where((m) =>
            m.status != MilestoneStatus.completed &&
            m.status != MilestoneStatus.cancelled &&
            m.dueDate != null)
        .toList()
      ..sort((a, b) => a.dueDate!.compareTo(b.dueDate!));

    return upcoming.isNotEmpty ? upcoming.first : null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    if (isLoading) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.flag, size: 24, color: cs.primary),
                  const SizedBox(width: 12),
                  Text(
                    'Milestones',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Center(
                child: CircularProgressIndicator(),
              ),
            ],
          ),
        ),
      );
    }

    final total = milestones.length;
    final inProgress = _countByStatus(MilestoneStatus.inProgress);
    final completed = _countByStatus(MilestoneStatus.completed);
    final notStarted = _countByStatus(MilestoneStatus.notStarted);
    final nextMilestone = _getNextUpcoming();

    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onViewAll,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.flag, size: 24, color: cs.primary),
                      const SizedBox(width: 12),
                      Text(
                        'Milestones',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: cs.onSurfaceVariant,
                  ),
                ],
              ),

              if (milestones.isEmpty) ...[
                const SizedBox(height: 16),
                Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.flag_outlined,
                        size: 48,
                        color: cs.onSurfaceVariant.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'No milestones yet',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                const SizedBox(height: 20),

                // Stats Row
                Row(
                  children: [
                    Expanded(
                      child: _StatItem(
                        label: 'Total',
                        value: total.toString(),
                        color: cs.primary,
                      ),
                    ),
                    Expanded(
                      child: _StatItem(
                        label: 'Active',
                        value: inProgress.toString(),
                        color: Colors.blue,
                      ),
                    ),
                    Expanded(
                      child: _StatItem(
                        label: 'Done',
                        value: completed.toString(),
                        color: Colors.green,
                      ),
                    ),
                    Expanded(
                      child: _StatItem(
                        label: 'Todo',
                        value: notStarted.toString(),
                        color: cs.outline,
                      ),
                    ),
                  ],
                ),

                // Next Upcoming Milestone
                if (nextMilestone != null) ...[
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: nextMilestone.isOverdue
                            ? cs.error.withValues(alpha: 0.3)
                            : cs.outlineVariant,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.schedule,
                              size: 14,
                              color: cs.onSurfaceVariant,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Next Due',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: cs.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          nextMilestone.name,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              DateFormat('MMM d, y')
                                  .format(nextMilestone.dueDate!),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: nextMilestone.isOverdue
                                    ? cs.error
                                    : cs.onSurfaceVariant,
                                fontWeight: nextMilestone.isOverdue
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                            Text(
                              '${nextMilestone.progress}%',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: cs.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: LinearProgressIndicator(
                            value: nextMilestone.progress / 100,
                            minHeight: 4,
                            backgroundColor:
                                cs.surfaceContainerHighest.withValues(alpha: 0.5),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              nextMilestone.isOverdue ? cs.error : Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}