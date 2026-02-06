class CommentAuthor {
  final String id;
  final String name;
  final String? email;
  final String? avatar;

  const CommentAuthor({
    required this.id,
    required this.name,
    this.email,
    this.avatar,
  });
}

class Comment {
  final String id;
  final String taskId;
  final CommentAuthor? author;
  final String content;
  final String? parentId;
  final bool isEdited;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Comment({
    required this.id,
    required this.taskId,
    this.author,
    required this.content,
    this.parentId,
    required this.isEdited,
    required this.createdAt,
    required this.updatedAt,
  });
}
