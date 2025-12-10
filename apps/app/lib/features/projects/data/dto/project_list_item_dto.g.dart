// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_list_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjectListItemDto _$ProjectListItemDtoFromJson(Map<String, dynamic> json) =>
    ProjectListItemDto(
      id: json['_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      status: json['status'] as String?,
      organizationId: json['organizationId'] as String?,
      ownerId: json['ownerId'] as String?,
      deadline: json['deadline'] == null
          ? null
          : DateTime.parse(json['deadline'] as String),
      category: json['category'] as String?,
    );

Map<String, dynamic> _$ProjectListItemDtoToJson(ProjectListItemDto instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'status': instance.status,
      'organizationId': instance.organizationId,
      'ownerId': instance.ownerId,
      'deadline': instance.deadline?.toIso8601String(),
      'category': instance.category,
    };
