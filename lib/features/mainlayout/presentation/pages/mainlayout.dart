import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oreed_clean/core/app_shared_prefs.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/appicons/app_icons.dart';
import 'package:oreed_clean/core/utils/shared_widgets/route_observer.dart';
import 'package:oreed_clean/features/add_ads/presentation/home_add_ads.dart';
import 'package:oreed_clean/features/banners/presentation/cubit/banners_cubit.dart';
import 'package:oreed_clean/features/favourite/presentation/cubit/favourite_cubit.dart';
import 'package:oreed_clean/features/home/presentation/cubit/home_cubit.dart';
import 'package:oreed_clean/features/home/presentation/pages/main_home_tab.dart';
import 'package:oreed_clean/features/mainlayout/presentation/cubit/mainlayout_cubit.dart';
import 'package:oreed_clean/features/mainlayout/presentation/cubit/mainlayout_state.dart';
import 'package:oreed_clean/features/settings/presentation/pages/setting_screen.dart';
import 'package:oreed_clean/injection_container.dart';

class Homelayout extends StatefulWidget {
  final int? initialIndex;

  const Homelayout({super.key, this.initialIndex});

  @override
  State<Homelayout> createState() => _HomelayoutState();
}

class _HomelayoutState extends State<Homelayout>
    with RouteAware, WidgetsBindingObserver {
  /// Start at index 2 (The Right-most item, which is Home)
  late NotchBottomBarController _controller;
  bool _hasInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeHomeTab();
    _hasInitialized = true;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed && mounted && _hasInitialized) {
      // When app resumes, check if we need to reset to home tab
      _resetToHomeTab();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Register as RouteAware to detect when user navigates back to this screen
    final modalRoute = ModalRoute.of(context);
    if (modalRoute is PageRoute) {
      // routeObserver is defined in your route_observer.dart
      routeObserver.subscribe(this, modalRoute);
    }
  }

  @override
  void didPopNext() {
    // Called when user navigates back to this screen (pop)
    // Always reset to home tab (index 2)
    super.didPopNext();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _resetToHomeTab();
      }
    });
  }

  @override
  void didPush() {
    // Called when this screen is pushed
    super.didPush();
  }

  @override
  void didPushNext() {
    // Called when a new route is pushed on top of this one
    super.didPushNext();
  }

  void _initializeHomeTab() {
    // Reset to home tab (index 2) by default, unless specified otherwise
    final targetIndex = widget.initialIndex ?? 2;

    // Create controller immediately for bottom bar
    _controller = NotchBottomBarController(index: targetIndex);

    // Defer cubit call to after the first frame to avoid
    // setState/notify during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final homeCubit = context.read<HomelayoutCubit>();
      if (homeCubit.state.currentTabIndex != targetIndex) {
        homeCubit.changeTabIndex(targetIndex);
      }
    });
  }

  void _resetToHomeTab() {
    // Always go back to index 2 when returning to this screen
    if (!mounted) return;

    final homeCubit = context.read<HomelayoutCubit>();
    if (homeCubit.state.currentTabIndex != 2) {
      homeCubit.changeTabIndex(2);
      if (_controller.index != 2) {
        _controller.jumpTo(2);
      }
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1. Get the BannerCubit first
    final bannerCubit = sl<BannerCubit>();
    return BlocBuilder<HomelayoutCubit, HomelayoutState>(
      builder: (context, homeState) {
        // 1. Sync Animation Controller with Cubit
        if (_controller.index != homeState.currentTabIndex) {
          _controller.jumpTo(homeState.currentTabIndex);
        }

        // 2. Define Tabs [Left, Center, Right]
        final tabs = [
          const MoreTab(), // Index 0: Profile (Left)
           MultiBlocProvider(
    providers: [
      BlocProvider.value(value: bannerCubit),
      BlocProvider(
        create: (context) => MainHomeCubit(
          sl(),
          sl(),
          bannerCubit,
        )..fetchHomeData(),
      ),
    ],
    child: const HomeAddAds(),
  ),

          MultiBlocProvider(
            providers: [
              // 2. Provide BannerCubit so BannerSection can see it
              BlocProvider.value(value: bannerCubit),
              BlocProvider(
                create: (_) => sl<FavoritesCubit>()..loadFavorites(),
              ),
              BlocProvider(
                create: (context) => MainHomeCubit(
                  sl(),
                  sl(),
                  bannerCubit, // Use the same instance
                )..fetchHomeData(),
              ),
            ],
            child: const MainHomeTab(),
          ),
        ];

        final currentIndex = homeState.currentTabIndex;

        return SafeArea(
          top: false,
          bottom: false,
          child: Scaffold(
            extendBody: true, // Required for the floating bar effect
            body: AnimatedSwitcher(
              duration: const Duration(milliseconds: 280),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              // Custom transition for the "Add" tab (slide up), Fade for others
              transitionBuilder: (child, animation) {
                final isAddAds = currentIndex == 1;
                if (isAddAds) {
                  final slideAnimation = Tween<Offset>(
                    begin: const Offset(0, 0.03),
                    end: Offset.zero,
                  ).animate(animation);
                  return SlideTransition(
                    position: slideAnimation,
                    child: FadeTransition(opacity: animation, child: child),
                  );
                }
                return FadeTransition(opacity: animation, child: child);
              },
              child: KeyedSubtree(
                key: ValueKey<int>(currentIndex),
                child: tabs[currentIndex],
              ),
            ),
            // 3. The Animated Bar
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: AnimatedNotchBottomBar(
                notchBottomBarController: _controller,
                color: Colors.grey.shade300,
                showLabel: true,
                shadowElevation: 5,
                kBottomRadius: 30.0,
                topMargin: 10,
                notchColor: AppColors.primary,

                // Handle Tap
                onTap: (index) async {
                  final homeCubit = context.read<HomelayoutCubit>();

                  if (AppSharedPreferences().getUserToken == null &&
                      index == 1) {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => const AccountTypePage()));
                  } else {
                    // When pressing the plus button (index 1), show bottom sheet
                    if (index == 1 &&
                        AppSharedPreferences().userType != 'personal') {
                      if (!mounted) return;

                      // Show account type selection bottom sheet
                      // await showAccountTypeBottomSheet(
                      //   context: context,
                      //   onAccountTypeSelected: (selectedType) {
                      //     // Change to add ads tab after selection
                      //     if (mounted) {
                      //       homeCubit.changeTabIndex(1);
                      //     }
                      //   },
                      // );
                    } else {
                      // For other tabs, just change normally
                      homeCubit.changeTabIndex(index);
                    }
                  }
                },

                kIconSize: 24.0,

                // 4. Bar Items [Left, Center, Right]
                // Since lists read Left-to-Right, the last item is on the Right.
                bottomBarItems: [
                  // Index 0: Left Side (Profile)
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

                  // Index 1: Center (Plus)
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

                  // Index 2: Right Side (Home)
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
            ),
          ),
        );
      },
    );
  }
}
