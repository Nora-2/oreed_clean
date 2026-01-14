import 'package:oreed_clean/features/chooseplane/domain/entities/package_entity.dart';

import '../../../../networking/api_provider.dart';

class PackagesRemoteDataSource {
  final ApiProvider api;
  PackagesRemoteDataSource(this.api);

  Future<List<PackageEntity>> fetchPackages() async {
    final res = await api.get('/api/get_packages', parser: (json) => json);
    final list = res.data?['data'] as List? ?? [];
    return list.map((e) => PackageEntity.fromJson(e)).toList();
  }
}