enum ViewMode { list, grid }
enum SectionType {
  car,
  property,
  technical,
  normal,
}
enum AdType { free, featured, pinned }

enum ShapeType { rectangle, circle }
enum AccountType {
  company,
  individual,
}
enum AdStatus { idle, loading, success, error }
enum PaymentResult { success, cancelled, failed }
enum Phase { typing, hold, erasing }
enum FavoriteAction { added, removed }
enum ProfileKind { user, company }
enum ImagesTypes { Network, Assest }
enum ImageSourceChoice { camera, gallery }
// lib/core/enums/section_type_enum.dart


extension SectionTypeExtension on SectionType {
  /// 🔹 Get integer ID used in API or DB
  int get id {
    switch (this) {
      case SectionType.car:
        return 1;
      case SectionType.property:
        return 2;
      case SectionType.technical:
        return 3;
      case SectionType.normal:
      return 4;
    }
  }

  /// 🔹 Get Arabic readable label
  String get arabicLabel {
    switch (this) {
      case SectionType.car:
        return 'السيارات';
      case SectionType.property:
        return 'العقارات';
      case SectionType.technical:
        return 'الخدمات الفنية';
      case SectionType.normal:
        return 'عادي';
    }
  }

  /// 🔹 Get English readable label
  String get englishLabel {
    switch (this) {
      case SectionType.car:
        return 'Cars';
      case SectionType.property:
        return 'Properties';
      case SectionType.technical:
        return 'Technical Services';
      case SectionType.normal:
        return 'Normal';
    }
  }

  /// 🔹 Parse from sectionId (used when loading from backend)
  static SectionType fromId(int id) {
    switch (id) {
      case 1:
        return SectionType.car;
      case 2:
        return SectionType.property;
      case 3:
        return SectionType.technical;
      default:
        return SectionType.normal;
    }
  }
}



AdType adTypeFromString(String? value) {
  switch ((value ?? '').toLowerCase()) {
    case 'featured':
      return AdType.featured;
    case 'pinned':
      return AdType.pinned;
    default:
      return AdType.free;
  }
}
