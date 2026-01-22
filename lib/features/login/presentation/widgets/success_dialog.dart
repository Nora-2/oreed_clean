import 'package:flutter/material.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/appimage/app_images.dart';
import 'package:oreed_clean/core/utils/shared_widgets/custom_button.dart';

Future<void> showRequestSubmittedDialog(
  BuildContext context, {
  String? title,
  String? message,
  String? buttonText,
  VoidCallback? onConfirm,
}) {
  final t = AppTranslations.of(context);
  
  // Default values if not provided
  final titleText = title ?? t?.text('login_success_title') ?? 'Success';
  final messageText = message ?? t?.text('login_success_msg') ?? 'Operation completed successfully.';
  final btnLabel = buttonText ?? t?.text('confirm') ?? 'Confirm';

  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true, // Allows the sheet to size itself based on content
    builder: (ctx) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration:   BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.secondary,width: 3)),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. The Grey Handle Bar
            const SizedBox(height: 8),
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 30),
Image.asset(Appimage.loginDone),

            const SizedBox(height: 24),

            // 3. Title
            Text(
              titleText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            
            const SizedBox(height: 12),

            // 4. Subtitle
            Text(
              messageText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                height: 1.5, // Better line spacing for arabic
              ),
            ),

            const SizedBox(height: 30),
CustomButton( onTap:  onConfirm ?? () => Navigator.of(ctx).pop(), text:   btnLabel,),
            const SizedBox(height: 30), // Bottom padding for safety
          ],
        ),
      );
    },
  );
}