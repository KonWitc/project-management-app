// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentAuthorDto _$CommentAuthorDtoFromJson(Map<String, dynamic> json) =>
    CommentAuthorDto(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String?,
      avatar: json['avatar'] as String?,
    );

Map<String, dynamic> _$CommentAuthorDtoToJson(CommentAuthorDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'avatar': instance.avatar,
    };

CommentDto _$CommentDtoFromJson(Map<String, dynamic> json) => CommentDto(
      id: json['id'] as String,
      taskId: json['taskId'] as String,
      author: json['author'] == null
          ? null
          : CommentAuthorDto.fromJson(json['author'] as Map<String, dynamic>),
      content: json['content'] as String,
      parentId: json['parentId'] as String?,
      isEdited: json['isEdited'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$CommentDtoToJson(CommentDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'taskId': instance.taskId,
      'author': instance.author,
      'content': instance.content,
      'parentId': instance.parentId,
      'isEdited': instance.isEdited,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

CreateCommentDto _$CreateCommentDtoFromJson(Map<String, dynamic> json) =>
    CreateCommentDto(
      content: json['content'] as String,
      parentId: json['parentId'] as String?,
    );

Map<String, dynamic> _$CreateCommentDtoToJson(CreateCommentDto instance) =>
    <String, dynamic>{
      'content': instance.content,
      'parentId': instance.parentId,
    };
