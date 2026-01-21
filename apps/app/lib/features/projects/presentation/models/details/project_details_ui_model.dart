import 'package:app/features/projects/presentation/models/details/milestones_overview_model.dart';
import 'package:app/features/projects/presentation/models/details/project_budget_model.dart';
import 'package:app/features/projects/presentation/models/details/project_details_header_model.dart';
import 'package:app/features/projects/presentation/models/details/project_timeline_model.dart';
import 'package:app/features/projects/presentation/models/details/project_tasks_overview_model.dart';

class ProjectDetailsUiModel {
  final String projectId;
  final ProjectDetailsHeaderModel header;
  final ProjectDetailsTimelineModel timeline;
  final ProjectBudgetModel budget;
  final ProjectTasksOverviewModel tasksOverview;
  final MilestonesOverviewModel milestonesOverview;

  const ProjectDetailsUiModel({
    required this.projectId,
    required this.header,
    required this.timeline,
    required this.budget,
    required this.tasksOverview,
    required this.milestonesOverview,
  });
}
