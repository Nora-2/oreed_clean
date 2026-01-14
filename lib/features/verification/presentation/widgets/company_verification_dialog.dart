import 'package:flutter/material.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/appimage/app_images.dart';
import 'package:oreed_clean/core/utils/shared_widgets/custom_button.dart';

Future<void> showCompanyVerificationDialog(
  BuildContext context, {
  String? packageName,
  String? duration,
  VoidCallback? onConfirm,
}) {
  final t = AppTranslations.of(context);

  final btnLabel = t?.text('continueText') ?? 'متابعة';

  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    barrierColor: Colors.black54,
    builder: (ctx) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration:  BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: AppColors.secondary,
              width: 3,
            ),
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle Bar
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

            // Success Icon/Image
            Image.asset(
              Appimage.logindone,
              width: 100,
              height: 100,
            ),

            const SizedBox(height: 24),

            // Title
            const Text(
              'تم اختيار باقتك! 🎉',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 12),

          
            Text(
              'وحسابك تحت المراجعة حالياً.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 16),

            // Detailed Message
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F8FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.secondary.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: const Text(
                'فريق اريد بيتواصل معاك قريب لتأكيد التفاصيل وبدء استخدام التطبيق.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                  height: 1.5,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Button
            CustomButton(
              onTap: onConfirm ?? () => Navigator.of(ctx).pop(),
              text: btnLabel,
            ),

            const SizedBox(height: 30),
          ],
        ),
      );
    },
  );
}



