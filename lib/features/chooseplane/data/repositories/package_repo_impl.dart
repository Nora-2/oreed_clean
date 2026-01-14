import 'package:oreed_clean/features/chooseplane/data/datasources/packege_remote_datasource.dart';
import 'package:oreed_clean/features/chooseplane/domain/repositories/package_repo.dart';

import '../../domain/entities/package_entity.dart';

class PackageRepositoryImpl implements PackageRepository {
  final PackageRemoteDataSource remote;
  PackageRepositoryImpl(this.remote);

  @override
  Future<List<PackageEntity>> getPackagesByType(String type) {
    return remote.fetchPackagesByType(type);
  }
}