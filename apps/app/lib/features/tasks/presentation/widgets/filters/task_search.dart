import 'dart:async';

import 'package:flutter/material.dart';

class TaskSearch extends StatefulWidget {
  final String? initialValue;
  final ValueChanged<String?> onChanged;

  const TaskSearch({
    super.key,
    this.initialValue,
    required this.onChanged,
  });

  @override
  State<TaskSearch> createState() => _TaskSearchState();
}

class _TaskSearchState extends State<TaskSearch> {
  late final TextEditingController _controller;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      widget.onChanged(value.isEmpty ? null : value);
    });
  }

  void _clear() {
    _controller.clear();
    widget.onChanged(null);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return SizedBox(
      width: 280,
      height: 40,
      child: TextFormField(
        controller: _controller,
        style: theme.textTheme.labelMedium?.copyWith(color: cs.onSurface),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, size: 18, color: cs.onSurface.withValues(alpha: 0.7)),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, size: 18, color: cs.onSurface.withValues(alpha: 0.7)),
                  onPressed: _clear,
                )
              : null,
          hintText: 'Search tasks...',
          hintStyle: theme.textTheme.labelMedium?.copyWith(
            color: cs.onSurface.withValues(alpha: 0.5),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: cs.outline),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: cs.outline),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: cs.primary, width: 2),
          ),
        ),
        onChanged: (value) {
          setState(() {}); // Rebuild to show/hide clear button
          _onChanged(value);
        },
      ),
    );
  }
}
