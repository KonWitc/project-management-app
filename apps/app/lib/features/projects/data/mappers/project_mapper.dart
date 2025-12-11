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

ProjectStatus _mapStatus(String status) {
  switch (status) {
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
    milestones: dto.milestones.map(_mapMilestone).toList(growable: false),
    tasks: dto.tasks.map(mapTaskDtoToDomain).toList(growable: false),
    budget: dto.budget,
    actualCost: dto.actualCost,
    revenueEstimate: dto.revenueEstimate,
    tags: List.unmodifiable(dto.tags),
    category: _mapCategory(dto.category),
  );
}

Project mapProjectListItemDtoToDomain(ProjectListItemDto dto) {

  return Project(
    id: dto.id,
    name: dto.name,
    description: dto.description,
    status: _mapStatus(dto.status ?? 'it'),
    organizationId: '',
    ownerId: dto.ownerId ?? '1',
    memberIds: [],
    milestones: [],
    tasks: [],
    tags: dto.tags ?? [],
    deadline: dto.deadline,
    category: _mapCategory(dto.category),
  );
}
