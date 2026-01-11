import 'package:oreed_clean/features/comapany_register/domain/repositories/company_register_repo.dart';
import 'package:oreed_clean/features/home/domain/entities/section_entity.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/country_entity.dart';
import '../../domain/entities/register_response_entity.dart';
import '../../domain/entities/state_entity.dart';
import '../datasources/company_register_remote_data_source.dart';

class CompanyRegisterRepositoryImpl implements CompanyRegisterRepository {
  final CompanyRegisterRemoteDataSource remote;

  CompanyRegisterRepositoryImpl(this.remote);

  @override
  Future<List<CountryEntity>> getCountries() => remote.fetchCountries();

  @override
  Future<List<StateEntity>> getStates(int countryId) =>
      remote.fetchStates(countryId);

  @override
  Future<List<CategoryEntity>> getCategoriesBySection(int sectionId) =>
      remote.fetchCategoriesBySection(sectionId);

  @override
  Future<RegisterResponseEntity> registerCompany(Map<String, dynamic> body) =>
      remote.registerCompany(body);
  @override
  Future<List<SectionEntity>> getSections() => remote.fetchSections();
}
