import 'package:app/features/projects/domain/models/project_enums.dart';
import 'package:flutter/material.dart';

class ProjectSortBy extends StatelessWidget {
  final SortBy selectedSortBy;
  final ValueChanged<SortBy> onChanged;
  const ProjectSortBy({
    super.key,
    required this.selectedSortBy,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final menuController = MenuController();
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return MenuAnchor(
      controller: menuController,
      menuChildren: [
        for (final sort in SortBy.values)
          MenuItemButton(
            closeOnActivate: true,
            onPressed: () => onChanged(sort),
            child: Row(
              children: [
                Expanded(child: Text(sort.label)),
                if (selectedSortBy == sort)
                  const Icon(Icons.check)
                else
                  const SizedBox(width: 24),
              ],
            ),
          ),
      ],
      child: Chip(
        label: InkWell(
          onTap: () {
            if (menuController.isOpen) {
              menuController.close();
            } else {
              menuController.open();
            }
          },
          child: Text(
            'Sort: ${selectedSortBy.label}',
            style: theme.textTheme.labelMedium?.copyWith(color: cs.onSurface),
          ),
        ),
        side: BorderSide(color: cs.outline),
      ),
    );
  }
}
