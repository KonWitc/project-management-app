import 'package:app/features/tasks/presentation/providers/tasks_filters_provider.dart';
import 'package:app/features/tasks/presentation/widgets/filters/task_priority_filter.dart';
import 'package:app/features/tasks/presentation/widgets/filters/task_search.dart';
import 'package:app/features/tasks/presentation/widgets/filters/task_sort_by.dart';
import 'package:app/features/tasks/presentation/widgets/filters/task_status_filter.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TaskFiltersRow extends ConsumerWidget {
  final bool showSearch;
  final bool showSort;

  const TaskFiltersRow({
    super.key,
    this.showSearch = true,
    this.showSort = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(taskFiltersProvider);
    final filtersNotifier = ref.read(taskFiltersProvider.notifier);

    // Parse current sort field from filters
    final currentSortField = _parseSortField(filters.sortBy);
    final isDescending = filters.sortOrder == 'desc';

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          TaskStatusFilter(
            selected: filters.status,
            onChanged: (status) => filtersNotifier.setStatus(status),
          ),
          TaskPriorityFilter(
            selected: filters.priority,
            onChanged: (priority) => filtersNotifier.setPriority(priority),
          ),
          if (showSort)
            TaskSortBy(
              selectedSortBy: currentSortField,
              isDescending: isDescending,
              onSortByChanged: (field) => filtersNotifier.setSort(
                sortBy: field.apiValue,
                sortOrder: filters.sortOrder,
              ),
              onSortOrderChanged: (desc) => filtersNotifier.setSort(
                sortBy: filters.sortBy,
                sortOrder: desc ? 'desc' : 'asc',
              ),
            ),
          if (_hasActiveFilters(filters))
            TextButton.icon(
              onPressed: () => filtersNotifier.reset(),
              icon: const Icon(Icons.clear_all, size: 18),
              label: const Text('Clear filters'),
            ),
          if (showSearch) ...[
            const Spacer(),
            TaskSearch(
              initialValue: filters.search,
              onChanged: (search) => filtersNotifier.setSearch(search),
            ),
          ],
        ],
      ),
    );
  }

  TaskSortField _parseSortField(String? sortBy) {
    switch (sortBy) {
      case 'dueDate':
        return TaskSortField.dueDate;
      case 'priority':
        return TaskSortField.priority;
      case 'status':
        return TaskSortField.status;
      case 'title':
        return TaskSortField.title;
      case 'createdAt':
        return TaskSortField.createdAt;
      default:
        return TaskSortField.dueDate;
    }
  }

  bool _hasActiveFilters(filters) {
    return filters.status != null ||
        filters.priority != null ||
        (filters.search != null && filters.search!.isNotEmpty);
  }
}
