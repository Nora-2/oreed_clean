import 'package:flutter/material.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';

class VerificationTimerSection extends StatelessWidget {
  final Animation<double> animation; // من 1 → 0 أثناء reverse
  final Duration totalDuration; // ← مدّة العداد كاملة
  final String validityLabel;

  /// Required: عشان تصلّح الخطأ السابق وتتحكم في إعادة الإرسال
  final VoidCallback onResendTap;

  /// نص زر الإرسال (من الترجمة)، لو سبتها null هنستخدم نص افتراضي
  final String? resendLabel;

  /// لو عايز تستخدم TextSpan مخصص بدل الزر الافتراضي
  final TextSpan? resendSpan;

  const VerificationTimerSection({
    super.key,
    required this.animation,
    required this.totalDuration, // ← جديد
    required this.validityLabel,
    required this.onResendTap,
    this.resendLabel,
    this.resendSpan,
  });

  String _formatRemaining(double progress) {
    // progress: 1.0 عند البداية → 0.0 عند الانتهاء
    if (progress <= 0) return '00:00';
    final total = totalDuration.inSeconds;
    final remaining =
        (total * progress).ceil(); // يفضل ceil عشان ما يطلعش 00:00 بدري
    final mm = (remaining ~/ 60).toString().padLeft(2, '0');
    final ss = (remaining % 60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final bool canResend = animation.value <= 0.0;
        final timerText = _formatRemaining(animation.value);

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: validityLabel,
                    style: textTheme.bodyMedium?.copyWith(fontSize: 13.0),
                  ),
                  TextSpan(
                    text: timerText,
                    style: textTheme.titleLarge?.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12.0),

            // حافظ على نفس الارتفاع عشان مفيش jump
             _buildResend(context, canResend),
           
          ],
        );
      },
    );
  }

  Widget _buildResend(BuildContext context, bool canResend) {
    if (resendSpan != null) {
      return AnimatedOpacity(
        duration: const Duration(milliseconds: 150),
        opacity: canResend ? 1.0 : 0.0,
        child: canResend
            ? RichText(text: TextSpan(children: <TextSpan>[resendSpan!]))
            : const SizedBox.shrink(),
      );
    }

    return TextButton(
      onPressed: canResend ? onResendTap : null,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
      child: Text(resendLabel ?? 'Resend'),
    );
  }
}
