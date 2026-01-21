import 'package:app/features/projects/data/dto/project_list_item_dto.dart';
import 'package:app/features/projects/domain/models/milestone.dart';
import 'package:app/features/projects/domain/models/project.dart';
import 'package:app/features/projects/domain/models/project_enums.dart';
import 'package:app/features/projects/data/dto/milestone_dto.dart';
import 'package:app/features/projects/data/dto/project_dto.dart';
import 'package:app/features/tasks/data/mappers/task_mapper.dart';

Milestone _mapMilestone(MilestoneDto dto) {
  final status = switch (dto.status) {
    'not_started' => MilestoneStatus.notStarted,
    'in_progress' => MilestoneStatus.inProgress,
    'completed' => MilestoneStatus.completed,
    'cancelled' => MilestoneStatus.cancelled,
    _ => MilestoneStatus.notStarted,
  };

  return Milestone(
    id: dto.id,
    name: dto.name,
    description: dto.description,
    status: status,
    dueDate: dto.dueDate,
    progress: dto.progress ?? 0,
  );
}

ProjectCategory? _mapCategory(String? category) {
  if (category == null) return null;

  switch (category.toLowerCase()) {
    case 'it':
      return ProjectCategory.it;

    case 'construction':
      return ProjectCategory.construction;

    case 'ecommerce':
    case 'e-commerce':
    case 'e commerce':
      return ProjectCategory.eCommerce;

    case 'r&d':
    case 'rd':
    case 'research & development':
    case 'research and development':
      return ProjectCategory.rd;

    case 'marketing':
      return ProjectCategory.marketing;

    case 'education':
      return ProjectCategory.education;

    case 'production':
      return ProjectCategory.production;

    case 'administration':
    case 'admin':
      return ProjectCategory.administration;

    case 'logistics':
      return ProjectCategory.logistics;

    case 'energy':
      return ProjectCategory.energy;

    default:
      return ProjectCategory.other;
  }
}

ProjectStatus _mapStatus(String raw) {
  switch (raw) {
    case 'draft':
      return ProjectStatus.draft;
    case 'active':
      return ProjectStatus.active;
    case 'completed':
      return ProjectStatus.completed;
    case 'archived':
      return ProjectStatus.archived;
    default:
      return ProjectStatus.draft;
  }
}

/// FULL / DETAILS DTO -> DOMAIN
Project mapProjectDtoToDomain(ProjectDto dto) {
  return Project(
    id: dto.id,
    name: dto.name,
    description: dto.description,
    status: _mapStatus(dto.status),

    organizationId: dto.organizationId,
    ownerId: dto.ownerId,
    memberIds: List.unmodifiable(dto.memberIds),

    startDate: dto.startDate,
    endDate: dto.endDate,
    deadline: dto.deadline,

    budget: dto.budget,
    actualCost: dto.actualCost,
    revenueEstimate: dto.revenueEstimate,

    tags: List.unmodifiable(dto.tags),
    category: _mapCategory(dto.category),

    milestones: ProjectMilestones(
      count: dto.milestonesCount,
      completedCount: dto.completedMilestonesCount,
      items: dto.milestones.map(_mapMilestone).toList(growable: false),
    ),

    tasksOverview: ProjectTasksOverview(
      count: dto.tasksCount,
      openCount: dto.openTasksCount,
      completedCount: dto.completedTasksCount,
      upcomingTasks: dto.upcomingTasks
          .map(mapTaskDtoToDomain)
          .toList(growable: false),
    ),
  );
}

/// LIST ITEM DTO -> DOMAIN (lightweight)
Project mapProjectListItemDtoToDomain(ProjectListItemDto dto) {
  return Project(
    id: dto.id,
    name: dto.name,
    description: dto.description,

    status: _mapStatus(dto.status ?? 'draft'),

    organizationId: dto.organizationId,
    ownerId: dto.ownerId,
    memberIds: const [],

    startDate: null,
    endDate: null,
    deadline: dto.deadline,

    budget: null,
    actualCost: null,
    revenueEstimate: null,

    tags: List.unmodifiable(dto.tags ?? const []),
    category: _mapCategory(dto.category),

    milestones: null,
    tasksOverview: null,
  );
}
