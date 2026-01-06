import 'package:oreed_clean/core/error/failures.dart';
import 'package:oreed_clean/core/utils/either.dart';
import 'package:oreed_clean/features/home/domain/entities/banner_entity.dart';
import 'package:oreed_clean/features/home/domain/repositories/home_repo.dart';

class GetBannersUseCase {
  final HomeRepository repository;

  GetBannersUseCase(this.repository);

  Future<Either<Failure, List<BannerEntity>>> call() {
    return repository.getBanners();
  }
}