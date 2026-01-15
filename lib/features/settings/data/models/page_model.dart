import 'dart:convert';

class PageModel {
  PageModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.title,
    this.description,
  });

  final int? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final String? title;
  final String? description;

  PageModel copyWith({
    int? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic deletedAt,
    String? title,
    String? description,
  }) => PageModel(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt ?? this.deletedAt,
    title: title ?? this.title,
    description: description ?? this.description,
  );

  factory PageModel.fromRawJson(String str) =>
      PageModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PageModel.fromJson(Map<String, dynamic> json) => PageModel(
    id: json["id"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    title: json["title"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
    "title": title,
    "description": description,
  };
}
