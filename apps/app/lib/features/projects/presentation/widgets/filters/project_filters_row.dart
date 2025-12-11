import 'package:app/features/projects/presentation/widgets/filters/deadline_filter.dart';
import 'package:app/features/projects/presentation/widgets/filters/projects_search.dart';
import 'package:app/features/projects/presentation/widgets/filters/sort_by.dart';
import 'package:app/features/projects/presentation/widgets/filters/sort_direction.dart';
import 'package:app/features/projects/presentation/widgets/filters/status_filter.dart';
import 'package:app/features/projects/presentation/providers/projects_filters_provider.dart';
import 'package:app/features/projects/presentation/widgets/filters/tags_filter.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProjectFiltersRow extends ConsumerWidget {
  const ProjectFiltersRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(projectFiltersProvider);
    final filtersNotifier = ref.read(projectFiltersProvider.notifier);

    return Row(
      spacing: 10,
      children: [
        StatusFilter(
          selected: filters.status,
          onChanged: (newValues) => filtersNotifier.setStatuses(newValues),
        ),
        DeadlineFilter(
          deadlineStart: filters.deadlineFrom,
          deadlineEnd: filters.deadlineTo,
          onChanged: (deadlineStart, deadlineEnd) =>
              filtersNotifier.setDeadlineRange(deadlineStart, deadlineEnd),
        ),
        ProjectSortBy(
          selectedSortBy: filters.sortBy,
          onChanged: (newSortBy) => filtersNotifier.setSort(
            sortBy: newSortBy,
            sortDir: filters.sortDir,
          ),
        ),
        ProjectSortDirection(
          selectedSortDir: filters.sortDir,
          onChanged: (newSortDir) => filtersNotifier.setSort(
            sortBy: filters.sortBy,
            sortDir: newSortDir,
          ),
        ),
        TagsFilter(
          selectedTags: filters.tags,
          onChanged: (newTags) => filtersNotifier.setTags(newTags),
        ),
        const Spacer(),
        ProjectsSearch(
          onChanged: (search) => filtersNotifier.setSearch(search),
        )
      ],
    );
  }
}
