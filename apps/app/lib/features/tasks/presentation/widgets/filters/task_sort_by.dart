import 'package:app/features/tasks/presentation/widgets/filters/task_filter_chip.dart';
import 'package:flutter/material.dart';

enum TaskSortField {
  dueDate,
  priority,
  status,
  title,
  createdAt,
}

extension TaskSortFieldX on TaskSortField {
  String get label {
    switch (this) {
      case TaskSortField.dueDate:
        return 'Due Date';
      case TaskSortField.priority:
        return 'Priority';
      case TaskSortField.status:
        return 'Status';
      case TaskSortField.title:
        return 'Title';
      case TaskSortField.createdAt:
        return 'Created';
    }
  }

  String get apiValue {
    switch (this) {
      case TaskSortField.dueDate:
        return 'dueDate';
      case TaskSortField.priority:
        return 'priority';
      case TaskSortField.status:
        return 'status';
      case TaskSortField.title:
        return 'title';
      case TaskSortField.createdAt:
        return 'createdAt';
    }
  }
}

class TaskSortBy extends StatelessWidget {
  final TaskSortField selectedSortBy;
  final bool isDescending;
  final ValueChanged<TaskSortField> onSortByChanged;
  final ValueChanged<bool> onSortOrderChanged;

  const TaskSortBy({
    super.key,
    required this.selectedSortBy,
    required this.isDescending,
    required this.onSortByChanged,
    required this.onSortOrderChanged,
  });

  @override
  Widget build(BuildContext context) {
    final menuController = MenuController();
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        MenuAnchor(
          controller: menuController,
          menuChildren: [
            for (final field in TaskSortField.values)
              MenuItemButton(
                closeOnActivate: true,
                onPressed: () => onSortByChanged(field),
                child: Row(
                  children: [
                    Expanded(child: Text(field.label)),
                    if (selectedSortBy == field)
                      Icon(Icons.check, color: cs.primary)
                    else
                      const SizedBox(width: 24),
                  ],
                ),
              ),
          ],
          child: TaskFilterChip(
            onTap: () {
              if (menuController.isOpen) {
                menuController.close();
              } else {
                menuController.open();
              }
            },
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.sort, size: 16, color: cs.onSurface),
                const SizedBox(width: 6),
                Text(
                  selectedSortBy.label,
                  style: theme.textTheme.labelMedium?.copyWith(color: cs.onSurface),
                ),
                const SizedBox(width: 4),
                Icon(Icons.arrow_drop_down, size: 18, color: cs.onSurface),
              ],
            ),
          ),
        ),
        const SizedBox(width: 4),
        IconButton(
          onPressed: () => onSortOrderChanged(!isDescending),
          icon: Icon(
            isDescending ? Icons.arrow_downward : Icons.arrow_upward,
            size: 18,
          ),
          tooltip: isDescending ? 'Descending' : 'Ascending',
          style: IconButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: cs.outline),
            ),
          ),
        ),
      ],
    );
  }
}
