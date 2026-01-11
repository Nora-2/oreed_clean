import 'package:oreed_clean/features/comapany_register/domain/entities/comapny_response_entity.dart';
import '../entities/company_entity.dart';

abstract class CompanyRepository {
  Future<CompanyResponseEntity> createCompany(CompanyEntity company);
}
