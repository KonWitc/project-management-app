import 'package:app/features/projects/domain/usecases/get_projects_usecase.dart';
import 'package:app/features/projects/data/providers/project_repository_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final getProjectsUseCaseProvider = Provider<GetProjectsUseCase>((ref) {
  final repo = ref.read(projectRepositoryProvider);
  return GetProjectsUseCase(repo);
});