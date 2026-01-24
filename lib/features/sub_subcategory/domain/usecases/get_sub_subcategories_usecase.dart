import '../entities/sub_subcategory_entity.dart';
import '../repositories/sub_subcategory_repository.dart';

class GetSubSubcategoriesUseCase {
  final SubSubcategoryRepository repository;

  GetSubSubcategoriesUseCase(this.repository);

  Future<List<SubSubcategoryEntity>> call(int categoryId) {
    return repository.getSubSubcategories(categoryId);
  }
}