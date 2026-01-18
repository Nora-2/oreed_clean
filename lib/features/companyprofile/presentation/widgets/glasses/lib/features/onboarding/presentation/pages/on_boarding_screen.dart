import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glasses/core/utils/appcolors/app_colors.dart';
import 'package:glasses/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:glasses/features/onboarding/presentation/widgets/onboarding_item.dart' show onboardingPages;
import 'package:glasses/features/onboarding/presentation/widgets/onboarding_widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  bool _imagesPrecached = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_imagesPrecached) {
      _precacheOnboardingImages();
      _imagesPrecached = true;
    }
  }

  void _precacheOnboardingImages() {
    for (var page in onboardingPages) {
      precacheImage(AssetImage(page.imageUrl), context);
    }
    debugPrint('Onboarding images precached!');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _animateToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 100),
      curve: Curves.bounceIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appcolors.black,
      body: BlocConsumer<OnboardingCubit, OnboardingState>(
        listener: (context, state) {
          if (state is OnboardingPageChanged) {
            _animateToPage(state.pageIndex);
          }
        },
        builder: (context, state) {
          // ignore: unused_local_variable
          int currentPageIndex = 0;
          if (state is OnboardingPageChanged) {
            currentPageIndex = state.pageIndex;
          }

          return PageView.builder(
            reverse: true,
            controller: _pageController,
            physics: const BouncingScrollPhysics(),
            itemCount: onboardingPages.length,
            onPageChanged: (index) {
              context.read<OnboardingCubit>().changePage(index);
            },
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double value = 0.0;
                  double opacity = 1.0;

                  if (_pageController.position.haveDimensions) {
                    value = _pageController.page! - index;
                    opacity = (1 - value.abs()).clamp(0.2, 1.0);
                  }

                  return Opacity(
                    opacity: opacity,
                    child: Transform.translate(
                      offset: Offset(value * 100, 0),
                      child: buildOnboardingPage(
                        context,
                        onboardingPages[index],
                        index,
                        onboardingPages.length,
                        _pageController,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}