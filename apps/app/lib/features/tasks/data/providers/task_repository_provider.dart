import 'package:app/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:app/features/tasks/domain/repositories/task_repository.dart';
import 'package:app/network/dio_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return TaskRepositoryImpl(dio);
});