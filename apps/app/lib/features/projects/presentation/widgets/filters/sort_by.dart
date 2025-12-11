import 'package:app/features/projects/domain/models/project_enums.dart';
import 'package:app/features/projects/presentation/widgets/filters/filter_chip.dart';
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

      child: ProjectsFilterChip(
        label: Text(
          'Sort: ${selectedSortBy.label}',
          style: theme.textTheme.labelMedium?.copyWith(color: cs.onSurface),
        ),
        onTap: () {
          if (menuController.isOpen) {
            menuController.close();
          } else {
            menuController.open();
          }
        },
      ),
    );
  }
}
