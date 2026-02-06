import 'package:app/features/my_work/presentation/models/project_task_group.dart';
import 'package:app/features/tasks/presentation/widgets/task_card.dart';
import 'package:flutter/material.dart';

class ProjectGroupCard extends StatefulWidget {
  final ProjectTaskGroup group;
  final void Function(String taskId, String? projectId)? onTaskTap;

  const ProjectGroupCard({
    super.key,
    required this.group,
    this.onTaskTap,
  });

  @override
  State<ProjectGroupCard> createState() => _ProjectGroupCardState();
}

class _ProjectGroupCardState extends State<ProjectGroupCard> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    _isExpanded ? Icons.expand_more : Icons.chevron_right,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  if (widget.group.projectId == null) ...[
                    const Icon(
                      Icons.folder_off_outlined,
                      size: 20,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.group.projectName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${widget.group.taskCount} tasks • ${widget.group.completedCount} done',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  if (widget.group.overdueCount > 0)
                    Chip(
                      label: Text('${widget.group.overdueCount} overdue'),
                      backgroundColor: Colors.red.withValues(alpha:0.1),
                      labelStyle: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                ],
              ),
            ),
          ),
          if (_isExpanded)
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              itemCount: widget.group.tasks.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final task = widget.group.tasks[index];
                return TaskCard(
                  task: task,
                  onTap: widget.onTaskTap != null
                      ? () => widget.onTaskTap!(task.id, widget.group.projectId)
                      : null,
                );
              },
            ),
        ],
      ),
    );
  }
}
