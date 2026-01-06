class ProductEntity {
  final String id;
  final String name;
  final String image;
  final double price;
  final String category;
   final String government;
  final String city;
  final DateTime createdAt;

  ProductEntity( {
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.category,
    required this.government,
    required this.city,
    required this.createdAt,
  });
}