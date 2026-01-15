import 'package:oreed_clean/features/comapany_register/domain/entities/country_entity.dart';
import 'package:oreed_clean/features/comapany_register/domain/entities/state_entity.dart';
import 'package:oreed_clean/features/location_selector/domain/repositories/location_repo.dart';

import '../datasources/location_remote_data_source.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationRemoteDataSource remote;

  LocationRepositoryImpl(this.remote);

  @override
  Future<List<CountryEntity>> getStates(int countryId) {
    return remote.getStates(countryId);
  }

  @override
  Future<List<StateEntity>> getCities(int stateId) {
    return remote.getCities(stateId);
  }
}
