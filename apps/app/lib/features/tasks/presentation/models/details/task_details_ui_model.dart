import 'package:app/features/tasks/presentation/models/details/task_details_context_model.dart';
import 'package:app/features/tasks/presentation/models/details/task_details_header_model.dart';
import 'package:app/features/tasks/presentation/models/details/task_details_time_tracking_model.dart';
import 'package:app/features/tasks/presentation/models/details/task_details_timeline_model.dart';

class TaskDetailsUiModel {
  final String taskId;
  final String? projectId;
  final TaskDetailsHeaderModel header;
  final TaskDetailsTimelineModel timeline;
  final TaskDetailsTimeTrackingModel timeTracking;
  final TaskDetailsContextModel context;

  const TaskDetailsUiModel({
    required this.taskId,
    this.projectId,
    required this.header,
    required this.timeline,
    required this.timeTracking,
    required this.context,
  });
}
