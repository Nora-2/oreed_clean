class SubSubcategoryAdEntity {
  final int id;
  final String title;
  final String? image;
  final String? price;
  final int visit;
  final String status;
  final String adType;
  final DateTime createdAt;

  const SubSubcategoryAdEntity({
    required this.id,
    required this.title,
    this.image,
    this.price,
    required this.visit,
    required this.status,
    required this.adType,
    required this.createdAt,
  });
}