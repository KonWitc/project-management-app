import 'package:app/features/projects/data/providers/milestone_repository_provider.dart';
import 'package:app/features/projects/domain/usecases/get_milestones_usecase.dart';
import 'package:app/features/projects/domain/usecases/create_milestone_usecase.dart';
import 'package:app/features/projects/domain/usecases/update_milestone_usecase.dart';
import 'package:app/features/projects/domain/usecases/delete_milestone_usecase.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final getMilestonesUseCaseProvider = Provider<GetMilestonesUseCase>((ref) {
  final repo = ref.read(milestoneRepositoryProvider);
  return GetMilestonesUseCase(repo);
});

final createMilestoneUseCaseProvider = Provider<CreateMilestoneUseCase>((ref) {
  final repo = ref.read(milestoneRepositoryProvider);
  return CreateMilestoneUseCase(repo);
});

final updateMilestoneUseCaseProvider = Provider<UpdateMilestoneUseCase>((ref) {
  final repo = ref.read(milestoneRepositoryProvider);
  return UpdateMilestoneUseCase(repo);
});

final deleteMilestoneUseCaseProvider = Provider<DeleteMilestoneUseCase>((ref) {
  final repo = ref.read(milestoneRepositoryProvider);
  return DeleteMilestoneUseCase(repo);
});