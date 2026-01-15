import 'package:flutter/material.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/features/companyprofile/domain/entities/company_ad_entity.dart';
import 'package:oreed_clean/features/companyprofile/presentation/cubit/companyprofile_cubit.dart';
import 'package:oreed_clean/features/companyprofile/presentation/widgets/ads_filter_tabbar.dart';
import 'package:oreed_clean/features/companyprofile/presentation/widgets/company_ads_list.dart';
import 'package:oreed_clean/features/companyprofile/presentation/widgets/future_functions.dart';
import 'package:oreed_clean/features/settings/presentation/widgets/subscribtion_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Changed from provider

class CompanyProfileLiteScreen extends StatefulWidget {
  final int companyId;

  const CompanyProfileLiteScreen({super.key, required this.companyId});

  @override
  State<CompanyProfileLiteScreen> createState() =>
      _CompanyProfileLiteScreenState();
}

class _CompanyProfileLiteScreenState extends State<CompanyProfileLiteScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      animationDuration: Duration.zero,
    );
    _tabController.addListener(_onTabChanged);
    _scrollController.addListener(_onScroll);

    // Initial Fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging && mounted) {
      setState(() {});
    }
  }

  // Handle Pagination
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      final state = context.read<CompanyprofileCubit>().state;
      if (state.profile != null &&
          state.hasMore &&
          state.status != CompanyProfileStatus.loading) {
        context.read<CompanyprofileCubit>().fetchCompanyAds(
          companyId: state.profile!.userId,
          sectionId: state.profile!.sectionId,
          loadMore: true,
        );
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    await context.read<CompanyprofileCubit>().fetchCompanyProfileAndAds(
      widget.companyId,
    );
  }

  List<CompanyAdEntity> _getFilteredAds(List<CompanyAdEntity> allAds) {
    final ownerType = _tabController.index == 0 ? 'company' : 'personal';
    return allAds.where((ad) => ad.adOwnerType == ownerType).toList();
  }

  int _getAdsCount(List<CompanyAdEntity> allAds, String ownerType) {
    return allAds.where((ad) => ad.adOwnerType == ownerType).length;
  }

  @override
  Widget build(BuildContext context) {
    final t = AppTranslations.of(context)!;

    return Scaffold(
      body: BlocBuilder<CompanyprofileCubit, CompanyprofileState>(
        builder: (context, state) {
          // 1. Loading State
          if (state.status == CompanyProfileStatus.loading &&
              state.profile == null) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          // 2. Error State
          if (state.status == CompanyProfileStatus.error &&
              state.profile == null) {
            return _buildErrorWidget(t, state.errorMessage);
          }

          // 3. Empty/Null State
          final company = state.profile;
          if (company == null) {
            return _buildEmptyWidget(t);
          }

          final ads = state.ads;
          final subscriptionStatus = SubscriptionStatus.fromDateString(
            company.adsExpiredAt,
          );

          return RefreshIndicator(
            onRefresh: _fetchData,
            color: AppColors.primary,
            child: ListView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(15),
              children: [
                _buildAppBar(context),
                const SizedBox(height: 10),
                Text(
                  t.text('my_ads'),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 15),
                AdsFilterTabBar(
                  tabController: _tabController,
                  companyAdsCount: _getAdsCount(ads, 'company'),
                  personalAdsCount: _getAdsCount(ads, 'personal'),
                ),
                const SizedBox(height: 16),
                CompanyAdsList(
                  ownerType: _tabController.index == 0 ? 'company' : 'personal',
                  ads: _getFilteredAds(ads),
                  isExpired: subscriptionStatus.isExpired,
                  companyUserId: company.userId,
                  companyId: company.id,
                  onAdTap: subscriptionStatus.isExpired
                      ? () => _showExpiredDialog(context, company.userId, t)
                      : null,
                  onDelete: (adId, sectionId) async {
                    final ad = ads.firstWhere((a) => a.id == adId);
                    if (subscriptionStatus.isExpired &&
                        ad.adOwnerType == 'company') {
                      _showExpiredDialog(context, company.userId, t);
                      return;
                    }

                    bool? confirm = await showDeleteConfirmDialog(context);
                    if (confirm == true) {
                      final result = await context
                          .read<CompanyprofileCubit>()
                          .deleteAd(adId: adId, sectionId: sectionId);
                      if (mounted) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(result.message)));
                      }
                    }
                  },
                ),
                if (state.status == CompanyProfileStatus.loading)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 6, top: 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffe8e8e9),
                borderRadius: BorderRadius.circular(25),
              ),
              padding: const EdgeInsets.all(6),
              child: Icon(Icons.arrow_back, color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(AppTranslations t, String? message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline_rounded, size: 64, color: AppColors.red),
          const SizedBox(height: 16),
          Text(message ?? t.text('loading_error_company_profile')),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: _fetchData, child: Text(t.text('retry'))),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget(AppTranslations t) {
    return Center(child: Text(t.text('company_not_found')));
  }

  void _showExpiredDialog(BuildContext context, int userId, AppTranslations t) {
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
            border: Border.all(color: const Color(0xFFFFCDD2), width: 2),
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
                    bottom: BorderSide(color: Color(0xFFFFCDD2), width: 1),
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
                            color: const Color(
                              0xFFD32F2F,
                            ).withValues(alpha: 0.4),
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
                              color: const Color(
                                0xFFD32F2F,
                              ).withValues(alpha: 0.7),
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
                                'subscription_expired_company_ads_message',
                              ),
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
                                color: const Color(
                                  0xFFD32F2F,
                                ).withValues(alpha: 0.3),
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
                              // Navigator.pop(context);
                              handleRenewSubscription(context, userId, t);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD32F2F),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              elevation: 4,
                              shadowColor: const Color(
                                0xFFD32F2F,
                              ).withValues(alpha: 0.4),
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
                              t.text('renew_now'),
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
}
