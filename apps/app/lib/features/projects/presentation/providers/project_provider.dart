// lib/features/projects/project_providers.dart
import 'package:app/core/models/paginated_result.dart';
import 'package:app/features/projects/domain/providers/get_projects_usecase_provider.dart';
import 'package:app/features/projects/presentation/mappers/project_card_mapper.dart';
import 'package:app/features/projects/presentation/models/project_card_model.dart';
import 'package:app/features/projects/presentation/providers/projects_filters_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final projectsListProvider = FutureProvider<PaginatedResult<ProjectCardModel>>((
  ref,
) async {
  final useCase = ref.watch(getProjectsUseCaseProvider);
  final filters = ref.watch(projectFiltersProvider);
  final result = await useCase(filters: filters);
  return result.map(ProjectCardMapper.mapDomainToPresentation);
});
