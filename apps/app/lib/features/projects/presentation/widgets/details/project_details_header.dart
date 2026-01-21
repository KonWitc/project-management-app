import 'package:app/features/projects/presentation/models/details/project_details_header_model.dart';
import 'package:flutter/material.dart';

class ProjectDetailsHeader extends StatelessWidget {
  const ProjectDetailsHeader({
    super.key,
    required this.model,
    this.onBack,
    this.onEdit,
    this.onMore,
  });

  final ProjectDetailsHeaderModel model;
  final VoidCallback? onBack;
  final VoidCallback? onEdit;
  final VoidCallback? onMore;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return SliverToBoxAdapter(
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: LayoutBuilder(
            builder: (context, c) {
              final isWide = c.maxWidth >= 760;
      
              final titleBlock = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(model.name, style: theme.textTheme.headlineSmall),
                  if (model.description?.trim().isNotEmpty == true) ...[
                    const SizedBox(height: 6),
                    Text(
                      model.description!,
                      maxLines: isWide ? 2 : 3,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _StatusChip(
                        label: model.statusLabel,
                        color: model.statusColor,
                      ),
                      _MetaPill(
                        icon: Icons.category_outlined,
                        label: model.category,
                      ),
                    ],
                  ),
                  if (model.tags.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ...model.tags
                            .take(isWide ? 10 : 5)
                            .map((t) => _TagChip(label: t)),
                        if (!isWide && model.tags.length > 5)
                          _TagChip(label: '+${model.tags.length - 5}'),
                      ],
                    ),
                  ],
                ],
              );
      
              final actionsBlock = Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: isWide ? WrapAlignment.end : WrapAlignment.start,
                children: [
                  if (onEdit != null)
                    FilledButton.icon(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit_rounded),
                      label: const Text('Edit'),
                    ),
                  if (onMore != null)
                    IconButton(
                      onPressed: onMore,
                      icon: const Icon(Icons.more_horiz_rounded),
                      tooltip: 'More',
                    ),
                ],
              );
      
              final topRowMobile = Row(
                children: [
                  if (onBack != null)
                    IconButton(
                      onPressed: onBack,
                      icon: const Icon(Icons.arrow_back_rounded),
                      tooltip: 'Back',
                    ),
                  const Spacer(),
                  if (onMore != null)
                    IconButton(
                      onPressed: onMore,
                      icon: const Icon(Icons.more_horiz_rounded),
                      tooltip: 'More',
                    ),
                ],
              );
      
              if (!isWide) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (onBack != null || onMore != null) topRowMobile,
                    titleBlock,
                    const SizedBox(height: 12),
                    actionsBlock,
                  ],
                );
              }
      
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: titleBlock),
                  const SizedBox(width: 16),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 320),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: actionsBlock,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(Icons.circle, size: 12, color: color),
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

class _TagChip extends StatelessWidget {
  const _TagChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return InputChip(
      label: Text(label),
      onPressed: null, // ewentualnie: klik -> filtr / lista zadań
    );
  }
}

class _MetaPill extends StatelessWidget {
  const _MetaPill({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: cs.surfaceContainerHighest,
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: cs.onSurfaceVariant),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(color: cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
