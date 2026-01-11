import 'package:flutter/material.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/shared_widgets/custom_button.dart';
import 'package:oreed_clean/features/login/data/repositories/auth_repo_impl.dart';
import 'package:oreed_clean/features/login/presentation/widgets/authbackground.dart';
import 'package:oreed_clean/features/login/presentation/widgets/custom_phonefield.dart';
import 'package:oreed_clean/features/password/presentation/pages/newpass_withotp_screen.dart';
import '../../../login/domain/repositories/auth_repo.dart'; 
import '../../../../networking/optimized_api_client.dart'; 

class ResetPasswordScreen extends StatefulWidget {
  static const routeName = "/reset_password";

  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  // In Clean Arch, usually you inject this, but for now:
  late final AuthRepository _authRepo;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize the repository with the API client
    _authRepo = AuthRepositoryImpl(OptimizedApiClient()); 
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _onSendOtp() async {
    FocusScope.of(context).unfocus();
    final t = AppTranslations.of(context)!;

    if (_formKey.currentState?.validate() != true) return;

    final rawPhone = _phoneController.text.trim();
    // Remove any non-digits
    final onlyDigits = rawPhone.replaceAll(RegExp(r'\D'), '');

    setState(() => _isLoading = true);

    try {

      await _authRepo.resetPassword(onlyDigits);

      if (!mounted) return;
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.text('code_sent') ?? 'Code sent successfully'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to OTP screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => NewPasswordWithOtpScreen(phone: '965$onlyDigits'),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: AppColors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppTranslations.of(context)!;
    final size = MediaQuery.of(context).size;

    return AuthBack(
      title: t.text('reset_password') ?? 'إعادة تعيين كلمة المرور',
      subtitle: t.text('enter_phone_to_reset') ?? 'أدخل رقم الهاتف لإرسال رمز التحقق',
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                PhoneField(
                  controller: _phoneController,
                  validator: (v) {
                    if (v == null || v.isEmpty) return t.text('enterPhoneNote');
                    if (v.length < 8) return t.text('phone_too_short');
                    return null;
                  },
                  labletext: t.text('phone_label'),
                  lablehint: t.text('loginPhoneHint'),
                ),
                SizedBox(height: size.height * 0.45), // Adjusted to prevent overflow
                _isLoading 
                  ? const Center(child: CircularProgressIndicator())
                  : CustomButton(
                      onTap: _onSendOtp,
                      text: t.text('reset_password_button'),
                    ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}