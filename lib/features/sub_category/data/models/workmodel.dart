import 'dart:convert';

import 'package:oreed_clean/features/sub_category/data/models/pivot_model.dart';

class Work {
  Work({
    this.id,
    this.specializationId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.name,
    this.pivot,
  });

  final int? id;
  final String? specializationId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final String? name;
  final Pivot? pivot;

  Work copyWith({
    int? id,
    String? specializationId,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic deletedAt,
    String? name,
    Pivot? pivot,
  }) =>
      Work(
        id: id ?? this.id,
        specializationId: specializationId ?? this.specializationId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt ?? this.deletedAt,
        name: name ?? this.name,
        pivot: pivot ?? this.pivot,
      );

  factory Work.fromJson(String str) => Work.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Work.fromMap(Map<String, dynamic> json) => Work(
        id: json["id"],
        specializationId: json["specialization_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        name: json["name"],
        pivot: json["pivot"] == null ? null : Pivot.fromMap(json["pivot"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "specialization_id": specializationId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "name": name,
        "pivot": pivot?.toMap(),
      };
}
