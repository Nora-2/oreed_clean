// features/favorites/data/models/favorite_item_model.dart
class FavoriteItemModel {
  final int id;
  final int sectionId;
  final String title;
  final String imageUrl;
  final String price; // keep as string (API sends "5649.00" / "125")
  final int visit;
  final String status; // "pending" | "accepted"...
  final String adType; // "free"...
  final String? stateName;
  final String? cityName;
  final String sectionName; // "السيارات" / "بيع ملابس"...
  final String baseSection; // "Cars" / "Anything"
  final DateTime createdAt;
  final DateTime? expirationAt;

  FavoriteItemModel({
    required this.id,
    required this.sectionId,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.visit,
    required this.status,
    required this.adType,
    required this.stateName,
    required this.cityName,
    required this.sectionName,
    required this.baseSection,
    required this.createdAt,
    required this.expirationAt,
  });

  factory FavoriteItemModel.fromJson(Map<String, dynamic> json) {
    // API sometimes uses "title" (Cars) or "name" (Anything)
    final title = (json['title'] ?? json['name'] ?? '').toString();

    return FavoriteItemModel(
      id: json['id'] as int,
      sectionId: json['section_id'] ?? 0,
      title: title,
      imageUrl: (json['main_image'] ?? '').toString(),
      price: (json['price'] ?? '').toString(),
      visit: int.tryParse('${json['visit']}') ?? 0,
      status: (json['status'] ?? '').toString(),
      adType: (json['ad_type'] ?? '').toString(),
      stateName: json['state_name']?.toString(),
      cityName: json['city_name']?.toString(),
      sectionName: (json['section_name'] ?? '').toString(),
      baseSection: (json['base_section'] ?? '').toString(),
      createdAt: DateTime.tryParse((json['created_at'] ?? '').toString()) ??
          DateTime.now(),
      expirationAt: json['ads_expiration_date'] == null ||
              json['ads_expiration_date'].toString().isEmpty
          ? null
          : DateTime.tryParse(json['ads_expiration_date'].toString()),
    );
  }
}
