import 'package:oreed_clean/core/error/failures.dart';
import 'package:oreed_clean/core/utils/either.dart';
import 'package:oreed_clean/features/home/domain/entities/category_entity.dart';
import 'package:oreed_clean/features/home/domain/repositories/home_repo.dart';


class GetCategoriesUseCase {
  final HomeRepository repository;

  GetCategoriesUseCase(this.repository);

  Future<Either<Failure, List<CategoryEntity>>> call() {
    return repository.getCategories();
  }
}