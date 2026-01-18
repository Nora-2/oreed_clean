import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oreed_clean/core/app_shared_prefs.dart';
import 'package:oreed_clean/core/routing/routes.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appicons/app_icons.dart';
import 'package:oreed_clean/features/chooseplane/presentation/pages/chooseplan_screen.dart';
import 'package:oreed_clean/features/companyprofile/presentation/widgets/ad_card_newlook.dart';
import 'package:oreed_clean/features/companyprofile/presentation/widgets/build_borrom_action_button_adbanner.dart';
import 'package:oreed_clean/features/verification/presentation/pages/payment_webview.dart';
import 'package:oreed_clean/networking/api_provider.dart';
// Import your actual Cubit file here
// import 'package:oreed_clean/features/companyprofile/presentation/cubit/company_profile_cubit.dart';

class PersonalFreeActions extends StatelessWidget {
  const PersonalFreeActions({super.key, required this.t, required this.widget});

  final AppTranslations t;
  final AdCardNewLook widget;

  /// Helper method to handle the plan selection logic for both buttons
  Future<void> _handlePlanSelection({
    required BuildContext context,
    required String type,
    required String title,
    required Color accentColor,
  }) async {
    HapticFeedback.lightImpact();

    // 1. Show the plan chooser
    final planResult = await ChoosePlanScreen.show(
      context: context,
      type: type,
      title: title,
      icon: Icons.star_rounded,
      introText: t.text('choose_plan_intro'),
      accentColor: accentColor,
      onTap: () {},
    );

    if (planResult == null) return;
    if (!context.mounted) return;

    // 2. Handle Free Plan
    if (planResult.isFree) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.homelayout,
        (_) => false,
      );
      return;
    }

    // 3. Handle Paid Plan (Open Payment WebView)
    final url = Uri.parse(
      '${ApiProvider.baseUrl}/payment/request?user_id=${AppSharedPreferences().userId}&packageId=${planResult.id}&ads_id=${widget.adId}&model=${widget.sectionType}',
    );

    final paymentResult = await Navigator.of(context).push<PaymentResult>(
      MaterialPageRoute(
        builder: (_) => PaymentWebView(
          url: url.toString(),
          title: AppTranslations.of(context)!.text('payment_title'),
        ),
      ),
    );

    if (!context.mounted) return;

    // 4. If payment is successful, go home
    if (paymentResult == PaymentResult.success || paymentResult == null) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.homelayout,
        (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Highlight Ad Button
        Expanded(
          child: GestureDetector(
            onTap: () => _handlePlanSelection(
              context: context,
              type: 'featured',
              title: t.text('choose_featured_plan_title'),
              accentColor: const Color(0xFFFFC837),
            ),
            child: BottomActionButton(
              text: t.text('highlight_your_ad_btn'),
              color: const Color(0xff8133F1),
              icon: AppIcons.starWithBackGrey,
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Pin Ad Button
        Expanded(
          child: GestureDetector(
            onTap: () => _handlePlanSelection(
              context: context,
              type: 'pinned',
              title: t.text('choose_pinned_plan_title'),
              accentColor: const Color(0xFFFFC837),
            ),
            child: BottomActionButton(
              text: t.text('pin_your_ad_btn'),
              color: const Color(0xffFF8A00),
              icon: AppIcons.pinWithBackGrey,
            ),
          ),
        ),
      ],
    );
  }
}
