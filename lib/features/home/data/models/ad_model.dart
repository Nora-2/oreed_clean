import 'dart:convert';

class AdModel {
  AdModel({
    this.id,
    this.type,
    this.countryId,
    this.userId,
    this.link,
    this.createdAt,
    this.updatedAt,
    this.title,
    this.image,
    this.description,
    
  });

  final int? id; // Keep as int
  final String? type;
  final String? countryId;
  final String? userId;
  final String? link;
  final DateTime? createdAt; // Keep as DateTime
  final DateTime? updatedAt; // Keep as DateTime
  final String? title;
  final String? image;
  final String? description;

  AdModel copyWith({
    int? id,
    String? type,
    String? countryId,
    String? userId,
    String? link,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? title,
    String? image,
    String? description,
  }) =>
      AdModel(
        id: id ?? this.id,
        type: type ?? this.type,
        countryId: countryId ?? this.countryId,
        userId: userId ?? this.userId,
        link: link ?? this.link,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        title: title ?? this.title,
        image: image ?? this.image,
        description: description ?? this.description,
      );

  factory AdModel.fromRawJson(String str) =>
      AdModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AdModel.fromJson(Map<String, dynamic> json) => AdModel(
    id: json["id"],
    type: json["type"]?.toString(),
    countryId: json["country_id"]?.toString(),
    userId: json["user_id"]?.toString(),
    link: json["link"]?.toString(),
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    title: json["title"]?.toString(),
    image: json["image"]?.toString(),
    description: json["description"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "id": id, // Keep as int
    "type": type,
    "country_id": countryId,
    "user_id": userId,
    "link": link,
    "created_at": createdAt?.toIso8601String(), // Keep as DateTime
    "updated_at": updatedAt?.toIso8601String(), // Keep as DateTime
    "title": title,
    "image": image,
    "description": description,
  };
}
