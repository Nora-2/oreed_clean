import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:oreed_clean/features/dynamicfields/data/models/dynamic_field_model.dart';
import 'package:oreed_clean/networking/api_provider.dart';

class DynamicFieldsRemoteDataSource {
  static const _baseUrl = '${ApiProvider.baseUrl}/api/v1';

  Future<List<DynamicFieldModel>> getDynamicFields(int sectionId) async {
    final uri = Uri.parse('$_baseUrl/get_columns?section_id=$sectionId');
    final response =
        await http.get(uri, headers: {'Accept': 'application/json'});
    print(response.request!.url.toString());
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final Map<String, dynamic> fields =
          decoded['data']['dynamicFields'] ?? {};
      return fields.entries.map((e) => DynamicFieldModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load dynamic fields');
    }
  }
}
