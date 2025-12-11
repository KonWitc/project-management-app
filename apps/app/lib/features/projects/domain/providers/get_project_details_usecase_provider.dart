import 'package:app/features/projects/domain/usecases/get_project_details_usecase.dart';
import 'package:app/features/projects/data/providers/project_repository_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final getProjectDetailsUseCaseProvider = Provider<GetProjectDetailsUseCase>((
  ref,
) {
  final repo = ref.watch(projectRepositoryProvider);
  return GetProjectDetailsUseCase(repo);
});
