import 'package:app/features/comments/data/dto/comment_dto.dart';
import 'package:app/features/comments/data/mappers/comment_mapper.dart';
import 'package:app/features/comments/domain/models/comment.dart';
import 'package:app/features/comments/domain/repositories/comment_repository.dart';
import 'package:dio/dio.dart';

class CommentRepositoryImpl implements CommentRepository {
  final Dio _dio;

  CommentRepositoryImpl(this._dio);

  @override
  Future<List<Comment>> getCommentsByTaskId(String taskId) async {
    final response = await _dio.get('/tasks/$taskId/comments');
    final List<dynamic> data = response.data;
    final dtos = data.map((json) => CommentDto.fromJson(json)).toList();
    return CommentMapper.mapDtoListToDomain(dtos);
  }

  @override
  Future<Comment> createComment(String taskId, String content, {String? parentId}) async {
    final dto = CreateCommentDto(content: content, parentId: parentId);
    final response = await _dio.post(
      '/tasks/$taskId/comments',
      data: dto.toJson(),
    );
    final commentDto = CommentDto.fromJson(response.data);
    return CommentMapper.mapDtoToDomain(commentDto);
  }

  @override
  Future<Comment> updateComment(String commentId, String content) async {
    final response = await _dio.put(
      '/tasks/_/comments/$commentId',
      data: {'content': content},
    );
    final commentDto = CommentDto.fromJson(response.data);
    return CommentMapper.mapDtoToDomain(commentDto);
  }

  @override
  Future<void> deleteComment(String commentId) async {
    await _dio.delete('/tasks/_/comments/$commentId');
  }
}
