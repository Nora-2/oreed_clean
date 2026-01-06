import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/appicons/app_icons.dart';

class PhoneField extends StatelessWidget {
  const PhoneField({
    super.key,
    required this.validator,
    this.controller,
    this.onChanged,
    required this.labletext,
    required this.lablehint,
  });

  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final String labletext;
  final String lablehint;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.phone,
      onChanged: onChanged, // تعديل هنا - كان onChanged: (val) => onChanged
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CountryFlag.fromCountryCode(
                'KW',
                theme: const ImageTheme(
                  height: 20,
                  width: 20,
                  shape: Circle(),
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                '+965',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 6),
               SvgPicture.asset(AppIcons.dropdown),
              const SizedBox(width: 8),
              Container(
                height: 24,
                width: 1.5,
                color: Colors.grey.shade300,
              ),
              const SizedBox(width: 4),
            ],
          ),
        ),
        label: Text(
          labletext,
          style:  TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
        hintText: lablehint,
        hintStyle: const TextStyle(
          fontSize: 14,
          color: Colors.grey,
        ),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
            width: 1.2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:  BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}