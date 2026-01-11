import 'dart:io';

class CompanyEntity {
  final String nameAr;
  final String nameEn;
  final int userId;
  final File image;

  const CompanyEntity({
    required this.nameAr,
    required this.nameEn,
    required this.userId,
    required this.image,
  });
}