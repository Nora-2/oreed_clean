import 'package:flutter/material.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/shared_widgets/custom_button.dart';

class PasswordFormSection extends StatelessWidget {
  final TextEditingController passwordController;
  final TextEditingController confirmController;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final VoidCallback onTogglePassword;
  final VoidCallback onToggleConfirm;
  final VoidCallback onSubmit;
  final bool isLoading;

  const PasswordFormSection({
    super.key,
    required this.passwordController,
    required this.confirmController,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.onTogglePassword,
    required this.onToggleConfirm,
    required this.onSubmit,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppTranslations.of(context)!;

    return Column(
      children: [
        _passwordField(
          context,
          controller: passwordController,
          label: t.text('new_password'),
          obscure: obscurePassword,
          toggle: onTogglePassword,
        ),
        const SizedBox(height: 16),
        _passwordField(
          context,
          controller: confirmController,
          label: t.text('confirm_password'),
          obscure: obscureConfirmPassword,
          toggle: onToggleConfirm,
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.31),
        CustomButton(
          text: t.text('update_password'),
          onTap:()=> isLoading ? null : onSubmit,
        ),
      ],
    );
  }

  Widget _passwordField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback toggle,
  }) {
    final t = AppTranslations.of(context)!;

    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: (v) =>
          v == null || v.isEmpty ? t.text('password_required') : null,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off : Icons.visibility,
            size: 20,
          ),
          onPressed: toggle,
        ),
      ),
    );
  }
}
