import 'package:oreed_clean/features/comapany_register/domain/repositories/company_register_repo.dart';
import '../entities/state_entity.dart';
class GetStatesUseCase {
  final CompanyRegisterRepository repository;
  GetStatesUseCase(this.repository);

  Future<List<StateEntity>> call(int countryId) => repository.getStates(countryId);
}