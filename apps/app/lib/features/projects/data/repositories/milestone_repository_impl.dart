import 'package:app/core/models/paginated_result.dart';
import 'package:app/features/projects/data/dto/milestone_dto.dart';
import 'package:app/features/projects/domain/models/milestone.dart';
import 'package:app/features/projects/domain/models/project_enums.dart';
import 'package:app/features/projects/domain/repository/milestone_repository.dart';
import 'package:dio/dio.dart';

Milestone _mapMilestone(MilestoneDto dto) {
  final status = switch (dto.status) {
    'not_started' => MilestoneStatus.notStarted,
    'in_progress' => MilestoneStatus.inProgress,
    'completed' => MilestoneStatus.completed,
    'cancelled' => MilestoneStatus.cancelled,
    _ => MilestoneStatus.notStarted,
  };

  return Milestone(
    id: dto.id,
    name: dto.name,
    description: dto.description,
    status: status,
    dueDate: dto.dueDate,
    progress: dto.progress ?? 0,
  );
}

String _mapStatusToString(String status) {
  switch (status.toLowerCase()) {
    case 'notstarted':
    case 'not_started':
      return 'not_started';
    case 'inprogress':
    case 'in_progress':
      return 'in_progress';
    case 'completed':
      return 'completed';
    case 'cancelled':
      return 'cancelled';
    default:
      return 'not_started';
  }
}

class MilestoneRepositoryImpl implements MilestoneRepository {
  final Dio _dio;

  MilestoneRepositoryImpl(this._dio);

  String _getMilestonesPath(String projectId) => '/projects/$projectId/milestones';

  @override
  Future<PaginatedResult<Milestone>> getMilestones({
    required String projectId,
    String? status,
    String? search,
    int? page,
    int? limit,
    String? sortBy,
    String? sortDir,
  }) async {
    final queryParams = <String, dynamic>{};
    if (status != null) queryParams['status'] = _mapStatusToString(status);
    if (search != null) queryParams['search'] = search;
    if (page != null) queryParams['page'] = page;
    if (limit != null) queryParams['limit'] = limit;
    if (sortBy != null) queryParams['sortBy'] = sortBy;
    if (sortDir != null) queryParams['sortDir'] = sortDir;

    final resp = await _dio.get<Map<String, dynamic>>(
      _getMilestonesPath(projectId),
      queryParameters: queryParams,
    );

    final itemsRaw = (resp.data?['items'] as List? ?? const [])
        .cast<Map>()
        .map((e) => e.cast<String, dynamic>())
        .toList();

    final List<MilestoneDto> itemsDto =
        itemsRaw.map((json) => MilestoneDto.fromJson(json)).toList();

    final items = itemsDto.map((dto) => _mapMilestone(dto)).toList();

    final total = (resp.data?['total'] as num?)?.toInt() ?? 0;
    final currentPage = (resp.data?['page'] as num?)?.toInt() ?? page ?? 1;
    final currentLimit = (resp.data?['limit'] as num?)?.toInt() ?? limit ?? 10;
    final totalPages = (resp.data?['totalPages'] as num?)?.toInt() ??
        (currentLimit == 0 ? 0 : (total / currentLimit).ceil());

    return PaginatedResult<Milestone>(
      items: items,
      total: total,
      page: currentPage,
      limit: currentLimit,
      totalPages: totalPages,
    );
  }

  @override
  Future<Milestone> getMilestoneById({
    required String projectId,
    required String milestoneId,
  }) async {
    final resp = await _dio.get<Map<String, dynamic>>(
      '${_getMilestonesPath(projectId)}/$milestoneId',
    );

    final dto = MilestoneDto.fromJson(resp.data!);
    return _mapMilestone(dto);
  }

  @override
  Future<Milestone> createMilestone({
    required String projectId,
    required String name,
    String? description,
    String? status,
    DateTime? dueDate,
    List<String>? tags,
    String? ownerId,
  }) async {
    final body = <String, dynamic>{
      'name': name,
    };

    if (description != null) body['description'] = description;
    if (status != null) body['status'] = _mapStatusToString(status);
    if (dueDate != null) body['dueDate'] = dueDate.toIso8601String();
    if (tags != null) body['tags'] = tags;
    if (ownerId != null) body['ownerId'] = ownerId;

    final resp = await _dio.post<Map<String, dynamic>>(
      _getMilestonesPath(projectId),
      data: body,
    );

    final dto = MilestoneDto.fromJson(resp.data!);
    return _mapMilestone(dto);
  }

  @override
  Future<Milestone> updateMilestone({
    required String projectId,
    required String milestoneId,
    String? name,
    String? description,
    String? status,
    DateTime? dueDate,
    List<String>? tags,
    String? ownerId,
    int? progress,
  }) async {
    final body = <String, dynamic>{};

    if (name != null) body['name'] = name;
    if (description != null) body['description'] = description;
    if (status != null) body['status'] = _mapStatusToString(status);
    if (dueDate != null) body['dueDate'] = dueDate.toIso8601String();
    if (tags != null) body['tags'] = tags;
    if (ownerId != null) body['ownerId'] = ownerId;
    if (progress != null) body['progress'] = progress;

    final resp = await _dio.patch<Map<String, dynamic>>(
      '${_getMilestonesPath(projectId)}/$milestoneId',
      data: body,
    );

    final dto = MilestoneDto.fromJson(resp.data!);
    return _mapMilestone(dto);
  }

  @override
  Future<void> deleteMilestone({
    required String projectId,
    required String milestoneId,
  }) async {
    await _dio.delete(
      '${_getMilestonesPath(projectId)}/$milestoneId',
    );
  }

  @override
  Future<int> calculateProgress({
    required String milestoneId,
  }) async {
    final resp = await _dio.post<Map<String, dynamic>>(
      '/projects/_/milestones/$milestoneId/calculate-progress',
    );

    return (resp.data?['progress'] as num?)?.toInt() ?? 0;
  }
}