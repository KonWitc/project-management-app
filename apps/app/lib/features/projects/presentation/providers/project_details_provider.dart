import 'package:app/features/projects/domain/providers/get_project_details_usecase_provider.dart';
import 'package:app/features/projects/presentation/mappers/project_details_mapper.dart';
import 'package:app/features/projects/presentation/models/details/project_details_ui_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final projectDetailsProvider =
    FutureProvider.family<ProjectDetailsUiModel, String>((
      ref,
      projectId,
    ) async {
      final useCase = ref.watch(getProjectDetailsUseCaseProvider);
      final result = await useCase(projectId);
      return ProjectDetailsMapper.mapDomainToPresentation(result);
    });
