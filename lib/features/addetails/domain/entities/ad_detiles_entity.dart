class AdDetailesEntity {
  final int id;
  final int sectionId; // 1=Car, 2=Property, 3=Technician, 4=Other
  final String title;
  final String description;
  final String price;
  final String mainImage;
  final String cityName;
  final String stateName;
  final String phone;
  final String adType;
  final String visit;
  final List<String> media;
  final Map<String, dynamic> extra;

  const AdDetailesEntity({
    required this.id,
    required this.sectionId,
    required this.title,
    required this.adType,
    required this.visit,
    required this.cityName,
    required this.stateName,
    required this.description,
    required this.phone,
    required this.price,
    required this.mainImage,
    required this.media,
    required this.extra,
  });

  factory AdDetailesEntity.fromJson(Map<String, dynamic> data) {
    // Common fields
    final media =
        (data['media'] as List?)
            ?.map((e) => e['original_url'].toString())
            .toList() ??
        [];

    final common = <String, dynamic>{
      'user_name': data['user_name'],
      'user_phone': data['user_phone'],
      'state_id': data['state_id'],
      'city_id': data['city_id'],
      'created_at': data['created_at'],
    };

    final sectionId = data['section_id'] ?? 0;

    // Type-specific fields
    switch (sectionId) {
      case 1: // Car
        common.addAll({
          'color': data['color'] ?? '-',
          'year': data['year'] ?? '-',
          'kilometers': data['kilometers'] ?? '-',
          'fuel_type': data['fuel_type'] ?? '-',
          'transmission': data['transmission'] ?? '-',
          'car_document': data['car_documents'],
          'car_model_name': data['car_model_name'] ?? '-',
          'car_marka_name': data['brand_name'] ?? '-',
          'engine_size': data['engine_size'] ?? '-',
          'condition': data['condition'] ?? '-',
        });
        break;
      case 2: // Property
        common.addAll({
          'rooms': data['rooms'] ?? '-',
          'bathrooms': data['bathrooms'] ?? '-',
          'area': data['area'] ?? '-',
          'floor': data['floor'] ?? '-',
          'type': data['type'] ?? '-',
          'address': data['address'] ?? '-',
          'sub_category_name': data['sub_category_name'] ?? '-',
        });
        break;
      case 3: // Technician
        common.addAll({
          'speciality': data['category_name'],
          'instagram': data['link_1'],
          'facebook': data['link_2'],
          // 'experience_years': data['experience_years'],
          // 'availability': data['availability'],
        });
        break;
      default:
        common.addAll({
          'price_before_discount': data['price_before_discount'],
          'condition': data['condition'],
          'color': data['color'],
          'model': data['model'],
          'area': data['area'],
          'size': data['size'],
          'age': data['age'],
          'new_or_used': data['new_or_used'],
          'instagram': data['instagram'],
          'facebook': data['facebook'],
          'section': data['section_name'],
          'category_name': data['category_name'],
        });
    }

    return AdDetailesEntity(
      id: data['id'] ?? 0,
      sectionId: sectionId,
      title: data['title'] ?? data['name'] ?? '',
      description: data['description'] ?? '',
      price: data['price']?.toString() ?? '',
      adType: data['current_type'] ?? '',
      mainImage: data['main_image'] ?? '',
      media: media,
      extra: common,
      cityName: data['city_name'],
      stateName: data['state_name'],
      visit: data['visit'].toString(),
      phone: data['user_phone'].toString(),
    );
  }
}
