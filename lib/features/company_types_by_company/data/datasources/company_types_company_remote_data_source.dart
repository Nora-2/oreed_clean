import 'package:oreed_clean/features/company_types_by_company/domain/entities/company_types_entity.dart';
import 'package:oreed_clean/networking/api_provider.dart';

class CompanyTypesCompanyRemoteDataSource {
  final ApiProvider apiProvider;

  CompanyTypesCompanyRemoteDataSource(this.apiProvider);

  Future<List<CompanyTypeCompanyEntity>> fetchCompanyTypesByCompany(
    String companyId,
    Map? filter,
  ) async {
    final buffer = StringBuffer('/api/company_types_company/$companyId?');

    if (filter != null && filter.isNotEmpty) {
      filter.forEach((key, value) {
        if (value != null && value.toString().isNotEmpty) {
          final encodedKey = Uri.encodeQueryComponent(key);
          final encodedValue = Uri.encodeQueryComponent(value.toString());
          buffer.write('&$encodedKey=$encodedValue');
        }
      });
    }
    print(filter);
    final url = buffer.toString();
    print(url);
    final res = await apiProvider.get(url, parser: (json) => json);

    final list = res.data?['data'] as List? ?? [];
    return list
        .map(
          (e) => CompanyTypeCompanyEntity(
            id: e['id'] ?? 0,
            name: e['name'] ?? '',
            image: e['image'] ?? '',
          ),
        )
        .toList();
  }
}
