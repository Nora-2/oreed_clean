import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:oreed_clean/features/comapany_register/data/models/company_response_model.dart';
import 'package:oreed_clean/features/comapany_register/domain/entities/company_entity.dart';

class CompanyRemoteDataSource {
  static const String baseUrl = 'https://oreedo.net/api/v1';

  Future<CompanyResponseModel> createCompany(CompanyEntity company) async {
    var headers = {'Accept': 'application/json'};
    var request =
        http.MultipartRequest('POST', Uri.parse('$baseUrl/create_company'));

    request.fields.addAll({
      'name_ar': company.nameAr,
      'name_en': company.nameEn,
      'user_id': company.userId.toString(),
    });

    request.files
        .add(await http.MultipartFile.fromPath('image', company.image.path));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    final body = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      return CompanyResponseModel.fromJson(json.decode(body));
    } else {
      throw Exception('Failed to create company: ${response.reasonPhrase}');
    }
  }
}
