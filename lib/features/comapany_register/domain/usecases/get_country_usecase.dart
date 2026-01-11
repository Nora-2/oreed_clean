import 'package:oreed_clean/features/comapany_register/domain/repositories/company_register_repo.dart';
import '../entities/country_entity.dart';

class GetCountriesUseCase {
  final CompanyRegisterRepository repository;
  GetCountriesUseCase(this.repository);

  Future<List<CountryEntity>> call() => repository.getCountries();
}