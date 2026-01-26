import 'package:app/core/theme/app_theme.dart';
import 'package:app/features/projects/presentation/models/card/project_card_model.dart';
import 'package:flutter/material.dart';

class ProjectCard extends StatelessWidget {
  final ProjectCardModel project;
  final VoidCallback onTap;
  const ProjectCard({super.key, required this.project, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: project.isOverdue ? cs.racingRed : cs.outline),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        splashFactory: InkRipple.splashFactory,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ───────────────── Header: title + status chip ─────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      project.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _StatusChip(
                    label: project.statusLabel,
                    color: project.statusColor,
                  ),
                ],
              ),

              if (project.category.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  project.category,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: cs.secondary,
                  ),
                ),
              ],

              // ───────────────── Description  ─────────────────
              if (project.description != null &&
                  project.description!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  project.description!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant,
                    height: 1.25,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              const SizedBox(height: 12),

              // ───────────────── Dates Row ─────────────────
              _InfoRow(
                leftLabel: "Start",
                leftValue: project.startDateLabel,
                rightLabel: "End",
                rightValue: project.endDateLabel,
              ),

              if (project.deadlineLabel != null) ...[
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      "Deadline: ${project.deadlineLabel!}",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: project.isOverdue
                            ? cs.error
                            : cs.onSurfaceVariant,
                        fontWeight: project.isOverdue
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 12),

              // ───────────────── Budget / Revenue Row ─────────────────
              Row(
                children: [
                  if (project.revenueEstimateLabel != null)
                    Expanded(
                      child: _LabeledValue(
                        label: "Revenue",
                        value: project.revenueEstimateLabel!,
                        valueColor: cs.onSurface,
                      ),
                    ),
                  if (project.costDifference != null)
                    Expanded(
                      child: _LabeledIconValue(
                        label: "Budget Diff",
                        value:
                            "+€${project.costDifference!.toStringAsFixed(0)}",
                        icon: project.costDifferenceIcon,
                        color:
                            project.costDifferenceColor ?? cs.onSurfaceVariant,
                      ),
                    ),
                ],
              ),

              // ───────────────── Tags Row ─────────────────
              if (project.tags.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: -6,
                  children: project.tags.take(4).map((tag) {
                    return Chip(
                      label: Text(tag),
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      labelStyle: theme.textTheme.labelSmall,
                      side: BorderSide(color: cs.outlineVariant),
                      backgroundColor: cs.surfaceContainerHighest,
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

//
// ─────────────────── UI HELPER WIDGETS ───────────────────
//

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: color,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6),
      side: BorderSide(color: color),
      backgroundColor: color.withValues(alpha: 0.08),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String leftLabel;
  final String? leftValue;
  final String rightLabel;
  final String? rightValue;

  const _InfoRow({
    required this.leftLabel,
    required this.leftValue,
    required this.rightLabel,
    required this.rightValue,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Row(
      children: [
        Expanded(
          child: _LabeledValue(
            label: leftLabel,
            value: leftValue ?? "-",
            valueColor: cs.onSurfaceVariant,
          ),
        ),
        Expanded(
          child: _LabeledValue(
            label: rightLabel,
            value: rightValue ?? "-",
            valueColor: cs.onSurfaceVariant,
            alignRight: true,
          ),
        ),
      ],
    );
  }
}

class _LabeledValue extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  final bool alignRight;

  const _LabeledValue({
    required this.label,
    required this.value,
    required this.valueColor,
    this.alignRight = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: alignRight
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: theme.textTheme.bodySmall?.copyWith(
            color: valueColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _LabeledIconValue extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _LabeledIconValue({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: cs.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              value,
              style: theme.textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
