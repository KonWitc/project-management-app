import 'package:json_annotation/json_annotation.dart';

part 'comment_dto.g.dart';

@JsonSerializable()
class CommentAuthorDto {
  final String id;
  final String name;
  final String? email;
  final String? avatar;

  const CommentAuthorDto({
    required this.id,
    required this.name,
    this.email,
    this.avatar,
  });

  factory CommentAuthorDto.fromJson(Map<String, dynamic> json) =>
      _$CommentAuthorDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CommentAuthorDtoToJson(this);
}

@JsonSerializable()
class CommentDto {
  final String id;
  final String taskId;
  final CommentAuthorDto? author;
  final String content;
  final String? parentId;
  final bool isEdited;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CommentDto({
    required this.id,
    required this.taskId,
    this.author,
    required this.content,
    this.parentId,
    required this.isEdited,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CommentDto.fromJson(Map<String, dynamic> json) =>
      _$CommentDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CommentDtoToJson(this);
}

@JsonSerializable()
class CreateCommentDto {
  final String content;
  final String? parentId;

  const CreateCommentDto({
    required this.content,
    this.parentId,
  });

  factory CreateCommentDto.fromJson(Map<String, dynamic> json) =>
      _$CreateCommentDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreateCommentDtoToJson(this);
}
