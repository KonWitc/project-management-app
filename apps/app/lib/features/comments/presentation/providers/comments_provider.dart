import 'package:app/features/auth/auth_providers.dart';
import 'package:app/features/comments/data/providers/comment_repository_provider.dart';
import 'package:app/features/comments/presentation/mappers/comment_ui_mapper.dart';
import 'package:app/features/comments/presentation/models/comment_ui_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final taskCommentsProvider =
    FutureProvider.family<List<CommentUiModel>, String>((ref, taskId) async {
  final repository = ref.watch(commentRepositoryProvider);
  final authState = ref.watch(authProvider).value;
  final currentUserId = authState?.user?['_id'] as String?;

  final comments = await repository.getCommentsByTaskId(taskId);
  return CommentUiMapper.mapDomainListToPresentation(
    comments,
    currentUserId: currentUserId,
  );
});
