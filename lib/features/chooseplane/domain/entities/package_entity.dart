class PackageEntity {
  final int id;
  final String name;
  final String description;
  final String price;
  final int period;
  final String type;

  const PackageEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.period,
    required this.type,
  });

  factory PackageEntity.fromJson(Map<String, dynamic> json) {
    return PackageEntity(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: json['price']?.toString() ?? '0.00',
      period: json['period'] ?? 0,
      type: json['type'] ?? '',
    );
  }

  bool get isFree => price == '0.00' || type == 'free';
}