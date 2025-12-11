import 'package:app/features/projects/presentation/widgets/filters/filter_chip.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:app/features/projects/presentation/providers/project_tags_provider.dart';

class TagsFilter extends ConsumerWidget {
  final List<String> selectedTags;
  final ValueChanged<List<String>> onChanged;
  const TagsFilter({
    super.key,
    required this.selectedTags,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final String label;
    if (selectedTags.isEmpty) {
      label = 'Tags';
    } else if (selectedTags.length == 1) {
      label = selectedTags.first;
    } else {
      label = '${selectedTags.first} +${selectedTags.length - 1}';
    }

    Future<void> openTagsSheet() async {
      final allTags = await ref.read(projectTagsProvider.future);

      final tempSelected = {...selectedTags};
      String query = '';

      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (ctx) {
          return StatefulBuilder(
            builder: (ctx, setState) {
              final filtered =
                  allTags
                      .where(
                        (t) => t.toLowerCase().contains(query.toLowerCase()),
                      )
                      .toList()
                    ..sort();

              return Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                  bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Search',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        setState(() {
                          query = value;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    if (filtered.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Text('No tags found'),
                      )
                    else
                      Flexible(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: filtered.length,
                          itemBuilder: (ctx, index) {
                            final tag = filtered[index];
                            final isSelected = tempSelected.contains(tag);

                            return ListTile(
                              dense: true,
                              title: Text(tag),
                              trailing: isSelected
                                  ? const Icon(Icons.check)
                                  : null,
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    tempSelected.remove(tag);
                                  } else {
                                    tempSelected.add(tag);
                                  }
                                  onChanged(tempSelected.toList());
                                });
                              },
                            );
                          },
                        ),
                      ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              tempSelected.clear();
                              onChanged(const []);
                            });
                          },
                          child: const Text('clear'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: const Text('Confirm'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    }

    return ProjectsFilterChip(
      onTap: openTagsSheet,
      label: Text(
        label,
        style: theme.textTheme.labelMedium?.copyWith(color: cs.onSurface),
      ),
    );
  }
}
