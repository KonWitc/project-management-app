import 'package:app/core/models/paginated_result.dart';
import 'package:app/features/tasks/data/dto/task_dto.dart';
import 'package:app/features/tasks/data/mappers/task_mapper.dart';
import 'package:app/features/tasks/domain/models/task.dart';
import 'package:app/features/tasks/domain/models/task_filters.dart';
import 'package:app/features/tasks/domain/repositories/task_repository.dart';
import 'package:dio/dio.dart';

class TaskRepositoryImpl implements TaskRepository {
  final Dio _dio;

  TaskRepositoryImpl(this._dio);

  static const _tasksPath = '/tasks';

  @override
  Future<PaginatedResult<Task>> getTasks({TaskFilters? filters}) async {
    final queryParams =
        filters?.toQueryParameters() ?? const TaskFilters().toQueryParameters();

    final resp = await _dio.get<Map<String, dynamic>>(
      _tasksPath,
      queryParameters: queryParams,
    );

    final itemsRaw = (resp.data?['items'] as List? ?? const [])
        .cast<Map>()
        .map((e) => e.cast<String, dynamic>())
        .toList();

    final List<TaskDto> itemsDto = itemsRaw.map((json) {
      try {
        return TaskDto.fromJson(json);
      } catch (error) {
        return TaskDto.fromJson(json);
      }
    }).toList();

    final items = itemsDto.map((dto) => mapTaskDtoToDomain(dto)).toList();

    final total = (resp.data?['total'] as num?)?.toInt() ?? 0;
    final page = (resp.data?['page'] as num?)?.toInt() ?? filters?.page ?? 1;
    final limit =
        (resp.data?['limit'] as num?)?.toInt() ?? filters?.limit ?? 20;
    final totalPages =
        (resp.data?['totalPages'] as num?)?.toInt() ??
        (limit == 0 ? 0 : (total / limit).ceil());

    return PaginatedResult<Task>(
      items: items,
      total: total,
      page: page,
      limit: limit,
      totalPages: totalPages,
    );
  }

  @override
  Future<Task> getTaskById(String id) async {
    final resp = await _dio.get<Map<String, dynamic>>('$_tasksPath/$id');
    final dto = TaskDto.fromJson(resp.data!);
    return mapTaskDtoToDomain(dto);
  }

  @override
  Future<Task> createTask(Task task) async {
    final body = mapTaskDomainToCreateDto(task);
    final resp = await _dio.post<Map<String, dynamic>>(_tasksPath, data: body);
    final dto = TaskDto.fromJson(resp.data!);
    return mapTaskDtoToDomain(dto);
  }

  @override
  Future<Task> updateTask(String id, Task task) async {
    final body = mapTaskDomainToUpdateDto(task);
    final resp = await _dio.put<Map<String, dynamic>>(
      '$_tasksPath/$id',
      data: body,
    );
    final dto = TaskDto.fromJson(resp.data!);
    return mapTaskDtoToDomain(dto);
  }

  @override
  Future<void> deleteTask(String id) async {
    await _dio.delete('$_tasksPath/$id');
  }

  @override
  Future<List<String>> getTags({String? projectId}) async {
    final queryParams = projectId != null ? {'projectId': projectId} : null;
    final response = await _dio.get<List<dynamic>>(
      '$_tasksPath/tags',
      queryParameters: queryParams,
    );

    final data = response.data ?? [];
    return data.map((e) => e.toString()).toList();
  }

  @override
  Future<List<String>> getTaskTypes({String? projectId}) async {
    final queryParams = projectId != null ? {'projectId': projectId} : null;
    final response = await _dio.get<List<dynamic>>(
      '$_tasksPath/types',
      queryParameters: queryParams,
    );

    final data = response.data ?? [];
    return data.map((e) => e.toString()).toList();
  }
}
