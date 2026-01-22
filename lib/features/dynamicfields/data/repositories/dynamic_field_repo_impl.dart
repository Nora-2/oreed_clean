
import 'package:oreed_clean/features/dynamicfields/data/datasources/dynamic_fields_remote_datasource.dart';
import 'package:oreed_clean/features/dynamicfields/domain/entities/dynamic_field_entity.dart';
import 'package:oreed_clean/features/dynamicfields/domain/repositories/dynamic_fields_repository.dart';

class DynamicFieldsRepositoryImpl implements DynamicFieldsRepository {
  final DynamicFieldsRemoteDataSource remote;

  DynamicFieldsRepositoryImpl(this.remote);

  @override
  Future<List<DynamicFieldEntity>> getDynamicFields(int sectionId) {
    return remote.getDynamicFields(sectionId);
  }
}