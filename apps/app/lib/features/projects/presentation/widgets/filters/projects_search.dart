import 'dart:async';

import 'package:flutter/material.dart';

class ProjectsSearch extends StatefulWidget {
  final ValueChanged<String> onChanged;
  const ProjectsSearch({super.key, required this.onChanged});

  @override
  State<ProjectsSearch> createState() => _ProjectsSearchState();
}

class _ProjectsSearchState extends State<ProjectsSearch> {
  Timer? _debounce;

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      widget.onChanged(value);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return SizedBox(
      width: 400,
      height: 40,
      child: TextFormField(
        style: theme.textTheme.labelMedium?.copyWith(color: cs.onSurface),
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, size: 18),
          label: Text(
            'Search',
            style: theme.textTheme.labelMedium?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.7),
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: cs.outline),
          ),
        ),
        onChanged: (value) => _onChanged(value),
      ),
    );
  }
}
