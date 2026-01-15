import 'package:flutter/material.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';

class HeaderError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const HeaderError({super.key, 
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final appTrans = AppTranslations.of(context);
    return SizedBox(
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: Text(appTrans?.text('common.retry') ?? 'إعادة المحاولة'),
          ),
        ],
      ),
    );
  }
}

class HeaderLoading extends StatelessWidget {
  const HeaderLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      height: 200,
      child: Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      ),
    );
  }
}
