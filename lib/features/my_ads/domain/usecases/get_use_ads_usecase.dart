import 'package:oreed_clean/core/usecases/usecase.dart';
import 'package:oreed_clean/features/my_ads/domain/repositories/user_Ads_repo.dart';
import 'package:oreed_clean/networking/result.dart';
import '../entities/user_ad_entity.dart';

class GetUserAdsParams {
  final int userId;
  final int page;

  GetUserAdsParams({required this.userId, this.page = 1});
}

class GetUserAdsUseCase extends UseCase<List<UserAdEntity>, GetUserAdsParams> {
  final UserAdsRepository repository;

  GetUserAdsUseCase(this.repository);

  @override
  Future<Result<List<UserAdEntity>>> call(GetUserAdsParams params) async {
    return await repository.getUserAds(params.userId, page: params.page);
  }
}
