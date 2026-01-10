import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:oreed_clean/features/banners/data/models/banner_mode.dart' show BannerModel;

class BannerRemoteDataSource {
  static const _baseUrl = 'https://oreedo.net/api/v1';

  Future<List<BannerModel>> fetchBanners({required int? sectionId}) async {
    String url1 = '';
    if (sectionId == null) {
      url1 = '$_baseUrl/banners?place=home&paginate=disabled';
    } else {
      url1 =
          '$_baseUrl/banners?place=section&section_id=$sectionId&paginate=disabled';
    }

    final url = Uri.parse(url1);

    final response =
        await http.get(url, headers: {'Accept': 'application/json'});

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List list = decoded['data'] ?? [];
      return list.map((e) => BannerModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load banners');
    }
  }
}
