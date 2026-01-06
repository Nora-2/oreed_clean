class CategoryEntity {
  final String id;
  final String name;
  final String icon;
  final String? image;

  CategoryEntity({
    required this.id,
    required this.name,
    required this.icon,
    this.image,
  });
}