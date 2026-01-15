
import 'package:flutter/material.dart';
import 'package:oreed_clean/core/enmus/enum.dart';
import 'package:oreed_clean/core/routing/routes.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/features/chooseplane/presentation/pages/chooseplan_screen.dart';
import 'package:oreed_clean/features/verification/presentation/pages/payment_webview.dart' hide PaymentResult;
import 'package:oreed_clean/networking/api_provider.dart';

Future<bool?> showDeleteConfirmDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.redAccent,
                size: 48,
              ),
              const SizedBox(height: 16),
              Builder(
                builder: (context) {
                  final t = AppTranslations.of(context);
                  return Text(
                    t?.text('delete_ad_confirm_title') ?? 'تأكيد الحذف',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              Builder(
                builder: (context) {
                  final t = AppTranslations.of(context);
                  return Text(
                    t?.text('delete_ad_confirm_message') ??
                        'هل أنت متأكد أنك تريد حذف هذا الإعلان؟ لا يمكن التراجع بعد الحذف.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black54,
                      height: 1.4,
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              Builder(
                builder: (context) {
                  final t = AppTranslations.of(context);
                  return Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context, false),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(t?.text('cancel') ?? 'إلغاء'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(t?.text('delete') ?? 'حذف'),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}



  Future<void> handleRenewSubscription(
    BuildContext context,
    int companyId,
    AppTranslations t,
  ) async {
    final result = await ChoosePlanScreen.show(
      context: context,
      type: 'subscription',
      title: t.text('choose_plan_title'),
      icon: Icons.star_rounded,
      introText: t.text('choose_plan_intro'),
      accentColor: const Color(0xFFFFC837),
      onTap: () {},
    );

    if (result != null && context.mounted) {
      final url =
          '${ApiProvider.baseUrl}/payment/request?user_id=$companyId&packageId=${result.id}';

      final paymentResult = await Navigator.of(context).push<PaymentResult>(
        MaterialPageRoute(
          builder: (_) => PaymentWebView(
            url: url,
            title: t.text('payment_title') ,
          ),
        ),
      );

      if (paymentResult == PaymentResult.success && context.mounted) {
        // Navigate to home with index 2 (main home tab)
        Navigator.of(context).pushNamedAndRemoveUntil(
         Routes.homelayout,
        arguments: 2,
          (_) => false,
        );
      }
    }
  }