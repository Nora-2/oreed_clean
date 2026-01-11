import 'package:flutter/material.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/shared_widgets/custom_button.dart';
import 'package:oreed_clean/core/utils/textstyle/appfonts.dart';
import 'package:oreed_clean/features/login/data/repositories/auth_repo_impl.dart';
import 'package:oreed_clean/features/login/presentation/widgets/authbackground.dart';
import 'package:oreed_clean/networking/optimized_api_client.dart';
import 'package:pinput/pinput.dart';

import '../../../login/domain/repositories/auth_repo.dart';

class NewPasswordWithOtpScreen extends StatefulWidget {
  static const routeName = "/new_password_with_otp";

  final String phone;

  const NewPasswordWithOtpScreen({super.key, required this.phone});

  @override
  State<NewPasswordWithOtpScreen> createState() =>
      _NewPasswordWithOtpScreenState();
}

class _NewPasswordWithOtpScreenState extends State<NewPasswordWithOtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  late final AuthRepository _authRepo;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize the repository with the API client
    _authRepo = AuthRepositoryImpl(OptimizedApiClient());
  }

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _otpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration({
    required String label,
    String? hint,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      suffixIcon: suffixIcon,
      labelStyle: AppFonts.body.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w800,
        color: AppColors.black,
      ),
      hintStyle: AppFonts.body.copyWith(
        fontSize: 12,
        color: AppColors.black.withValues(alpha: 0.6),
      ),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1.2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1.2),
      ),
      errorStyle: AppFonts.body.copyWith(fontSize: 11, color: Colors.red),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.primary, width: 1.5),
      ),
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      constraints: const BoxConstraints(maxHeight: 45),
    );
  }

  Future<void> _onUpdatePassword() async {
    FocusScope.of(context).unfocus();
    final t = AppTranslations.of(context)!;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final otp = _otpController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (password != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.text('password_mismatch'))));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await _authRepo.updatePasswordWithOtp(
        phone: widget.phone,
        otp: otp,
        password: password,
      );

      if (!mounted) return;

      setState(() => _isLoading = false);
      await _authRepo.updatePasswordWithOtp(
        phone: widget.phone,
        otp: otp,
        password: password,
      );

      if (!mounted) return;

      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.text('password_reset_success')),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      if (!mounted) return;

      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('برجاء التأكد من رمز التحقق'),
          backgroundColor: AppColors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppTranslations.of(context)!;

    return AuthBack(
      title: t.text('reset_password'),
      subtitle: t.text('enter_otp_and_new_password'),
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),

                // OTP field with Pinput
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Pinput(
                    controller: _otpController,
                    length: 4,
                    showCursor: true,
                    autofocus: true,
                    defaultPinTheme: PinTheme(
                      width: 60,
                      height: 60,
                      textStyle: AppFonts.body.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1.2,
                        ),
                      ),
                    ),
                    focusedPinTheme: PinTheme(
                      width: 60,
                      height: 60,
                      textStyle: AppFonts.body.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primary,
                          width: 1.5,
                        ),
                      ),
                    ),
                    submittedPinTheme: PinTheme(
                      width: 60,
                      height: 60,
                      textStyle: AppFonts.body.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primary,
                          width: 1.2,
                        ),
                      ),
                    ),
                    errorPinTheme: PinTheme(
                      width: 60,
                      height: 60,
                      textStyle: AppFonts.body.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red, width: 1.2),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return t.text('code_required');
                      }
                      if (v.length < 4) {
                        return t.text('code_too_short');
                      }
                      return null;
                    },
                  ),
                ),

                const SizedBox(height: 70),

                // New Password field
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  style: AppFonts.body.copyWith(
                    color: AppColors.black,
                    fontSize: 13,
                  ),
                  decoration: _inputDecoration(
                    label: t.text('new_password'),
                    hint: t.text('password_hint'),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.grey,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return t.text('password_required');
                    }
                    if (v.length < 6) {
                      return t.text('password_too_short');
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Confirm Password field
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  style: AppFonts.body.copyWith(
                    color: AppColors.black,
                    fontSize: 13,
                  ),
                  decoration: _inputDecoration(
                    label: t.text('confirm_password'),
                    hint: t.text('password_hint'),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.grey,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(
                          () => _obscureConfirmPassword =
                              !_obscureConfirmPassword,
                        );
                      },
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return t.text('password_required');
                    }
                    if (v != _passwordController.text) {
                      return t.text('password_mismatch');
                    }
                    return null;
                  },
                ),

                SizedBox(height: MediaQuery.of(context).size.height * 0.31),

                // Update button
                CustomButton(
                  text: t.text('update_password'),
                  onTap: () {
                    _isLoading ? null : _onUpdatePassword();
                  },
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
