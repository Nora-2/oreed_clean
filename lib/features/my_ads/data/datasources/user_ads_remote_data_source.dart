import 'package:oreed_clean/features/my_ads/data/models/user_ads_model.dart';
import 'package:oreed_clean/networking/dio_client.dart';

abstract class UserAdsRemoteDataSource {
  Future<List<UserAdModel>> getUserAds(int userId, {int page = 1});
}

class UserAdsRemoteDataSourceImpl implements UserAdsRemoteDataSource {
  final DioClient _client;

  UserAdsRemoteDataSourceImpl(this._client);

  @override
  Future<List<UserAdModel>> getUserAds(int userId, {int page = 1}) async {
    final result = await _client.get<List<UserAdModel>>(
      '/api/v1/adsByUserId',
      queryParameters: {
        'user_id': userId,
        'paginate': 'enabled',
        'per_page': 20, // Reduced from 100 for memory optimization
        'page': page,
      },
      converter: (response) {
        final List data = response['data'] ?? [];
        return data.map((e) => UserAdModel.fromJson(e)).toList();
      },
    );

    return result.fold(
      (failure) => throw failure as Object, // Repository will catch this
      (data) => data,
    );
  }
}
