// lib/repository/profile_repository.dart
import 'package:oreed_clean/networking/optimized_api_client.dart';
import 'package:oreed_clean/networking/response.dart';

class ProfileRepository {
  final OptimizedApiClient _apiProvider = OptimizedApiClient();

  static final ProfileRepository _instance = ProfileRepository._internal();

  factory ProfileRepository() => _instance;

  ProfileRepository._internal();

  /// Edit profile - updates business_name_ar (company) or name (user)
  /// Returns: Response with success message
  Future<Response<dynamic>> editProfile({
    required String name,
    String? phone,
    String? logo,
  }) async {
    final body = <String, dynamic>{
      'business_name_ar': name,
    };

    if (phone != null && phone.isNotEmpty) {
      body['phone'] = phone;
    }

    if (logo != null && logo.isNotEmpty) {
      body['logo'] = logo;
    }

    final response = await _apiProvider.post(
      "/api/edit_profile",
      body,
      hasToken: true,
    );
    return response;
  }

  /// Verify phone number with OTP
  Future<Response<dynamic>> verifyPhone({
    required String phone,
    required String otp,
  }) async {
    final body = {
      "phone": phone,
      "otp": otp,
    };

    final response = await _apiProvider.post(
      "/api/verify_phone",
      body,
      hasToken: true,
    );
    return response;
  }
}

