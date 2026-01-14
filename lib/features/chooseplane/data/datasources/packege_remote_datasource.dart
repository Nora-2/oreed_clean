import '../../../../networking/api_provider.dart';
import '../../domain/entities/package_entity.dart';

class PackageRemoteDataSource {
  final ApiProvider api;
  PackageRemoteDataSource(this.api);

  Future<List<PackageEntity>> fetchPackagesByType(String type) async {
    final res = await api.get('/api/get_package/$type', parser: (json) => json);
    final list = (res.data?['data'] as List?) ?? [];
    return list.map((e) => PackageEntity.fromJson(e)).toList();
  }
}