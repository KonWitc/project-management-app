import 'package:app/features/tasks/domain/models/task_enums.dart';
import 'package:app/features/tasks/presentation/widgets/filters/task_filter_chip.dart';
import 'package:flutter/material.dart';

class TaskPriorityFilter extends StatelessWidget {
  final TaskPriority? selected;
  final ValueChanged<TaskPriority?> onChanged;

  const TaskPriorityFilter({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final menuController = MenuController();
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final label = selected != null ? _getPriorityLabel(selected!) : 'All Priority';

    return MenuAnchor(
      controller: menuController,
      menuChildren: [
        MenuItemButton(
          closeOnActivate: true,
          onPressed: () => onChanged(null),
          child: Row(
            children: [
              const Expanded(child: Text('All Priority')),
              if (selected == null)
                Icon(Icons.check, color: cs.primary)
              else
                const SizedBox(width: 24),
            ],
          ),
        ),
        const Divider(),
        for (final priority in TaskPriority.values)
          MenuItemButton(
            closeOnActivate: true,
            onPressed: () => onChanged(priority),
            child: Row(
              children: [
                Icon(
                  Icons.flag,
                  size: 18,
                  color: _getPriorityColor(priority),
                ),
                const SizedBox(width: 8),
                Expanded(child: Text(_getPriorityLabel(priority))),
                if (selected == priority)
                  Icon(Icons.check, color: cs.primary)
                else
                  const SizedBox(width: 24),
              ],
            ),
          ),
      ],
      child: TaskFilterChip(
        isActive: selected != null,
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
            if (selected != null) ...[
              Icon(
                Icons.flag,
                size: 16,
                color: _getPriorityColor(selected!),
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(color: cs.onSurface),
            ),
            const SizedBox(width: 4),
            Icon(Icons.arrow_drop_down, size: 18, color: cs.onSurface),
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return Colors.green;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.high:
        return Colors.deepOrange;
      case TaskPriority.critical:
        return Colors.red;
    }
  }

  String _getPriorityLabel(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return 'Low';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.high:
        return 'High';
      case TaskPriority.critical:
        return 'Critical';
    }
  }
}