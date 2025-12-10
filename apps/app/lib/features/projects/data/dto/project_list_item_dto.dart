import 'package:json_annotation/json_annotation.dart';

part 'project_list_item_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class ProjectListItemDto {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final String? description;
  final String? status;
  final String? organizationId;
  final String? ownerId;
  final DateTime? deadline;
  final String? category;

  const ProjectListItemDto({
    required this.id,
    required this.name,
    this.description,
    this.status,
    this.organizationId,
    this.ownerId,
    this.deadline,
    this.category,
  });

  factory ProjectListItemDto.fromJson(Map<String, dynamic> json) =>
      _$ProjectListItemDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectListItemDtoToJson(this);
}
