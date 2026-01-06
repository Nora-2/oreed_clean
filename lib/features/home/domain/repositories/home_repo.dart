import 'package:oreed_clean/features/home/domain/entities/banner_entity.dart';
import 'package:oreed_clean/features/home/domain/entities/category_entity.dart';
import 'package:oreed_clean/features/home/domain/entities/product_entity.dart';
import 'package:oreed_clean/core/utils/either.dart';
import 'package:oreed_clean/core/error/failures.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
  Future<Either<Failure, List<ProductEntity>>> getProducts();
  Future<Either<Failure, List<BannerEntity>>> getBanners({String? place, int? sectionId});
}