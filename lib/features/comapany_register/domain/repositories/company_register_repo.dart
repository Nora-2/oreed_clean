
import 'package:oreed_clean/features/comapany_register/domain/entities/category_entity.dart';
import 'package:oreed_clean/features/comapany_register/domain/entities/register_response_entity.dart';
import 'package:oreed_clean/features/home/domain/entities/section_entity.dart';
import '../entities/country_entity.dart';
import '../entities/state_entity.dart';


abstract class CompanyRegisterRepository {
  Future<List<CountryEntity>> getCountries();
  Future<List<StateEntity>> getStates(int countryId);
  Future<List<CategoryEntity>> getCategoriesBySection(int sectionId);
  Future<RegisterResponseEntity> registerCompany(Map<String, dynamic> body);
  Future<List<SectionEntity>> getSections();
}