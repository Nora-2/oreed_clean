import 'package:oreed_clean/networking/result.dart';
import '../entities/user_ad_entity.dart';

abstract class UserAdsRepository {
  Future<Result<List<UserAdEntity>>> getUserAds(int userId, {int page = 1});
}
