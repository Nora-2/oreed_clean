import 'package:oreed_clean/features/chooseplane/domain/repositories/packages_repo.dart';
import '../../domain/entities/package_entity.dart';
import '../datasources/packages_remote_data_source.dart';

class PackagesRepositoryImpl implements PackagesRepository {
  final PackagesRemoteDataSource remote;
  PackagesRepositoryImpl(this.remote);

  @override
  Future<List<PackageEntity>> getPackages() => remote.fetchPackages();
}