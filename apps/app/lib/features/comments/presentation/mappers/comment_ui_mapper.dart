import 'package:app/features/comments/domain/models/comment.dart';
import 'package:app/features/comments/presentation/models/comment_ui_model.dart';
import 'package:intl/intl.dart';

class CommentUiMapper {
  static CommentUiModel mapDomainToPresentation(
    Comment comment, {
    String? currentUserId,
  }) {
    final authorName = comment.author?.name ?? 'Unknown';
    final initials = _getInitials(authorName);

    return CommentUiModel(
      id: comment.id,
      taskId: comment.taskId,
      authorName: authorName,
      authorAvatar: comment.author?.avatar,
      authorInitials: initials,
      content: comment.content,
      parentId: comment.parentId,
      isEdited: comment.isEdited,
      createdAtLabel: _formatDate(comment.createdAt),
      timeAgoLabel: _formatTimeAgo(comment.createdAt),
      isCurrentUserAuthor: comment.author?.id == currentUserId,
    );
  }

  static List<CommentUiModel> mapDomainListToPresentation(
    List<Comment> comments, {
    String? currentUserId,
  }) {
    return comments
        .map((c) => mapDomainToPresentation(c, currentUserId: currentUserId))
        .toList();
  }

  static String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  static String _formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy, HH:mm').format(date);
  }

  static String _formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inSeconds < 60) {
      return 'just now';
    } else if (diff.inMinutes < 60) {
      final mins = diff.inMinutes;
      return '$mins ${mins == 1 ? 'minute' : 'minutes'} ago';
    } else if (diff.inHours < 24) {
      final hours = diff.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    } else if (diff.inDays < 7) {
      final days = diff.inDays;
      return '$days ${days == 1 ? 'day' : 'days'} ago';
    } else if (diff.inDays < 30) {
      final weeks = (diff.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (diff.inDays < 365) {
      final months = (diff.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      final years = (diff.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
  }
}
