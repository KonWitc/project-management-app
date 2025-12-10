import 'package:app/core/models/paginated_result.dart';
import 'package:app/features/projects/data/mappers/project_mapper.dart';
import 'package:app/features/projects/domain/models/project_filters.dart';
import 'package:app/features/projects/data/dto/project_list_item_dto.dart';
import 'package:app/features/projects/domain/models/project.dart';
import 'package:app/features/projects/domain/repositories/project_repository.dart';
import 'package:dio/dio.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final Dio _dio;

  ProjectRepositoryImpl(this._dio);

  static const _projectsPath = '/projects';
  @override
  Future<PaginatedResult<Project>> getProjects({
    ProjectFilters? filters,
  }) async {
    final queryParams =
        filters?.toQueryParameters() ??
        const ProjectFilters().toQueryParameters();

    final resp = await _dio.get<Map<String, dynamic>>(
      _projectsPath,
      queryParameters: queryParams,
    );

    final itemsRaw = (resp.data?['items'] as List? ?? const [])
        .cast<Map>()
        .map((e) => e.cast<String, dynamic>())
        .toList();

    final List<ProjectListItemDto> itemsDto = itemsRaw
        .map((json) => ProjectListItemDto.fromJson(json))
        .toList();

    final items = itemsDto
        .map((dto) => mapProjectListItemDtoToDomain(dto))
        .toList();

    final total = (resp.data?['total'] as num?)?.toInt() ?? 0;
    final page = (resp.data?['page'] as num?)?.toInt() ?? filters?.page ?? 1;
    final limit =
        (resp.data?['limit'] as num?)?.toInt() ?? filters?.limit ?? 20;
    final totalPages =
        (resp.data?['totalPages'] as num?)?.toInt() ??
        (limit == 0 ? 0 : (total / limit).ceil());

    return PaginatedResult<Project>(
      items: items,
      total: total,
      page: page,
      limit: limit,
      totalPages: totalPages,
    );
  }

  @override
  Future<Project> getOneProject() {
    // TODO: implement getOneProject
    throw UnimplementedError();
  }

  @override
  Future<List<String>> getTags() async {
    final resp = await _dio.get<Map<String, dynamic>>(_projectsPath);

    return resp.data?['tags'];
  }
}
