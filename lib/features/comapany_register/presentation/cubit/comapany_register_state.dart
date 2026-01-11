
import 'package:equatable/equatable.dart';
import 'package:oreed_clean/features/comapany_register/domain/entities/category_entity.dart';
import 'package:oreed_clean/features/comapany_register/domain/entities/country_entity.dart';
import 'package:oreed_clean/features/comapany_register/domain/entities/register_response_entity.dart';
import 'package:oreed_clean/features/comapany_register/domain/entities/state_entity.dart';
import 'package:oreed_clean/features/home/domain/entities/section_entity.dart';

enum RegisterStatus { idle, loading, success, error }

class CompanyRegisterState extends Equatable {
  final RegisterStatus status;
  final String? error;
  final List<CountryEntity> countries;
  final List<StateEntity> states;
  final List<CategoryEntity> categoriesCars;
  final List<CategoryEntity> categoriesProperties;
  final List<CategoryEntity> categoriesTechnicians;
  final List<CategoryEntity> categoriesAnyThing;
  final List<SectionEntity> sections;
  final RegisterResponseEntity? response;

  const CompanyRegisterState({
    this.status = RegisterStatus.idle,
    this.error,
    this.countries = const [],
    this.states = const [],
    this.categoriesCars = const [],
    this.categoriesProperties = const [],
    this.categoriesTechnicians = const [],
    this.categoriesAnyThing = const [],
    this.sections = const [],
    this.response,
  });

  CompanyRegisterState copyWith({
    RegisterStatus? status,
    String? error,
    List<CountryEntity>? countries,
    List<StateEntity>? states,
    List<CategoryEntity>? categoriesCars,
    List<CategoryEntity>? categoriesProperties,
    List<CategoryEntity>? categoriesTechnicians,
    List<CategoryEntity>? categoriesAnyThing,
    List<SectionEntity>? sections,
    RegisterResponseEntity? response,
  }) {
    return CompanyRegisterState(
      status: status ?? this.status,
      error: error ?? this.error,
      countries: countries ?? this.countries,
      states: states ?? this.states,
      categoriesCars: categoriesCars ?? this.categoriesCars,
      categoriesProperties: categoriesProperties ?? this.categoriesProperties,
      categoriesTechnicians: categoriesTechnicians ?? this.categoriesTechnicians,
      categoriesAnyThing: categoriesAnyThing ?? this.categoriesAnyThing,
      sections: sections ?? this.sections,
      response: response ?? this.response,
    );
  }

  @override
  List<Object?> get props => [
        status,
        error,
        countries,
        states,
        categoriesCars,
        categoriesProperties,
        categoriesTechnicians,
        categoriesAnyThing,
        sections,
        response,
      ];
}