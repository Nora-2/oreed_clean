// lib/view/screens/sub_categories/models/company_model.dart
class CompanyModel {
  final String id;
  final String name;
  final String logoUrl;
  final String? governorate; // المحافظة
  final String? city;        // المدينة
  final int? views;           // عدد المشاهدات
  final String? phone;       // رقم الهاتف



  CompanyModel({
    required this.id,
    required this.name,
    required this.logoUrl,
    this.governorate,
    this.city,
    this.views,
    this.phone,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['id'].toString(),
      name: json['name'] ?? 'No Name',
      logoUrl: json['logoUrl'] ?? 'https://via.placeholder.com/150',
      governorate: json['governorate'],   // لازم تكون موجودة في API
      city: json['city'],                   // لازم تكون موجودة في API
      views: json['views'],                 // لازم تكون موجودة في API
    );
  }
}
