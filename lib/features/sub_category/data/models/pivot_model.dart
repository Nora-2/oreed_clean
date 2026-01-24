class Pivot {
  Pivot({
    this.userId,
    this.certificateId,
    this.cost,
    this.createdAt,
    this.updatedAt,
  });

  final String? userId;
  final String? certificateId;
  final String? cost;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Pivot copyWith({
    String? userId,
    String? certificateId,
    String? cost,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Pivot(
        userId: userId ?? this.userId,
        certificateId: certificateId ?? this.certificateId,
        cost: cost ?? this.cost,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Pivot.fromMap(Map<String, dynamic> json) => Pivot(
        userId: json["user_id"],
        certificateId: json["certificate_id"],
        cost: json["cost"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toMap() => {
        "user_id": userId,
        "certificate_id": certificateId,
        "cost": cost,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
