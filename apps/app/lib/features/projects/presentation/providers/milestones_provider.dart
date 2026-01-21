import 'package:app/features/projects/domain/models/milestone.dart';
import 'package:app/features/projects/domain/providers/milestone_usecase_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MilestonesState {
  final List<Milestone> milestones;
  final bool isLoading;
  final String? error;

  const MilestonesState({
    this.milestones = const [],
    this.isLoading = false,
    this.error,
  });

  MilestonesState copyWith({
    List<Milestone>? milestones,
    bool? isLoading,
    String? error,
  }) {
    return MilestonesState(
      milestones: milestones ?? this.milestones,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class MilestonesNotifier extends Notifier<MilestonesState> {
  late String _projectId;

  String get projectId => _projectId;

  @override
  MilestonesState build() {
    return const MilestonesState();
  }

  void setProjectId(String projectId) {
    _projectId = projectId;
  }

  Future<void> loadMilestones() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final useCase = ref.read(getMilestonesUseCaseProvider);
      final result = await useCase(projectId: projectId);

      state = state.copyWith(
        milestones: result.items,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> createMilestone({
    required String name,
    String? description,
    String? status,
    DateTime? dueDate,
  }) async {
    try {
      final useCase = ref.read(createMilestoneUseCaseProvider);
      await useCase(
        projectId: projectId,
        name: name,
        description: description,
        status: status,
        dueDate: dueDate,
      );

      // Reload milestones after creation
      await loadMilestones();
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  Future<void> updateMilestone({
    required String milestoneId,
    String? name,
    String? description,
    String? status,
    DateTime? dueDate,
    int? progress,
  }) async {
    try {
      final useCase = ref.read(updateMilestoneUseCaseProvider);
      await useCase(
        projectId: projectId,
        milestoneId: milestoneId,
        name: name,
        description: description,
        status: status,
        dueDate: dueDate,
        progress: progress,
      );

      // Reload milestones after update
      await loadMilestones();
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  Future<void> deleteMilestone(String milestoneId) async {
    try {
      final useCase = ref.read(deleteMilestoneUseCaseProvider);
      await useCase(
        projectId: projectId,
        milestoneId: milestoneId,
      );

      // Reload milestones after deletion
      await loadMilestones();
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }
}

final milestonesProvider = NotifierProvider.family<MilestonesNotifier,
    MilestonesState, String>(
  (projectId) {
    final notifier = MilestonesNotifier();
    notifier.setProjectId(projectId);
    return notifier;
  },
);