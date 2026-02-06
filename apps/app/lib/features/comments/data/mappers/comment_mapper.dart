import 'package:app/features/comments/data/dto/comment_dto.dart';
import 'package:app/features/comments/domain/models/comment.dart';

class CommentMapper {
  static Comment mapDtoToDomain(CommentDto dto) {
    return Comment(
      id: dto.id,
      taskId: dto.taskId,
      author: dto.author != null ? _mapAuthorDtoToDomain(dto.author!) : null,
      content: dto.content,
      parentId: dto.parentId,
      isEdited: dto.isEdited,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
    );
  }

  static CommentAuthor _mapAuthorDtoToDomain(CommentAuthorDto dto) {
    return CommentAuthor(
      id: dto.id,
      name: dto.name,
      email: dto.email,
      avatar: dto.avatar,
    );
  }

  static List<Comment> mapDtoListToDomain(List<CommentDto> dtos) {
    return dtos.map(mapDtoToDomain).toList();
  }
}
