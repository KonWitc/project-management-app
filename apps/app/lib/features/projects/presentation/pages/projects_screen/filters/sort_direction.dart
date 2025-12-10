import 'package:app/features/projects/domain/models/project_enums.dart';
import 'package:flutter/material.dart';

class ProjectSortDirection extends StatelessWidget {
  final SortDir selectedSortDir;
  final ValueChanged<SortDir> onChanged;
  const ProjectSortDirection({
    super.key,
    required this.selectedSortDir,
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
        for (final sortDir in SortDir.values)
          MenuItemButton(
            closeOnActivate: true,
            onPressed: () => onChanged(sortDir),
            child: Row(
              children: [
                Expanded(child: Text(sortDir.label)),
                if (selectedSortDir == sortDir)
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
          child: Icon(
            selectedSortDir == SortDir.asc
                ? Icons.arrow_upward
                : Icons.arrow_downward,
            size: 14,
          ),
        ),
        side: BorderSide(color: cs.outline),
      ),
    );
  }
}
