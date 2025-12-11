import 'package:app/features/projects/domain/providers/get_project_tags_usecase_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final projectTagsProvider = FutureProvider<List<String>>((ref) async {
  final useCase = ref.watch(getProjectTagsUseCaseProvider);
  return useCase();
});