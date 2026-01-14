class CompanyDetailsEntity {
  final int id;
  final String name;
  final String city;
  final String state;
  final String companyTypeName;
  final String? imageUrl;
  final String? phone;
  final String? whatsapp;
  final String? facebook;
  final String? instagram;
  final String? snapchat;
  final String? tiktok;
  final int visit;

  const CompanyDetailsEntity({
    required this.id,
    required this.name,
    required this.city,
    required this.companyTypeName,
    required this.state,
    required this.phone,
    required this.whatsapp,
    this.imageUrl,
    this.facebook,
    this.snapchat,
    this.tiktok,
    this.instagram,
    this.visit = 0,
  });

  /// Parse comma-separated phone numbers into a list
  List<String> phonesList() {
    if (phone == null || phone!.isEmpty) return [];
    return phone!
        .split(',')
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .toList();
  }
}
