import 'package:flutter/material.dart';

class ProjectsFilterChip extends StatelessWidget {
  final Widget label;
  final VoidCallback onTap;
  const ProjectsFilterChip({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Material(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: cs.outline, width: 1),
          ),
          child: label,
        ),
      ),
    );
  }
}
