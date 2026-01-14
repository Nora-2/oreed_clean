import 'package:flutter/material.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/features/login/data/repositories/auth_repo_impl.dart';
import 'package:oreed_clean/features/login/presentation/widgets/authbackground.dart';
import 'package:oreed_clean/features/password/presentation/widgets/otpform.dart';
import 'package:oreed_clean/features/password/presentation/widgets/otppart.dart';
import 'package:oreed_clean/networking/optimized_api_client.dart';
import '../../../login/domain/repositories/auth_repo.dart';
class NewPasswordWithOtpScreen extends StatefulWidget {
  final String phone;
  const NewPasswordWithOtpScreen({super.key, required this.phone});

  @override
  State<NewPasswordWithOtpScreen> createState() =>
      _NewPasswordWithOtpScreenState();
}

class _NewPasswordWithOtpScreenState
    extends State<NewPasswordWithOtpScreen> {
  final _formKey = GlobalKey<FormState>();

  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late final AuthRepository _authRepo;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _authRepo = AuthRepositoryImpl(OptimizedApiClient());
  }

  @override
  void dispose() {
    _otpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _onUpdatePassword() async {
    final t = AppTranslations.of(context)!;
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.text('password_mismatch'))),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authRepo.updatePasswordWithOtp(
        phone: widget.phone,
        otp: _otpController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.text('password_reset_success')),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(context).popUntil((r) => r.isFirst);
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('برجاء التأكد من رمز التحقق'),
          backgroundColor: AppColors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppTranslations.of(context)!;

    return AuthBack(
      title: t.text('reset_password'),
      subtitle: t.text('enter_otp_and_new_password'),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                OtpInputSection(controller: _otpController),
                const SizedBox(height: 70),
                PasswordFormSection(
                  passwordController: _passwordController,
                  confirmController: _confirmPasswordController,
                  obscurePassword: _obscurePassword,
                  obscureConfirmPassword: _obscureConfirmPassword,
                  onTogglePassword: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                  onToggleConfirm: () => setState(
                      () => _obscureConfirmPassword =
                          !_obscureConfirmPassword),
                  isLoading: _isLoading,
                  onSubmit: _onUpdatePassword,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
