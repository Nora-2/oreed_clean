import 'package:oreed_clean/features/home/data/datasources/home_remote_datasource.dart';
import 'package:oreed_clean/features/home/domain/repositories/home_repo.dart';

import '../../domain/entities/related_ad_entity.dart';
import '../../domain/entities/section_entity.dart';

class MainHomeRepositoryImpl implements MainHomeRepository {
  final MainHomeRemoteDataSource remote;

  MainHomeRepositoryImpl(this.remote);

  @override
  Future<List<SectionEntity>> getSections(int? companyId) =>
      remote.fetchSections(companyId);


  @override
  Future<List<RelatedAdEntity>> getRelatedAds({
    required int sectionId,
    int page = 1,
    int perPage = 10,
  }) {
    return remote.getRelatedAds(
      sectionId: sectionId,
      page: page,
      perPage: perPage,
    );
  }
}
