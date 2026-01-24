import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oreed_clean/core/app_shared_prefs.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/appimage/app_images.dart';
import 'package:oreed_clean/core/utils/shared_widgets/custom_button.dart';
import 'package:oreed_clean/core/utils/textstyle/apptext_style.dart';
import 'package:oreed_clean/features/account_type/domain/entities/account_type_entity.dart';
import 'package:oreed_clean/features/account_type/presentation/widgets/account_type_card.dart';
import 'package:oreed_clean/features/add_ads/presentation/home_add_ads.dart';
import 'package:oreed_clean/features/add_ads/widgets/navigattoadform.dart';
import 'package:oreed_clean/features/chooseplane/presentation/pages/chooseplan_screen.dart';
import 'package:oreed_clean/features/companyprofile/domain/entities/company_profile_entity.dart';
import 'package:oreed_clean/features/companyprofile/presentation/cubit/companyprofile_cubit.dart';
import 'package:oreed_clean/features/settings/presentation/widgets/subscribtion_states.dart';
import 'package:oreed_clean/features/verification/presentation/pages/payment_webview.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../networking/api_provider.dart';


/// Bottom sheet to select account type (Individual or Company)
class AccountTypeBottomSheet extends StatefulWidget {
  final Function(AccountType selectedType) onAccountTypeSelected;

  const AccountTypeBottomSheet({
    super.key,
    required this.onAccountTypeSelected,
  });

  @override
  State<AccountTypeBottomSheet> createState() => _AccountTypeBottomSheetState();
}

class _AccountTypeBottomSheetState extends State<AccountTypeBottomSheet> {
  // Layout constants
  static const double _horizontalPadding = 16.0;
  static const double _cardHeight = 110.0;
  static const double _bottomPadding = 20.0;
  static const double _titleFontSize = 22.0;
  static const double _contentRadius = 32.0;
  static const Color _topBorderColor = Color(0xFFFF8C00);

  AccountType? _selected;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  Future<void> _fetchData() async {
    await AppSharedPreferences().initSharedPreferencesProp();
    context.read<CompanyprofileCubit>().fetchCompanyProfileAndAds(
          AppSharedPreferences().getCompanyId!,
        );
  }

  List<AccountTypeEntity> get _types {
    final t = AppTranslations.of(context)!;
    return [
      AccountTypeEntity(
        type: AccountType.individual,
        title: t.text('account_type.individual_title') ,
        subtitle: t.text('account_type.individual_subtitle') 
,
        imageAsset:Appimage.personalAds,
      ),
      AccountTypeEntity(
        type: AccountType.company,
        title: t.text('account_type.company_title') ,
        subtitle: t.text('account_type.company_subtitle') ,
        imageAsset: Appimage.companyAds,
      ),
    ];
  }

  void _onConfirm(SubscriptionStatus subscriptionStatus, CompanyProfileEntity profile) {
    if (_selected == null) {
      _showErrorSnackBar(
          AppTranslations.of(context)!.text('account_type.select_error') );
      return;
    }
    if (_selected == AccountType.company) {
      if (subscriptionStatus.isExpired) {
        _showExpiredDialog(
            context, profile.userId, AppTranslations.of(context)!);
      } else {
        AppNavigator.navigateToAdForm(
          context: context,
          sectionId: profile.sectionId,
          companyId: profile.id,
          companyTypeId: profile.companyTypeId,
        );
      }
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeAddAds(),
          ));
    }
    widget.onAccountTypeSelected(_selected!);
  }

  void _showExpiredDialog(
    BuildContext context,
    int userId,
    AppTranslations t,
  ) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFFF5F5), Color(0xFFFFF1F0), Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.0, 0.5, 1.0],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: const Color(0xFFFFCDD2),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFD32F2F).withValues(alpha: 0.2),
                blurRadius: 24,
                offset: const Offset(0, 12),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with gradient
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFD32F2F).withValues(alpha: 0.15),
                      const Color(0xFFD32F2F).withValues(alpha: 0.08),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(22),
                  ),
                  border: const Border(
                    bottom: BorderSide(
                      color: Color(0xFFFFCDD2),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFD32F2F), Color(0xFFC62828)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color:
                                const Color(0xFFD32F2F).withValues(alpha: 0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.error_outline,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t.text('subscription_expired'),
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 20,
                              color: Color(0xFFD32F2F),
                              letterSpacing: -0.5,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            t.text('action_not_available'),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFD32F2F)
                                  .withValues(alpha: 0.7),
                              letterSpacing: -0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD32F2F).withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFFFCDD2),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.info_outline_rounded,
                            color: Color(0xFFD32F2F),
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              t.text(
                                  'subscription_expired_company_ads_message'),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFD32F2F),
                                height: 1.5,
                                letterSpacing: -0.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: BorderSide(
                                color: const Color(0xFFD32F2F)
                                    .withValues(alpha: 0.3),
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              t.text('cancel'),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFD32F2F),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _handleRenewSubscription(context, userId, t);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD32F2F),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              elevation: 4,
                              shadowColor: const Color(0xFFD32F2F)
                                  .withValues(alpha: 0.4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(
                              Icons.autorenew_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                            label: Text(
                              t.text('renew_now') ,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
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
      final url =
          '${ApiProvider.baseUrl}/payment/request?user_id=$companyId&packageId=${result.id}';

      // Navigate to payment webview
      final paymentResult = await Navigator.push<PaymentResult>(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentWebView(
            url: url,
            title: t.text('payment_title'),
        
          ),
        ),
      );

      // Handle payment result
      if (paymentResult == PaymentResult.success && context.mounted) {
        // Close the dialog
        Navigator.pop(context);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t.text('payment_success') ),
            backgroundColor: Colors.green,
          ),
        );

        // Refresh profile data using Cubit
        context.read<CompanyprofileCubit>().fetchCompanyProfileAndAds(
              AppSharedPreferences().getCompanyId!,
            );
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onAccountTypeSelected(AccountType type) {
    setState(() => _selected = type);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompanyprofileCubit, CompanyprofileState>(
      builder: (context, state) {
        final isLoading = state.status == CompanyProfileStatus.loading;
        final profile = state.profile;

        return Container(
          decoration: const BoxDecoration(
            color: _topBorderColor,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(_contentRadius),
            ),
          ),
          child: Container(
            margin: const EdgeInsets.only(top: 8),
            decoration:  BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(_contentRadius),
              ),
            ),
            child: isLoading || profile == null
                ? _buildLoadingState()
                : _buildContentState(profile),
          ),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 32),
        _buildShimmerHeader(),
        const SizedBox(height: 24),
        _buildShimmerCards(),
        const SizedBox(height: 32),
        _buildShimmerButton(),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildShimmerHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            period: const Duration(milliseconds: 1000),
            child: Container(
              height: 24,
              width: MediaQuery.of(context).size.width * 0.6,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            period: const Duration(milliseconds: 1000),
            child: Container(
              height: 16,
              width: MediaQuery.of(context).size.width * 0.7,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: SizedBox(
        height: _cardHeight,
        child: Row(
          children: List.generate(2, (index) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  period: const Duration(milliseconds: 1000),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildShimmerButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        period: const Duration(milliseconds: 1000),
        child: Container(
          height: 45,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildContentState(CompanyProfileEntity profile) {
    final subscriptionStatus = SubscriptionStatus.fromDateString(
      profile.adsExpiredAt,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 25),
        _buildHeader(),
        const SizedBox(height: 24),
        _buildAccountTypeCards(),
        const SizedBox(height: 32),
        _buildBottomButton(subscriptionStatus, profile),
        SizedBox(
            height: MediaQuery.of(context).padding.bottom + _bottomPadding),
      ],
    );
  }

  Widget _buildHeader() {
    final t = AppTranslations.of(context)!;
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            t.text('account_type.page_title') ,
            textAlign: TextAlign.center,
            style: AppTextStyles.title.copyWith(
              fontSize: isRTL ? _titleFontSize : 20,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            t.text('account_type.page_subtitle') ,
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountTypeCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: SizedBox(
        height: _cardHeight,
        child: Row(
          children: List.generate(_types.length, (index) {
            final model = _types[index];
            final isSelected = _selected == model.type;
            return AccountTypeCardbottomsheet(
              model: model,
              isSelected: isSelected,
              onTap: () => _onAccountTypeSelected(model.type),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildBottomButton(
      SubscriptionStatus subscriptionStatus, CompanyProfileEntity profile) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        _horizontalPadding,
        0,
        _horizontalPadding,
        0,
      ),
      child: SizedBox(
        height: 50,
        child: CustomButton(
          text: AppTranslations.of(context)!.text('continueText') ,
          onTap: () => _onConfirm(subscriptionStatus, profile),
        ),
      ),
    );
  }
}

/// Helper function to show the bottom sheet
Future<void> showAccountTypeBottomSheet({
  required BuildContext context,
  required Function(AccountType) onAccountTypeSelected,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => AccountTypeBottomSheet(
      onAccountTypeSelected: onAccountTypeSelected,
    ),
  );
}