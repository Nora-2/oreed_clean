import 'package:oreed_clean/features/realstateform/data/datasources/realstate_remote_data_source.dart';
import 'package:oreed_clean/features/realstateform/domain/entities/real_state_response_entity.dart';
import 'package:oreed_clean/features/realstateform/domain/entities/realstate_detailes_entity.dart';
import 'package:oreed_clean/features/realstateform/domain/entities/realstate_entity.dart';
import 'package:oreed_clean/features/realstateform/domain/repositories/realstate_repo.dart';

class PropertyRepositoryImpl implements PropertyRepository {
  final PropertyRemoteDataSource remoteDataSource;

  PropertyRepositoryImpl(this.remoteDataSource);

  @override
  Future<PropertyResponseEntity> createProperty(PropertyEntity property) {
    return remoteDataSource.createProperty(property);
  }

  @override
  Future<PropertyDetailsEntity> getDetails(
    int id, {
    String language = 'ar',
  }) async {
    final m = await remoteDataSource.getDetails(id, language: language);
    return m;
  }

  @override
  Future<PropertyResponseEntity> edit(EditPropertyParams params) {
    return remoteDataSource.edit(params);
  }

  @override
  Future<bool> removeImage(int adId, int imageId) {
    return remoteDataSource.removeImage(adId: adId, imageId: imageId);
  }
}
