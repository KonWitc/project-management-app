import 'package:json_annotation/json_annotation.dart';

part 'milestone_dto.g.dart';

@JsonSerializable()
class MilestoneDto {
  final String id;
  final String name;
  final String? description;
  final String status;
  final DateTime? dueDate;
  final int? progress; // 0–100 %

  MilestoneDto({
    required this.id,
    required this.name,
    this.description,
    required this.status,
    this.dueDate,
    this.progress,
  });

  factory MilestoneDto.fromJson(Map<String, dynamic> json) =>
      _$MilestoneDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MilestoneDtoToJson(this);
}
