class CarModel {
  final String id;
  final String name;
  final String? imageUrl; // اختياري لو عندك صور للموديلات

  const CarModel({
    required this.id,
    required this.name,
    this.imageUrl,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: json['id'].toString(),
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String?,
    );
  }
}
