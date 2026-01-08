import 'package:flutter/material.dart';
import 'package:oreed_clean/core/app_shared_prefs.dart';
import 'package:oreed_clean/core/routing/routes.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appimage/app_images.dart';

import 'package:oreed_clean/features/on_boarding/domain/entities/onboarding_page_entity.dart';
import 'package:oreed_clean/features/on_boarding/presentation/widgets/onboarding_slide.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with TickerProviderStateMixin {

  static const int _animationDurationMs = 600;

  final PageController _controller = PageController();
  late AnimationController _indicatorController;
  late AnimationController _fadeController;

  // List of pages to be initialized in build or didChangeDependencies
  List<OnboardingPageEntity> _pages = [];

  void _initPages(BuildContext context) {
    if (_pages.isNotEmpty) return;
    _pages = [
      OnboardingPageEntity(
        imageAsset: Appimage.onboardingScreen1,
        title:
            AppTranslations.of(context)!.text('onboarding_title_1') ,
        description:
            AppTranslations.of(context)!.text('onboarding_desc_1') ,
      ),
      OnboardingPageEntity(
        imageAsset: Appimage.onboardingScreen2,
        title:
            AppTranslations.of(context)!.text('onboarding_title_2') ,
        description:
            AppTranslations.of(context)!.text('onboarding_desc_2') ,
      ),
      OnboardingPageEntity(
        imageAsset: Appimage.onboardingScreen3,
        title:
            AppTranslations.of(context)!.text('onboarding_title_3') ,
        description:
            AppTranslations.of(context)!.text('onboarding_desc_3') ,
      ),
    ];
  }

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _indicatorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: _animationDurationMs),
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: _animationDurationMs),
    );

    // Start initial animations
    _fadeController.forward();
    _indicatorController.forward();
  }

  @override
  void dispose() {
    _indicatorController.dispose();
    _fadeController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _goNext() async {
    if (_currentIndex == _pages.length - 1) {
      await _completeAndGoHome();
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _goToAccountType() async {
    await _completeOnboarding();
    // Navigator.of(context).pushReplacement(
    //   MaterialPageRoute(
    //     builder: (_) => const AccountTypePage(),
    //   ),
    // );
  }

  Future<void> _completeAndGoHome() async {
    await _completeOnboarding();
    Navigator.of(context).pushReplacementNamed(
     Routes.homelayout
    );
  }

  Future<void> _completeOnboarding() async {
    await AppSharedPreferences().markOnboardingSeen();
  }

 

  @override
  Widget build(BuildContext context) {
    _initPages(context);
    return Scaffold(
      body: PageView.builder(
        controller: _controller,
        itemCount: _pages.length,
        onPageChanged: (index) {
          setState(() => _currentIndex = index);
          // Animation resets logic remains here if you plan to use it for transitions later
          _fadeController.reset();
          _indicatorController.reset();
          _fadeController.forward();
          _indicatorController.forward();
        },
        itemBuilder: (context, index) {
          final page = _pages[index];
          final bool isLast = index == _pages.length - 1;

          return OnboardingSlide(
            imageAsset: page.imageAsset,
            title: page.title,
            description: page.description,
            currentIndex: _currentIndex,
            total: _pages.length,
            onNext: _goNext,
            onSkip: _completeAndGoHome,
            isLast: isLast,
     
            onLoginPressed: _completeAndGoHome,
            onRegisterPressed: _goToAccountType,
          );
        },
      ),
    );
  }
}
