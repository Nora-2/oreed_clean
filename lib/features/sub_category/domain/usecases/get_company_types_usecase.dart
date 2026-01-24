import '../entities/company_type_entity.dart';
import '../repositories/sub_category_repository.dart';

class GetCompanyTypesUseCase {
  final SubCategoryRepository repository;
  GetCompanyTypesUseCase(this.repository);
  Future<List<CompanyTypeEntity>> call(int sectionId) =>
      repository.getCompanyTypes(sectionId);
}