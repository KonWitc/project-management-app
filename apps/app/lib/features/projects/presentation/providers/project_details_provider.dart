import 'package:app/features/projects/domain/models/project.dart';
import 'package:app/features/projects/domain/providers/get_project_details_usecase_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final projectDetailsProvider = FutureProvider.family<Project, String>((
  ref,
  projectId,
) async {
  final useCase = ref.watch(getProjectDetailsUseCaseProvider);
  return useCase(projectId);
});
