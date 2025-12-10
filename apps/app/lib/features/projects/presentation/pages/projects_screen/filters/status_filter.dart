import 'package:app/features/projects/domain/models/project_enums.dart';
import 'package:flutter/material.dart';

class StatusFilter extends StatelessWidget {
  final Set<ProjectStatus> selected;
  final ValueChanged<Set<ProjectStatus>> onChanged;

  const StatusFilter({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final menuController = MenuController();
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    String label;
    if (selected.isEmpty) {
      label = 'Status';
    } else if (selected.length == 1) {
      label = selected.first.label;
    } else {
      label = '${selected.length} statuses';
    }

    void toggleStatus(ProjectStatus status) {
      final newSelected = {...selected};
      if (newSelected.contains(status)) {
        newSelected.remove(status);
      } else {
        newSelected.add(status);
      }
      onChanged(newSelected);
    }

    void clearAll() {
      onChanged(<ProjectStatus>{});
    }

    return MenuAnchor(
      controller: menuController,
      menuChildren: [
        MenuItemButton(
          closeOnActivate: true,
          onPressed: clearAll,
          child: Row(
            children: [
              const Text('All'),
              if (selected.isEmpty) const Icon(Icons.check),
            ],
          ),
        ),
        const Divider(),

        for (final status in ProjectStatus.values)
          MenuItemButton(
            closeOnActivate: false,
            onPressed: () => toggleStatus(status),
            child: Row(
              children: [
                Expanded(child: Text(status.label)),
                if (selected.contains(status))
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
            label,
            style: theme.textTheme.labelMedium?.copyWith(color: cs.onSurface),
          ),
        ),
        side: BorderSide(color: cs.outline),
      ),
    );
  }
}
