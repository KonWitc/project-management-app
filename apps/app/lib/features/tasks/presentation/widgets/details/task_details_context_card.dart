import 'package:app/features/tasks/presentation/models/details/task_details_context_model.dart';
import 'package:flutter/material.dart';

class TaskDetailsContextCard extends StatelessWidget {
  final TaskDetailsContextModel model;
  final VoidCallback? onProjectTap;

  const TaskDetailsContextCard({
    super.key,
    required this.model,
    this.onProjectTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.link, size: 20, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Context',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (model.hasProject) ...[
              _ContextRow(
                icon: Icons.folder_outlined,
                label: 'Project',
                value: model.projectName ?? 'Unknown',
                onTap: onProjectTap,
                colorScheme: colorScheme,
              ),
            ] else ...[
              _NoProjectIndicator(colorScheme: colorScheme),
            ],
            if (model.milestoneName != null) ...[
              const SizedBox(height: 12),
              _ContextRow(
                icon: Icons.flag_outlined,
                label: 'Milestone',
                value: model.milestoneName!,
                colorScheme: colorScheme,
              ),
            ],
            if (model.assigneeName != null) ...[
              const SizedBox(height: 12),
              _ContextRow(
                icon: Icons.person_outline,
                label: 'Assignee',
                value: model.assigneeName!,
                colorScheme: colorScheme,
              ),
            ],
            if (model.reporterName != null) ...[
              const SizedBox(height: 12),
              _ContextRow(
                icon: Icons.person_add_outlined,
                label: 'Reporter',
                value: model.reporterName!,
                colorScheme: colorScheme,
              ),
            ],
            if (!model.hasProject &&
                model.milestoneName == null &&
                model.assigneeName == null &&
                model.reporterName == null) ...[
              const SizedBox(height: 8),
              Text(
                'This task is not linked to any project or team member.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ContextRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;
  final ColorScheme colorScheme;

  const _ContextRow({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isClickable = onTap != null;

    final content = Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: colorScheme.onSurfaceVariant),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isClickable
                      ? colorScheme.primary
                      : colorScheme.onSurface,
                  fontWeight: isClickable ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
        if (isClickable)
          Icon(
            Icons.chevron_right,
            size: 20,
            color: colorScheme.onSurfaceVariant,
          ),
      ],
    );

    if (isClickable) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: content,
        ),
      );
    }

    return content;
  }
}

class _NoProjectIndicator extends StatelessWidget {
  final ColorScheme colorScheme;

  const _NoProjectIndicator({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.folder_off_outlined, size: 20, color: Colors.orange),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'No project assigned',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.orange.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
