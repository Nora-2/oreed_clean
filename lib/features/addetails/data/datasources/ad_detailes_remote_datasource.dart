import 'package:oreed_clean/features/addetails/domain/entities/ad_detiles_entity.dart';

import '../../../../../networking/api_provider.dart';

class AdDetailesRemoteDataSource {
  final ApiProvider api;

  AdDetailesRemoteDataSource(this.api);

  String _resolveEndpoint(int sectionId) {
    switch (sectionId) {
      case 1:
        return '/api/v1/get_car/';
      case 2:
        return '/api/v1/get_property/';
      case 3:
        return '/api/v1/get_technician/';
      default:
        return '/api/v1/get_anything/?section_id=$sectionId';
    }
  }

  Future<AdDetailesEntity> fetchAdDetails(int adId, int sectionId) async {
    final endpoint = sectionId > 3
        ? '${_resolveEndpoint(sectionId)}&ad_id=$adId'
        : _resolveEndpoint(sectionId) + adId.toString();
    final res = await api.get(endpoint, parser: (json) => json);
    final data = res.data?['data'] ?? {};
    return AdDetailesEntity.fromJson(data);
  }
}
