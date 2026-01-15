import 'package:oreed_clean/features/comapany_register/domain/entities/country_entity.dart';
import 'package:oreed_clean/features/comapany_register/domain/entities/state_entity.dart';

abstract class LocationRepository {
  Future<List<CountryEntity>> getStates(int countryId);
  Future<List<StateEntity>> getCities(int stateId);
}
