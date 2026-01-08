import 'package:flutter/material.dart';

class OnboardingBackground extends StatelessWidget {
  final String imageAsset;

  const OnboardingBackground({super.key, required this.imageAsset});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imageAsset,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }
}
