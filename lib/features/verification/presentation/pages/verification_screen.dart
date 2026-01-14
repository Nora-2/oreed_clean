// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:oreed_clean/core/enmus/enum.dart';
import 'package:oreed_clean/core/routing/routes.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/shared_widgets/custom_button.dart';
import 'package:oreed_clean/features/account_type/presentation/pages/account_type_screen.dart';
import 'package:oreed_clean/features/chooseplane/presentation/pages/chooseplan_screen.dart';
import 'package:oreed_clean/features/login/presentation/widgets/authbackground.dart';
import 'package:oreed_clean/features/login/presentation/widgets/success_dialog.dart';
import 'package:oreed_clean/features/verification/presentation/cubit/verificationscreen_cubit.dart';
import 'package:oreed_clean/features/verification/presentation/widgets/company_verification_dialog.dart';
import 'package:oreed_clean/features/verification/presentation/widgets/verification_pin_field.dart';
import 'package:oreed_clean/features/verification/presentation/widgets/verification_timer_section.dart';
import 'package:oreed_clean/networking/api_provider.dart';
import 'package:provider/provider.dart';

class VerificationScreen extends StatefulWidget {
  
  final String phone;
  final bool isForget;
  final bool isRegister;
  final bool isCompany;

  const VerificationScreen({
    super.key,
    required this.phone,
    this.isForget = false,
    this.isRegister = false,
    required this.isCompany,
  });

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen>
    with TickerProviderStateMixin {
  final TextEditingController _pinController = TextEditingController();
  static const int _pinLength = 4;
  static const Duration _timeout = Duration(seconds: 120);

  late final AnimationController _timerController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _timerController = AnimationController(vsync: this, duration: _timeout);
    _pinController.addListener(() => setState(() {}));
    _startTimer();
  }

  @override
  void dispose() {
    _timerController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  void _startTimer() {
    final fromValue =
        _timerController.isAnimating ? _timerController.value : 1.0;
    _timerController.reverse(from: fromValue);
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  void _setLoading(bool value) {
    if (!mounted) return;
    setState(() => _isLoading = value);
  }

 Future<void> _verifyOtp() async {
  // 1. Prevent multiple requests using the Cubit's state instead of local variable
  final cubit = context.read<VerificationCubit>();
  if (cubit.state.status == OtpStatus.loading) return;

  // 2. Local Validation
  final otp = _pinController.text.trim();
  if (otp.length < _pinLength) {
    _showSnack(AppTranslations.of(context)!.text('enter_full_code'));
    return;
  }

  _setLoading(true); 

  try {
    // 4. Call the Cubit method
    await cubit.verifyOtp(
      phone: widget.phone, 
      otp: otp, 
      isCompany: widget.isCompany,
    );

    // 5. Logic handling based on Cubit State
    if (cubit.state.status == OtpStatus.success) {
      final response = cubit.state.response;
      _onVerificationSuccess(
        response!.msg,
        response.id,
      );
    } else {
      // Show specific error from Cubit or a fallback
      _showSnack(cubit.state.error ?? 'رمز التحقق غير صالح');
    }
  } catch (e) {
    _showSnack(AppTranslations.of(context)!.text('invalid_otp'));
  } finally {
     _setLoading(false);
  }
}
  void _onVerificationSuccess(String message, int id) {
    _showSnack(message);
    if (widget.isForget) {
      _navigateToResetPassword();
    } else {
      _navigateAfterVerification(id);
    }
  }

  void _navigateToResetPassword() {
    showRequestSubmittedDialog(
      context,
      title: AppTranslations.of(context)?.text('request_sent_title') ??
          AppTranslations.of(context)!.text('verification_success'),
      message:
          AppTranslations.of(context)!.text('verification_success_message'),
    );
    Navigator.pushReplacementNamed(
      context,
      Routes.newPasswordWithOtpScreen,
      arguments: {'phone': widget.phone},
    );
  }

  Future<void> _navigateAfterVerification(int id) async {
    if (widget.isCompany) {
      await showRequestSubmittedDialog(
        context,
        title: '',
        message:
            AppTranslations.of(context)!.text('verification_success_message'),
      );
      Navigator.pushNamed(
        context,
        Routes.companyregister
       
      );
      final result = await ChoosePlanScreen.show(
        context: context,
        type: 'subscription',
        title: AppTranslations.of(context)!.text('choose_plan'),
        icon: Icons.star_rounded,
        introText: AppTranslations.of(context)!.text('choose_plan_desc'),
        accentColor: const Color(0xFFFFC837),
        onTap: () {},
      );

      if (result == null) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const AccountTypePage()),
            (_) => false,
          );
        return;
      }

      final String paymentUrl =
          '${ApiProvider.baseUrl}/payment/request?user_id=$id&packageId=${result.id}';

      // Navigate to PaymentWebView
      final paymentResult = await Navigator.pushNamed<PaymentResult>(
        context,
        Routes.payment,
        arguments: {
           'url': paymentUrl,
           'title': AppTranslations.of(context)!.text('payment_title'),
           'successMatcher': (String url) =>
               url.contains('payment/success') ||
               url.contains('status=success') ||
               url.contains('تم الدفع بنجاح'),
           'cancelMatcher': (String url) =>
               url.contains('payment/cancel') ||
               url.contains('status=cancel') ||
               url.contains('فشل الدفع'),
        }
      );

      // Handle payment result
      if (!mounted) return;

      if (paymentResult == PaymentResult.success) {
        _showSnack(AppTranslations.of(context)!.text('payment_success'));
        // Set tab index to 2 (main home tab) before navigating
        await showCompanyVerificationDialog(
          context,
          packageName: 'باقة الشركات',
          duration: '90 يوم',
          onConfirm: () {
            Navigator.of(context).pop(); // Close dialog

            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.homelayout,
              (_) => false,
              arguments: 2,
            );
          },
        );
        await Future.delayed(const Duration(seconds: 2));
        Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.homelayout,
          (_) => false,
          arguments: 2,
        );
      } else if (paymentResult == PaymentResult.failed) {
        _showSnack(AppTranslations.of(context)!.text('payment_failed'));
      } else {
        // Payment cancelled
        _showSnack(AppTranslations.of(context)!.text('payment_cancelled'));
      }
    } else {
      // Navigate to home with index 2 (main home tab)
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.homelayout,
        (_) => false,
        arguments: 2,
      );
    }
  }

  Future<void> _resendOtp() async {
    if (_isLoading || _timerController.isAnimating) return; // ✅ protect again
    _startTimer();
    _setLoading(true);

    try {
      // Later: await provider.resendOtp(widget.phone);
      _showSnack(AppTranslations.of(context)!.text('otp_resent'));
    } catch (_) {
      _showSnack(AppTranslations.of(context)!.text('resend_error'));
    } finally {
      _setLoading(false);
    }
  }

  // ========== UI ==========
  @override
  Widget build(BuildContext context) {
    final t = AppTranslations.of(context)!;

    return AuthBack(
      title: t.text('enter_verification_code'),
      subtitle:
          t.text('otp_sent_to_phone').replaceFirst('{phone}', widget.phone),
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 55.0),
                VerificationPinField(
                  controller: _pinController,
                  pinLength: _pinLength,
                  onDone: (_) => _verifyOtp(),
                ),
                const SizedBox(height: 20.0),
                Text(
                  t.text('resend_instruction'),
                  style:
                      const TextStyle(color: Color(0xff676768), fontSize: 13),
                ),
                VerificationTimerSection(
                  animation: _timerController,
                  totalDuration: _timeout,
                  validityLabel: '- ${t.text('codeValidity')} ',
                  resendLabel: t.text('resend'),
                  onResendTap: _resendOtp,
                ),
                const Spacer(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: CustomButton(
                    onTap: _verifyOtp,
                    text: t.text('confirmation'),
                  ),
                )
              ],
            ),
          ),
          if (_isLoading)
            Positioned.fill(
              child: ColoredBox(
                color: Colors.black.withValues(alpha: 0.15),
                child:  Center(
                  child: CircularProgressIndicator(
                    color: AppColors.secondary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
