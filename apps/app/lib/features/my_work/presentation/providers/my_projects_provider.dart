import 'package:app/core/models/paginated_result.dart';
import 'package:app/features/auth/auth_providers.dart';
import 'package:app/features/projects/domain/models/project_filters.dart';
import 'package:app/features/projects/domain/providers/get_projects_usecase_provider.dart';
import 'package:app/features/projects/presentation/mappers/project_card_mapper.dart';
import 'package:app/features/projects/presentation/models/card/project_card_model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final myProjectsProvider =
    FutureProvider.family<PaginatedResult<ProjectCardModel>, ColorScheme>((
  ref,
  colorScheme,
) async {
  final authState = ref.watch(authProvider).value;
  final userId = authState?.user?['userId'] as String?;

  if (userId == null) {
    return const PaginatedResult(
      items: [],
      total: 0,
      page: 1,
      limit: 20,
      totalPages: 0,
    );
  }

  final useCase = ref.watch(getProjectsUseCaseProvider);
  final filters = ProjectFilters(memberId: userId, limit: 100);
  final result = await useCase(filters: filters);
  return result.map(
    (project) => ProjectCardMapper.mapDomainToPresentation(project, colorScheme),
  );
});
