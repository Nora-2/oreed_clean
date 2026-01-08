import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:oreed_clean/core/app_shared_prefs.dart';
import 'package:oreed_clean/features/home/presentation/pages/home_screen.dart';
import 'package:oreed_clean/features/on_boarding/presentation/pages/onboarding_screen.dart';
import 'package:oreed_clean/features/splash/widgets/glow_blob_painter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _bgCtrl;
  late final AnimationController _logoCtrl;
  late final AnimationController _textCtrl;
  late final AnimationController _shineCtrl;
  Timer? _navTimer;

  @override
  void initState() {
    super.initState();

    // خلفية هادئة متحركة
    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat(reverse: true);

    // نبض اللوجو + شين
    _logoCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

   
    _shineCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    // ظهور الاسم + مسافات الحروف
    _textCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    // تايمينج بسيط
    Timer(const Duration(milliseconds: 450), () => _textCtrl.forward());
    _navTimer = Timer(const Duration(milliseconds: 2400), () {
      if (mounted) _goNext();
    });
  }

  Future<void> _goNext() async {
    if (!mounted) return;

    try {
      final prefs = AppSharedPreferences();
      await prefs.initSharedPreferencesProp();

      debugPrint('✅ Splash: prefs loaded');
      debugPrint(
        '📌 Cached: appOnOff=${prefs.appOnOff}, '
        'android=${prefs.cachedAndroidVersion}, ios=${prefs.cachedIosVersion}',
      );

      bool shouldShowUpdate = false;

      debugPrint('📌 shouldShowUpdate=$shouldShowUpdate');

      // ✅ Normal flow
      final goOnboarding = !prefs.hasSeenOnboarding;
      debugPrint('➡️ goOnboarding=$goOnboarding');

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (_, __, ___) =>
              goOnboarding ? const OnboardingPage() : const HomeScreen(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
        ),
      );
    } catch (e, st) {
      debugPrint('❌ Splash _goNext error: $e');
      debugPrint(st.toString());

      // fallback: just continue to home/onboarding so app never stuck
      if (!mounted) return;
      final prefs = AppSharedPreferences();
      final goOnboarding = !prefs.hasSeenOnboarding;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) =>
              goOnboarding ? const OnboardingPage() : const HomeScreen(),
        ),
      );
    }
  }



  @override
  void dispose() {
    _bgCtrl.dispose();
    _logoCtrl.dispose();
    _textCtrl.dispose();
    _shineCtrl.dispose();
    _navTimer?.cancel(); // ✅ مهم

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // لايت فقط — درجات ثابتة
    const bgStart = Color(0xFF3964D3);
    const bgEnd = Color(0xFF3964D3);
    const blob1 = Color(0xFF8B5CF6); // بنفسجي فاتح
    const blob2 = Color(0xFF22D3EE); // سماوي فاتح
    return Scaffold(
      backgroundColor: const Color(0xFF3964D3),
      body: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _bgCtrl,
          builder: (_, __) {
            return CustomPaint(
              painter: GlowBlobsPainter(
                progress: _bgCtrl.value,
                base: blob1,
                alt: blob2,
              ),
              child: Container(
                decoration:  BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xffffffff),Color(0xffffffff)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Center(
                    child: ClipOval(
                      child: Lottie.asset(
                        'assets/images/logo_animation.json',
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        repeat: true,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
