import '../entities/otp_response_entity.dart';

abstract class CompanyOtpRepository {
  Future<OtpResponseEntity> verifyOtp({
    required String phone,
    required String otp,
  });
}