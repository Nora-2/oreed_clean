import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/appicons/app_icons.dart';
import 'package:oreed_clean/core/utils/appstring/app_string.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String? labelText;
  final String? hintText;
  final EdgeInsetsGeometry? contentPadding;
  final double borderRadius;
  final Color? fillColor;
  final Color? enabledBorderColor;
  final Color? focusedBorderColor;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;

  const PasswordField({
    super.key,
    this.controller,
    this.validator,
    this.labelText,
    this.hintText,
    this.contentPadding,
    this.borderRadius = 12,
    this.fillColor,
    this.enabledBorderColor,
    this.focusedBorderColor,
    this.textInputAction = TextInputAction.done,
    this.keyboardType = TextInputType.visiblePassword,
    this.onChanged,
    required isHidden,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _hidden = true;

  void _toggle() => setState(() => _hidden = !_hidden);

  @override
  Widget build(BuildContext context) {

   
    final hint = AppTranslations.of(context)!.text('password_hint');

    return TextFormField(
    
      controller: widget.controller,
      obscureText: _hidden,
      validator: widget.validator,
      textInputAction: widget.textInputAction,
      keyboardType: widget.keyboardType,
      onChanged: widget.onChanged,
      autovalidateMode: AutovalidateMode.onUserInteraction,

      decoration: InputDecoration(
        
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        floatingLabelBehavior: FloatingLabelBehavior.always,
  hintStyle: const TextStyle(
          fontSize: 14,
          color: Colors.grey,
        ),
        hintText: hint,
        label: Text(
          AppTranslations.of(context)!.text('password_label'),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(
            color: widget.focusedBorderColor ?? AppColors.primary,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.2),
        ),
        suffixIcon: IconButton(
          onPressed: _toggle,
          icon: SvgPicture.asset(
            width: 16,
            height: 16,
            _hidden ?AppIcons.eyeNotActive: AppIcons.eyeActive,
            color: Colors.black,
          ),
         
        ),
      ),
    );
  }
}
