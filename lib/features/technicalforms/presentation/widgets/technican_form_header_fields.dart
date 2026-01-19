// File: lib/features/forms/presentation/widgets/technician_form/form_header.dart

import 'package:flutter/material.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/shared_widgets/custom_form_field.dart';

class TechnicianFormHeader extends StatelessWidget {
  final VoidCallback onBack;
  final AppTranslations? appTrans;

  const TechnicianFormHeader({super.key, required this.onBack, this.appTrans});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onBack,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xffe8e8e9),
              borderRadius: BorderRadius.circular(25),
            ),
            padding: const EdgeInsets.all(6),
            child: Icon(Icons.arrow_back, color: AppColors.primary),
          ),
        ),
        const SizedBox(width: 40),
        Text(
          appTrans?.text('page.enter_technician_details') ??
              'Enter your ad details',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

class NameField extends StatelessWidget {
  final TextEditingController controller;
  final AppTranslations? appTrans;

  const NameField({super.key, required this.controller, this.appTrans});

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      hint: appTrans?.text('hint.name') ?? 'Enter full name',
      label: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: appTrans?.text('field.name') ?? 'Name'),
            const TextSpan(
              text: ' *',
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
      validator: (val) => val!.isEmpty
          ? (appTrans?.text('validation.enter_name') ?? 'Please enter name')
          : null,
    );
  }
}

class DescriptionField extends StatelessWidget {
  final TextEditingController controller;
  final AppTranslations? appTrans;

  const DescriptionField({super.key, required this.controller, this.appTrans});

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      hint:
          appTrans?.text('hint.description') ??
          'Write service/product details...',
      max: 10,
      min: 5,
      keyboardType: TextInputType.multiline,
      label: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: appTrans?.text('field.description') ?? 'Description',
            ),
            const TextSpan(
              text: ' *',
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
      validator: (String? p1) {
        return null;
      },
    );
  }
}
