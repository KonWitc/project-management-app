import 'package:flutter/material.dart';

class TaskFilterChip extends StatelessWidget {
  final Widget label;
  final VoidCallback onTap;
  final bool isActive;

  const TaskFilterChip({
    super.key,
    required this.label,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isActive ? cs.primary : cs.outline,
              width: isActive ? 2 : 1,
            ),
            color: isActive ? cs.primary.withValues(alpha: 0.1) : null,
          ),
          child: label,
        ),
      ),
    );
  }
}
