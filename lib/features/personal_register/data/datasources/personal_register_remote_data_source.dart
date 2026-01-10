import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:oreed_clean/features/personal_register/data/models/register_response_model.dart';
import '../../../../networking/api_provider.dart';
class PersonalRegisterRemoteDataSource {
  final ApiProvider apiProvider;

  PersonalRegisterRemoteDataSource(this.apiProvider);

  Future<RegisterResponseModel> registerPersonal({
    required String name,
    required String phone,
    required String password,
    required String fcmToken,
  }) async {
    String? token = await FirebaseMessaging.instance.getToken();

    final response = await apiProvider.post(
      '/api/register',
      {
        'business_name_ar': name,
        'phone': phone,
        'password': password,
        'account_type': 'personal',
        'fcm_token': token,
      },
    );

    return RegisterResponseModel.fromJson(response.data);
  }
}
