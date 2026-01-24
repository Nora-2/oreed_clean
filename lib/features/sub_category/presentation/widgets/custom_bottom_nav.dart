import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oreed_clean/core/app_shared_prefs.dart';
import 'package:oreed_clean/core/routing/routes.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/appicons/app_icons.dart';
import 'package:oreed_clean/features/add_ads/widgets/account_type_bottom_sheet.dart';
import 'package:oreed_clean/features/mainlayout/presentation/cubit/mainlayout_cubit.dart';
import 'package:oreed_clean/features/mainlayout/presentation/cubit/mainlayout_state.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int? initialIndex;

  const CustomBottomNavBar({
    super.key,
    this.initialIndex,
  });

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  late NotchBottomBarController _controller;

  @override
  void initState() {
    super.initState();
    // Get initial index from widget or cubit
    final initialIndex = widget.initialIndex ?? 
        context.read<HomelayoutCubit>().state.currentTabIndex;
    _controller = NotchBottomBarController(index: initialIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomelayoutCubit, HomelayoutState>(
      builder: (context, state) {
        // Sync Animation Controller with Cubit state
        if (_controller.index != state.currentTabIndex) {
          _controller.jumpTo(state.currentTabIndex);
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 0.0),
          child: AnimatedNotchBottomBar(
            notchBottomBarController: _controller,
            color: Colors.grey.shade300,
            showLabel: true,
            shadowElevation: 5,
            kBottomRadius: 30.0,
            topMargin: 10,
            notchColor: AppColors.primary,
            onTap: (index) async {
              final cubit = context.read<HomelayoutCubit>();
              final token = AppSharedPreferences().getUserToken;
              final userType = AppSharedPreferences().userType;

              // 1. Change index first (instant visual feedback)
              cubit.changeTabIndex(index);

              // 2. Keep controller in sync
              if (_controller.index != index) {
                _controller.jumpTo(index);
              }

              // 3. Auth Check (Center Tab - Add Ads)
              if (token == null && index == 1) {
                Navigator.pushNamed(
                  context,
                  Routes.login,
                );
                return;
              }

              // 4. Account Type Check (for Add Ads tab)
              if (index == 1 && userType != 'personal') {
                await showAccountTypeBottomSheet(
                  context: context,
                  onAccountTypeSelected: (_) {
                    // Navigate to Home with Add Ads tab selected
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      Routes.homelayout,
                      (route) => false,
                      arguments: 1,
                    );
                  },
                );
              } else {
                // 5. Navigate to Home screen with the selected tab
                Navigator.of(context).pushNamedAndRemoveUntil(
                  Routes.homelayout,
                  (route) => false,
                  arguments: index,
                );
              }
            },
            kIconSize: 24.0,
            bottomBarItems: [
              BottomBarItem(
                inActiveItem: SvgPicture.asset(
                  AppIcons.profile,
                  color: Colors.black,
                ),
                activeItem: SvgPicture.asset(
                  AppIcons.profile,
                  color: Colors.white,
                ),
              ),
              BottomBarItem(
                inActiveItem: SvgPicture.asset(
                  AppIcons.ads,
                  color: Colors.black,
                ),
                activeItem: SvgPicture.asset(
                  AppIcons.ads,
                  color: Colors.white,
                ),
              ),
              BottomBarItem(
                inActiveItem: SvgPicture.asset(
                  AppIcons.homeNav,
                  color: Colors.black,
                ),
                activeItem: SvgPicture.asset(
                  AppIcons.homeNav,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}