import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appicons/app_icons.dart';
import 'package:oreed_clean/features/chooseplane/presentation/pages/chooseplan_screen.dart';
import 'package:oreed_clean/features/settings/presentation/widgets/subscribtion_states.dart';
import 'package:oreed_clean/networking/api_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SubscriptionCard extends StatelessWidget {
  final SubscriptionStatus subscriptionStatus;
  final String governorate;
  final String city;
  final String companyId;
  final int userId;

  const SubscriptionCard({
    required this.subscriptionStatus,
    required this.governorate,
    required this.city,
    required this.companyId,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppTranslations.of(context)!;
    final isExpired = subscriptionStatus.isExpired;
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    // Design Colors
    const Color activeBg = Color(0xFFFFF7ED);
    const Color activeBorder = Color(0xFFFB923C);
    const Color expiredBg = Color(0xFFFFF1F2);
    const Color expiredBorder = Color(0xFFF43F5E);
    final Color primaryColor = isExpired
        ? const Color(0xffD80027)
        : const Color(0xffFF8A00);

    return Directionality(
      textDirection: isRTL
          ? TextDirection.rtl
          : TextDirection.ltr, // Respect language direction
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isExpired ? expiredBg : activeBg,
          borderRadius: isExpired
              ? BorderRadius.circular(25)
              : BorderRadius.circular(35),
          border: Border.all(
            color: isExpired ? expiredBorder : activeBorder,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Row(
              textDirection: isRTL ? TextDirection.ltr : TextDirection.rtl,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // --- Left Side: Badge or Button ---
                if (!isExpired)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xffFF8A00),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      textDirection: isRTL
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          AppIcons.loadingTime,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                          width: 16,
                          height: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          t
                              .text("days_remaining_count")
                              .replaceFirst(
                                "{days}",
                                "${subscriptionStatus.daysLeft}",
                              ),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  InkWell(
                    onTap: () {
                      // Add navigation to renewal page hereef\
                      _handleRenewSubscription(context, userId, t);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE11D48),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        t.text("renew_subscription_action"),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),

                Row(
                  textDirection: isRTL ? TextDirection.ltr : TextDirection.rtl,
                  children: [
                    Column(
                      crossAxisAlignment: isRTL
                          ? CrossAxisAlignment.start
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          isExpired
                              ? t.text("subscription_expired")
                              : t.text("subscription_active"),
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                            color: Colors.black.withValues(alpha: 0.8),
                          ),
                        ),
                        Text(
                          isExpired
                              ? t
                                    .text("since_date")
                                    .replaceFirst(
                                      "{date}",
                                      subscriptionStatus.formatDate(),
                                    )
                              : t
                                    .text("expires_in_date")
                                    .replaceFirst(
                                      "{date}",
                                      subscriptionStatus.formatDate(),
                                    ),
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black.withValues(alpha: 0.5),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Icon(
                        isExpired
                            ? Icons.verified_outlined
                            : Icons.verified_outlined,
                        color: primaryColor,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // --- Bottom Section: Warning Message (Only if Expired) ---
            if (isExpired) ...[
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  t.text("company_subscription_expired_warning"),
                  textAlign: isRTL ? TextAlign.right : TextAlign.left,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _handleRenewSubscription(
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
      final url = Uri.parse(
        '${ApiProvider.baseUrl}/payment/request?user_id=$companyId&packageId=${result.id}',
      );
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}
