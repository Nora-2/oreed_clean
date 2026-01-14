import 'package:oreed_clean/features/addetails/domain/entities/ad_detiles_entity.dart';

abstract class AdDetailesRepository {
  Future<AdDetailesEntity> getAdDetails(int adId, int sectionId);
}
