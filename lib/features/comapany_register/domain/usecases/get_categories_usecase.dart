import 'package:oreed_clean/features/comapany_register/domain/entities/category_entity.dart';
import 'package:oreed_clean/features/comapany_register/domain/repositories/company_register_repo.dart';

class GetCategoriesUseCase {
  final CompanyRegisterRepository repository;
  GetCategoriesUseCase(this.repository);

  Future<List<CategoryEntity>> call(int sectionId) => repository.getCategoriesBySection(sectionId);
}