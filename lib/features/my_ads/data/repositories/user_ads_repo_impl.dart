
import 'package:oreed_clean/core/error/failures.dart';
import 'package:oreed_clean/features/my_ads/domain/repositories/user_Ads_repo.dart';
import 'package:oreed_clean/networking/result.dart';
import '../../domain/entities/user_ad_entity.dart';
import '../datasources/user_ads_remote_data_source.dart';

class UserAdsRepositoryImpl implements UserAdsRepository {
  final UserAdsRemoteDataSource remoteDataSource;

  UserAdsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<List<UserAdEntity>>> getUserAds(int userId,
      {int page = 1}) async {
    try {
      final remoteAds = await remoteDataSource.getUserAds(userId, page: page);
      return Success(remoteAds);
    } on Failure catch (failure) {
      return Error(failure);
    } catch (e) {
      return Error(UnknownFailure(e.toString()));
    }
  }
}
