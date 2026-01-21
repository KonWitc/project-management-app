import 'package:app/features/projects/data/repositories/milestone_repository_impl.dart';
import 'package:app/features/projects/domain/repository/milestone_repository.dart';
import 'package:app/network/dio_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final milestoneRepositoryProvider = Provider<MilestoneRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return MilestoneRepositoryImpl(dio);
});