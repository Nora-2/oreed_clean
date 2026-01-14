import 'package:oreed_clean/features/chooseplane/domain/repositories/packages_repo.dart';

import '../entities/package_entity.dart';

class GetPackagesUseCase {
  final PackagesRepository repository;
  GetPackagesUseCase(this.repository);

  Future<List<PackageEntity>> call() => repository.getPackages();
}