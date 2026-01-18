import 'package:flutter/material.dart';// Import BlocProvider
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:glasses/core/routing/routes.dart';
import 'package:glasses/core/utils/appcolors/app_colors.dart';
import 'package:glasses/core/utils/appimage/app_images.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  _navigateToNextScreen() async {
    await Future.delayed(
      const Duration(seconds: 1),
    ); // Hold splash for 1 second

    if (mounted) {
      FlutterNativeSplash.remove();
              Navigator.pushReplacementNamed(context, Routes.onboarding
    );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: appcolors.transcolor, elevation: 0),
      extendBodyBehindAppBar: true,
      body: Scaffold(
        body: Image.asset(
          Appimage.splach,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
