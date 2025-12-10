import 'package:app/core/utils/types/multiple_value_changed.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DeadlineFilter extends StatelessWidget {
  final DateTime? deadlineStart;
  final DateTime? deadlineEnd;
  final TwoValuesChanged<DateTime?, DateTime?> onChanged;

  const DeadlineFilter({
    super.key,
    required this.deadlineStart,
    required this.deadlineEnd,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final hasValue = deadlineStart != null && deadlineEnd != null;

    final label = hasValue
        ? '${DateFormat('dd.MM.yyyy').format(deadlineStart!)} → ${DateFormat('dd.MM.yyyy').format(deadlineEnd!)}'
        : 'Deadline Range';

    Future<void> pickRange() async {
      final picked = await showDateRangePicker(
        context: context,
        initialDateRange: hasValue
            ? DateTimeRange(start: deadlineStart!, end: deadlineEnd!)
            : null,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        builder: (context, child) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 400.0,
                maxHeight: 600.0,
              ),
              child: child,
            ),
          );
        },
      );

      if (picked != null) {
        onChanged(picked.start, picked.end);
      }
    }

    return Material(
      color: cs.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: cs.outline),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: pickRange,
              child: Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: cs.onSurface,
                ),
              ),
            ),
            if (hasValue) const SizedBox(width: 6),
            if (hasValue)
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => onChanged(null, null),
                child: Icon(
                  Icons.close,
                  size: 16,
                  color: cs.onSurface.withValues(alpha: 0.7),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
