class PropertyEntity {
  final String titleAr;
  final String descriptionAr;
  final String addressAr;
  final int sectionId;
  final int categoryId;
  final int subCategoryId;
  final String price;
  final String rooms;
  final String bathrooms;
  final String area;
  final String floor;
  final String type;
  final int stateId;
  final int cityId;
  final int userId;
  final List<String> imagePaths;
  final int? companyId;
  final int? companyTypeId;

  const PropertyEntity({
    required this.titleAr,
    required this.descriptionAr,
    required this.addressAr,
    required this.sectionId,
    required this.categoryId,
    required this.subCategoryId,
    required this.price,
    required this.rooms,
    required this.bathrooms,
    required this.area,
    required this.floor,
    required this.type,
    required this.stateId,
    required this.cityId,
    required this.userId,
    required this.imagePaths,
    this.companyTypeId,
    this.companyId,
  });
}
