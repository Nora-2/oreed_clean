
import 'package:oreed_clean/features/home/data/models/related_ad_model.dart';
import 'package:oreed_clean/networking/api_provider.dart';

import '../../domain/entities/related_ad_entity.dart';
import '../models/section_model.dart';

class MainHomeRemoteDataSource {
  final ApiProvider apiProvider;

  MainHomeRemoteDataSource(this.apiProvider);

  Future<List<SectionModel>> fetchSections(int? companyId) async {
    String endpoint = '';
    if (companyId != null) {
      endpoint = "/api/get_sections?companies=1";
    } else {
      endpoint = "/api/get_sections";
    }

    final response = await apiProvider.get(endpoint, parser: (json) => json);
    final data = response.data?['data'] as List? ?? [];
    final sections = data.map((e) => SectionModel.fromJson(e)).toList();

    return sections;
  }



  Future<List<RelatedAdEntity>> getRelatedAds({
    required int sectionId,
    int page = 1,
    int perPage = 100,
  }) async {
    try {
      final response = await apiProvider.get(
        '/api/advanced_filter?section_id=$sectionId&is_random=1&paginate=enabled&per_page=$perPage&page=$page',
        parser: (json) => json,
      );

      final List data = response.data?['data'] ?? [];



      return data.map((e) {
        return RelatedAdModel.fromJson(e);
      }).toList();
    } catch (e) {
      // If 404 with "No ads found" message, return empty list instead of throwing
      if (e.toString().contains('No ads found') ||
          e.toString().contains('404')) {
        return [];
      }
      // Re-throw other errors
      rethrow;
    }
  }
}
