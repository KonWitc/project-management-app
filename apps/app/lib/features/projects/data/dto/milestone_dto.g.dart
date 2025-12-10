// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'milestone_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MilestoneDto _$MilestoneDtoFromJson(Map<String, dynamic> json) => MilestoneDto(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  status: json['status'] as String,
  dueDate: json['dueDate'] == null
      ? null
      : DateTime.parse(json['dueDate'] as String),
  progress: (json['progress'] as num?)?.toInt(),
);

Map<String, dynamic> _$MilestoneDtoToJson(MilestoneDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'status': instance.status,
      'dueDate': instance.dueDate?.toIso8601String(),
      'progress': instance.progress,
    };
