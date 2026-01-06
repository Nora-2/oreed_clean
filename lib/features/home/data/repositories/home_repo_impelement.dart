import 'package:oreed_clean/features/home/data/datasources/home_remote_datasource.dart';
import 'package:oreed_clean/features/home/domain/entities/banner_entity.dart';
import 'package:oreed_clean/features/home/domain/entities/category_entity.dart';
import 'package:oreed_clean/features/home/domain/entities/product_entity.dart';
import 'package:oreed_clean/features/home/domain/repositories/home_repo.dart';
import 'package:oreed_clean/core/utils/either.dart';
import 'package:oreed_clean/core/error/failures.dart';
import 'package:dio/dio.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    try {
      final categories = await remoteDataSource.getCategories();
      return Right(categories.map((e) => e.toEntity()).toList());
    } on DioException catch (e) {
      return Left(ServerFailure(e.error?.toString() ?? 'Network error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts() async {
    try {
      final products = await remoteDataSource.getProducts();
      return Right(products.map((e) => e.toEntity()).toList());
    } on DioException catch (e) {
      return Left(ServerFailure(e.error?.toString() ?? 'Network error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BannerEntity>>> getBanners({String? place, int? sectionId}) async {
    final usePlace = place ?? 'home';
    try {
      final banners = await remoteDataSource.getBanners(place: usePlace, sectionId: sectionId);
      return Right(banners.map((e) => e.toEntity()).toList());
    } on DioException catch (e) {
      return Left(ServerFailure(e.error?.toString() ?? 'Network error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
