import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:oreed_clean/core/app_shared_prefs.dart';
import 'package:oreed_clean/core/routing/routes.dart';
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

    final goOnboarding = !prefs.hasSeenOnboarding;

    if (!mounted) return;

    Navigator.of(context).pushReplacementNamed(
      goOnboarding ? Routes.onboarding : Routes.homelayout,
    );
  } catch (e, st) {
    debugPrint('❌ Splash _goNext error: $e');
    debugPrint(st.toString());

    if (!mounted) return;

    final prefs = AppSharedPreferences();
    final goOnboarding = !prefs.hasSeenOnboarding;

    Navigator.of(context).pushReplacementNamed(
      goOnboarding ? Routes.onboarding : Routes.homelayout,
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
