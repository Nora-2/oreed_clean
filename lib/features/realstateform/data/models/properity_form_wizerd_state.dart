import 'dart:io';

/// Centralized wizard state model for real estate property form
/// Encapsulates all form fields across 3 steps with serialization support
class PropertyFormWizardState {
  // ===== STEP 1: Basic Information =====
  String titleAr;
  String priceStr;
  String? countryId;
  int? selectedCountryId;
  String? stateId;
  int? selectedStateId;
  String? estateType;

  // ===== STEP 2: Details & Specifications =====
  String? rooms;
  String? bathrooms;
  String areaStr;
  String? floor;
  String descriptionAr;
  String addressAr;

  // ===== STEP 3: Images =====
  ImageSlot? mainImage;
  List<ImageSlot> galleryImages;

  PropertyFormWizardState({
    this.titleAr = '',
    this.priceStr = '',
    this.countryId,
    this.selectedCountryId,
    this.stateId,
    this.selectedStateId,
    this.estateType,
    this.rooms,
    this.bathrooms,
    this.areaStr = '',
    this.floor,
    this.descriptionAr = '',
    this.addressAr = '',
    this.mainImage,
    List<ImageSlot>? galleryImages,
  }) : galleryImages = galleryImages ?? [];

  /// Create a copy with modified fields (for immutable updates)
  PropertyFormWizardState copyWith({
    String? titleAr,
    String? priceStr,
    String? countryId,
    int? selectedCountryId,
    String? stateId,
    int? selectedStateId,
    String? estateType,
    String? rooms,
    String? bathrooms,
    String? areaStr,
    String? floor,
    String? descriptionAr,
    String? addressAr,
    ImageSlot? mainImage,
    List<ImageSlot>? galleryImages,
  }) {
    return PropertyFormWizardState(
      titleAr: titleAr ?? this.titleAr,
      priceStr: priceStr ?? this.priceStr,
      countryId: countryId ?? this.countryId,
      selectedCountryId: selectedCountryId ?? this.selectedCountryId,
      stateId: stateId ?? this.stateId,
      selectedStateId: selectedStateId ?? this.selectedStateId,
      estateType: estateType ?? this.estateType,
      rooms: rooms ?? this.rooms,
      bathrooms: bathrooms ?? this.bathrooms,
      areaStr: areaStr ?? this.areaStr,
      floor: floor ?? this.floor,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      addressAr: addressAr ?? this.addressAr,
      mainImage: mainImage ?? this.mainImage,
      galleryImages: galleryImages ?? this.galleryImages,
    );
  }

  /// Check if all required fields in step 1 are filled
  bool isStep1Valid() {
    return titleAr.trim().isNotEmpty &&
        titleAr.trim().length >= 5 &&
        priceStr.trim().isNotEmpty &&
        _isPositiveNumber(priceStr) &&
        selectedCountryId != null &&
        selectedStateId != null;
  }

  /// Check if all required fields in step 2 are filled
  bool isStep2Valid() {
    return rooms != null &&
        rooms!.trim().isNotEmpty &&
        bathrooms != null &&
        bathrooms!.trim().isNotEmpty &&
        areaStr.trim().isNotEmpty &&
        _isPositiveNumber(areaStr) &&
        floor != null &&
        floor!.trim().isNotEmpty &&
        descriptionAr.trim().isNotEmpty &&
        descriptionAr.trim().length >= 20;
  }

  /// Check if at least one image is present for step 3
  bool isStep3Valid() {
    return mainImage?.file != null ||
        mainImage?.url != null ||
        galleryImages.isNotEmpty;
  }

  /// Validate a single positive number field
  bool _isPositiveNumber(String? v) {
    if (v == null) return false;
    final t = v.trim();
    if (t.isEmpty) return false;
    final n = num.tryParse(t.replaceAll(',', ''));
    return n != null && n > 0;
  }

  /// Reset all wizard state
  void reset() {
    titleAr = '';
    priceStr = '';
    countryId = null;
    selectedCountryId = null;
    stateId = null;
    selectedStateId = null;
    estateType = null;
    rooms = null;
    bathrooms = null;
    areaStr = '';
    floor = null;
    descriptionAr = '';
    addressAr = '';
    mainImage = null;
    galleryImages.clear();
  }
}

/// Represents a single image slot (file or URL)
class ImageSlot {
  final File? file;
  final String? url;
  final int? imageId;

  ImageSlot({this.file, this.url, this.imageId});

  bool get hasContent => file != null || url != null;

  ImageSlot copyWith({File? file, String? url, int? imageId}) {
    return ImageSlot(
      file: file ?? this.file,
      url: url ?? this.url,
      imageId: imageId ?? this.imageId,
    );
  }
}
