import 'package:oreed_clean/features/verification/data/models/otp_response_model.dart';
import 'package:oreed_clean/networking/api_provider.dart';

class CompanyOtpRemoteDataSource {
  final ApiProvider apiProvider;

  CompanyOtpRemoteDataSource(this.apiProvider);

  Future<OtpResponseModel> verifyOtp(String phone, String otp) async {
    final body = {'phone': phone, 'otp': otp};
    final res = await apiProvider.post(
      "/api/complete_registeration",
      body,
      parser: (json) => json,
    );
   
    return OtpResponseModel.fromJson(res.data);
  }
}
