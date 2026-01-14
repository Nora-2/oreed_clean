import '../entities/package_entity.dart';

abstract class PackagesRepository {
  Future<List<PackageEntity>> getPackages();
}