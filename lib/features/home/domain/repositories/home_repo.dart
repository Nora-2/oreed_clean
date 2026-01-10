
import '../entities/related_ad_entity.dart';
import '../entities/section_entity.dart';

abstract class MainHomeRepository {
  Future<List<SectionEntity>> getSections(int? companyId);
  Future<List<RelatedAdEntity>> getRelatedAds({
    required int sectionId,
    int page = 1,
    int perPage = 10,
  });
}
