import '../entities/sub_category_entity.dart';
import '../repositories/sub_category_repository.dart';

class GetSubCategoriesUseCase {
  final SubCategoryRepository repository;
  GetSubCategoriesUseCase(this.repository);
  Future<List<SubCategoryEntity>> call(int sectionId) =>
      repository.getSubCategories(sectionId);
}