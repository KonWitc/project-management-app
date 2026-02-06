import 'package:app/features/tasks/domain/models/task_enums.dart';
import 'package:app/features/tasks/presentation/widgets/filters/task_filter_chip.dart';
import 'package:flutter/material.dart';

class TaskStatusFilter extends StatelessWidget {
  final TaskStatus? selected;
  final ValueChanged<TaskStatus?> onChanged;

  const TaskStatusFilter({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final menuController = MenuController();
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final label = selected?.label ?? 'All Status';

    return MenuAnchor(
      controller: menuController,
      menuChildren: [
        MenuItemButton(
          closeOnActivate: true,
          onPressed: () => onChanged(null),
          child: Row(
            children: [
              const Expanded(child: Text('All Status')),
              if (selected == null)
                Icon(Icons.check, color: cs.primary)
              else
                const SizedBox(width: 24),
            ],
          ),
        ),
        const Divider(),
        for (final status in TaskStatus.values)
          MenuItemButton(
            closeOnActivate: true,
            onPressed: () => onChanged(status),
            child: Row(
              children: [
                Icon(
                  _getStatusIcon(status),
                  size: 18,
                  color: _getStatusColor(status),
                ),
                const SizedBox(width: 8),
                Expanded(child: Text(status.label)),
                if (selected == status)
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
                _getStatusIcon(selected!),
                size: 16,
                color: _getStatusColor(selected!),
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

  IconData _getStatusIcon(TaskStatus status) {
    switch (status) {
      case TaskStatus.notStarted:
        return Icons.circle_outlined;
      case TaskStatus.inProgress:
        return Icons.play_circle_outline;
      case TaskStatus.blocked:
        return Icons.block;
      case TaskStatus.cancelled:
        return Icons.cancel_outlined;
      case TaskStatus.done:
        return Icons.check_circle;
    }
  }

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.notStarted:
        return Colors.grey;
      case TaskStatus.inProgress:
        return Colors.blue;
      case TaskStatus.blocked:
        return Colors.red;
      case TaskStatus.cancelled:
        return Colors.grey.shade600;
      case TaskStatus.done:
        return Colors.green;
    }
  }
}