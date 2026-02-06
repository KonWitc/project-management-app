class CommentUiModel {
  final String id;
  final String taskId;
  final String authorName;
  final String? authorAvatar;
  final String authorInitials;
  final String content;
  final String? parentId;
  final bool isEdited;
  final String createdAtLabel;
  final String timeAgoLabel;
  final bool isCurrentUserAuthor;

  const CommentUiModel({
    required this.id,
    required this.taskId,
    required this.authorName,
    this.authorAvatar,
    required this.authorInitials,
    required this.content,
    this.parentId,
    required this.isEdited,
    required this.createdAtLabel,
    required this.timeAgoLabel,
    required this.isCurrentUserAuthor,
  });
}
