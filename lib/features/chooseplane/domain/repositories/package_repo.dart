import '../entities/package_entity.dart';

abstract class PackageRepository {
  Future<List<PackageEntity>> getPackagesByType(String type);
}