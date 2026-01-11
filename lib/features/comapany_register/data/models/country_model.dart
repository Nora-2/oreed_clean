import '../../domain/entities/country_entity.dart';

class CountryModel extends CountryEntity {
  const CountryModel({required super.id, required super.name});

  factory CountryModel.fromJson(Map<String, dynamic> json) => CountryModel(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
      );
}
