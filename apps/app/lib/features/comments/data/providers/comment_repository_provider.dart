import 'package:app/features/comments/data/repositories/comment_repository_impl.dart';
import 'package:app/features/comments/domain/repositories/comment_repository.dart';
import 'package:app/network/dio_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final commentRepositoryProvider = Provider<CommentRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return CommentRepositoryImpl(dio);
});
