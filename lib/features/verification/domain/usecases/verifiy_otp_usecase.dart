import 'package:oreed_clean/features/verification/domain/repositories/compant_otp_repo.dart';
import '../entities/otp_response_entity.dart';

class VerifyOtpUseCase {
  final CompanyOtpRepository repository;
  VerifyOtpUseCase(this.repository);

  Future<OtpResponseEntity> call({
    required String phone,
    required String otp,
  }) async {
    return await repository.verifyOtp(phone: phone, otp: otp);
  }
}