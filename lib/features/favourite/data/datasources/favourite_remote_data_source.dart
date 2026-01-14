import 'package:oreed_clean/core/app_shared_prefs.dart';
import 'package:oreed_clean/features/favourite/data/models/favourite_list_response_model.dart';
import 'package:oreed_clean/features/favourite/data/models/favourite_response_mode.dart';
import 'package:oreed_clean/networking/api_pathes.dart';
import 'package:oreed_clean/networking/http_client.dart';

abstract class FavoritesRemoteDataSource {
  Future<FavoriteResponseModel> toggleFavorite({
    required int sectionId,
    required int adId,
  });

  Future<FavoritesListResponseModel> getFavorites(); // ✅ NEW
}

class FavoritesRemoteDataSourceImpl implements FavoritesRemoteDataSource {
  final HttpClientService _http;

  FavoritesRemoteDataSourceImpl(this._http);

  @override
  Future<FavoriteResponseModel> toggleFavorite({
    required int sectionId,
    required int adId,
  }) async {
    final prefs = AppSharedPreferences();
    await prefs.initSharedPreferencesProp();
    final userToken = prefs.getUserToken ?? '';
    final userId = prefs.getUserId ?? 0;
   
    if (userToken.isEmpty || userId == 0) {
      throw Exception('User not logged in or missing credentials');
    }

    // ✅ Perform API call
    final resp = await _http.post(
      ApiPaths.setFavorite,
      headers: {
        'Authorization': 'Bearer $userToken',
        'Accept': 'application/json',
      },
      body: {
        'section_id': sectionId.toString(),
        'ad_id': adId.toString(),
        'user_id': userId.toString(),
      },
    );

    return FavoriteResponseModel.fromJson(resp);
  }

  @override
  Future<FavoritesListResponseModel> getFavorites() async {
    final prefs = AppSharedPreferences();
    await prefs.initSharedPreferencesProp();
    final userToken = prefs.getUserToken ?? '';

    if (userToken.isEmpty) {
      throw Exception('User not logged in');
    }

    final resp = await _http.get(
      ApiPaths.getFavorites,
      headers: {
        'Authorization': 'Bearer $userToken',
        'Accept': 'application/json',
      },
    );

    return FavoritesListResponseModel.fromJson(resp);
  }
}
