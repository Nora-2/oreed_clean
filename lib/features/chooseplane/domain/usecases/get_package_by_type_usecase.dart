import 'package:oreed_clean/features/chooseplane/domain/repositories/package_repo.dart';
import '../entities/package_entity.dart';

class GetPackagesByTypeUseCase {
  final PackageRepository repository;
  GetPackagesByTypeUseCase(this.repository);

  Future<List<PackageEntity>> call(String type) {
    return repository.getPackagesByType(type);
  }
}