import 'package:app/features/comments/domain/models/comment.dart';

abstract class CommentRepository {
  Future<List<Comment>> getCommentsByTaskId(String taskId);
  Future<Comment> createComment(String taskId, String content, {String? parentId});
  Future<Comment> updateComment(String commentId, String content);
  Future<void> deleteComment(String commentId);
}
