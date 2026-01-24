
import 'package:oreed_clean/features/sub_category/data/models/workmodel.dart';

class CategoryModel {
  CategoryModel({
    this.id,
    this.parentId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.name,
    this.image,
    this.children,
    this.works,
    this.sectionId,
  });

  final int? id;
  final String? parentId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? deletedAt;
  final String? name;
  final String? image;
  List<CategoryModel>? children;
  final List<Work>? works;
  final int? sectionId;

  CategoryModel copyWith({
    int? id,
    String? parentId,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? deletedAt,
    String? name,
    String? image,
    List<CategoryModel>? children,
    List<Work>? works,
    int? sectionId,
  }) =>
      CategoryModel(
        id: id ?? this.id,
        parentId: parentId ?? this.parentId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt ?? this.deletedAt,
        name: name ?? this.name,
        image: image ?? this.image,
        children: children ?? this.children,
        works: works ?? this.works,
        sectionId: sectionId ?? this.sectionId,
      );

  factory CategoryModel.fromMap(Map<String, dynamic> json) => CategoryModel(
        id: json["id"],
        parentId: json["parent_id"].toString(),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        name: json["name"].toString(),
        image: json["image"].toString(),
        children: json["children"] == null
            ? null
            : List<CategoryModel>.from(
                json["children"].map((x) => CategoryModel.fromMap(x))),
        works: json["works"] == null
            ? null
            : List<Work>.from(json["works"].map((x) => Work.fromMap(x))),
        sectionId: json["section_id"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "parent_id": parentId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "name": name,
        "image": image,
        "children": children == null
            ? null
            : List<dynamic>.from(children!.map((x) => x.toMap())),
        "works": works == null
            ? null
            : List<dynamic>.from(works!.map((x) => x.toMap())),
        "section_id": sectionId,
      };
}
