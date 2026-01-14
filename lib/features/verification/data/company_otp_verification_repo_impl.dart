import 'package:oreed_clean/features/verification/data/datasources/company_otp_verification_data_source.dart';
import 'package:oreed_clean/features/verification/domain/entities/otp_response_entity.dart';
import 'package:oreed_clean/features/verification/domain/repositories/compant_otp_repo.dart';
class CompanyOtpRepositoryImpl implements CompanyOtpRepository {
  final CompanyOtpRemoteDataSource remote;
  CompanyOtpRepositoryImpl(this.remote);

  @override
  Future<OtpResponseEntity> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    final model = await remote.verifyOtp(phone, otp);
    return model;
  }
}