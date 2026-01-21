class Brand {
  final String id;
  final String name;
  final String imageUrl;

  const Brand({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  // اختياري: لو جاي JSON من الباك
  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['id'].toString(),
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }
}
