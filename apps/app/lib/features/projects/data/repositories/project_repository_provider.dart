import 'package:app/features/projects/data/repositories/project_repository_impl.dart';
import 'package:app/features/projects/domain/repositories/project_repository.dart';
import 'package:app/network/dio_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ProjectRepositoryImpl(dio);
});
