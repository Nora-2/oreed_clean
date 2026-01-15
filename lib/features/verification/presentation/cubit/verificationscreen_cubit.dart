import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:oreed_clean/core/app_shared_prefs.dart';
import 'package:oreed_clean/features/notification/presentation/pages/notification_services.dart';
import 'package:oreed_clean/features/verification/domain/entities/otp_response_entity.dart';
import 'package:oreed_clean/features/verification/domain/usecases/verifiy_otp_usecase.dart';

part 'verificationscreen_state.dart';

class VerificationCubit extends Cubit<VerificationState> {
  final VerifyOtpUseCase verifyOtpUseCase;

  VerificationCubit(this.verifyOtpUseCase) : super(const VerificationState());

  Future<void> verifyOtp({
    required String phone,
    required String otp,
    required bool isCompany,
  }) async {
    emit(state.copyWith(status: OtpStatus.loading, error: null));

    try {
      final response = await verifyOtpUseCase(phone: phone, otp: otp);
      final bool isSuccess = response.status;

      if (isSuccess) {
        // Business logic for non-company users (saving data)
        // Note: Usually companies also need tokens, but keeping your original logic
        if (!isCompany) {
          final data = response.data;

          if (data.containsKey('token')) {
            await AppSharedPreferences().saveUserToken(data['token']);
            await AppSharedPreferences().saveLoggedIn(true);
          }
          if (data.containsKey('account_type')) {
            await AppSharedPreferences().saveUserType(data['account_type']);
            // Subscribe to notification topic
            await NotificationService().subscribeToUserTypeTopic(
              data['account_type'],
            );
          }
          if (data.containsKey('id')) {
            await AppSharedPreferences().saveUserId(data['id']);
          }
          if (data.containsKey('business_name')) {
            await AppSharedPreferences().saveUserName(data['business_name']);
          }
        }

        emit(state.copyWith(status: OtpStatus.success, response: response));
      } else {
        emit(
          state.copyWith(
            status: OtpStatus.error,
            error: response.msg,
            response: response,
          ),
        );
      }
    } catch (e, stack) {
      log('❌ OTP verification error: $e', stackTrace: stack);
      emit(
        state.copyWith(
          status: OtpStatus.error,
          error: 'حدث خطأ أثناء التحقق من الرمز',
        ),
      );
    }
  }

  void reset() {
    emit(const VerificationState());
  }
}
