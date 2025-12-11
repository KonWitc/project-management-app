import 'package:app/features/projects/domain/usecases/get_project_tags_usecase.dart';
import 'package:app/features/projects/data/providers/project_repository_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final getProjectTagsUseCaseProvider = Provider<GetProjectTagsUseCase>((ref) {
  final repo = ref.watch(projectRepositoryProvider);
  return GetProjectTagsUseCase(repo);
});
