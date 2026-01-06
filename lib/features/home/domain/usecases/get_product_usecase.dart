import 'package:oreed_clean/core/error/failures.dart';
import 'package:oreed_clean/core/utils/either.dart';
import 'package:oreed_clean/features/home/domain/entities/product_entity.dart';
import 'package:oreed_clean/features/home/domain/repositories/home_repo.dart';

class GetProductsUseCase {
  final HomeRepository repository;

  GetProductsUseCase(this.repository);

  Future<Either<Failure, List<ProductEntity>>> call() {
    return repository.getProducts();
  }
}