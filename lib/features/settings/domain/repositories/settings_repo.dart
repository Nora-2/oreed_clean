import 'package:oreed_clean/features/settings/data/models/appsetting_model.dart';
import 'package:oreed_clean/networking/optimized_api_client.dart';

class SettingsRepository {
  final OptimizedApiClient _api = OptimizedApiClient();

  Future<AppSettingsModel> fetchSettings() async {
    final res = await _api.get<AppSettingsModel>(
      '/api/v1/get_settings',
      parser: (json) => AppSettingsModel.fromJson(json),
    );
    if (res.data == null) {
      throw Exception('Empty settings response');
    }
    return res.data!;
  }
}
