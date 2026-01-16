import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/features/settings/presentation/widgets/thankyouback.dart';

class ThankYou extends StatefulWidget {
  static String routeName = "/ThankYou";

  final String? screenTitle;
  final String? title1;
  final String? title2;

  /// Optional primary action label and handler. If not provided, a default "Done" will pop.
  final String? actionLabel;
  final VoidCallback? onAction;

  const ThankYou({
    super.key,
    this.screenTitle,
    this.title1,
    this.title2,
    this.actionLabel,
    this.onAction,
  });

  @override
  State<ThankYou> createState() => _ThankYouState();
}

class _ThankYouState extends State<ThankYou> {
  double _scale = 0.9;
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    // Subtle entrance animation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {
        _scale = 1.0;
        _opacity = 1.0;
      });
    });
  }

  Future<void> _onImageTap() async {
    // Tiny bounce + haptic
    HapticFeedback.selectionClick();
    if (!mounted) return;
    setState(() => _scale = 0.96);
    await Future.delayed(const Duration(milliseconds: 90));
    if (!mounted) return;
    setState(() => _scale = 1.0);
  }

  void _onPrimaryAction(AppTranslations t) {
    final cb = widget.onAction;
    if (cb != null) {
      cb();
      return;
    }
    // default: pop
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppTranslations.of(context)!;
    final title = widget.screenTitle ?? "";
    final primaryText = widget.title1 ?? t.text('thank_you');
    final secondaryText = widget.title2; // optional

    return HomeBackGroundWidget(
      title: title,
      hasBack: true,
      hasScrool: false,
      notHasImage: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 16.0),

            // Decorative halo behind illustration
            AnimatedOpacity(
              duration: const Duration(milliseconds: 450),
              curve: Curves.easeOut,
              opacity: _opacity,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(
                        0xFF34D399,
                      ).withValues(alpha: 0.20), // emerald-300
                      Colors.transparent,
                    ],
                    radius: 0.85,
                  ),
                ),
                alignment: Alignment.center,
                child: AnimatedScale(
                  scale: _scale,
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutBack,
                  child: GestureDetector(
                    onTap: _onImageTap,
                    child: Image.asset(
                      'assets/images/thanku.png',
                      height: 90.0,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24.0),

            // Primary text
            AnimatedOpacity(
              duration: const Duration(milliseconds: 380),
              curve: Curves.easeOut,
              opacity: _opacity,
              child: Text(
                primaryText,
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
            ),

            if (secondaryText != null && secondaryText.trim().isNotEmpty) ...[
              const SizedBox(height: 10.0),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 450),
                curve: Curves.easeOut,
                opacity: _opacity,
                child: Text(
                  secondaryText,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 28.0),

            // CTA button
            AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut,
              opacity: _opacity,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _onPrimaryAction(t),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_circle_rounded),
                      const SizedBox(width: 8),
                      Text(
                        widget.actionLabel ?? t.text('action.done'),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32.0),
          ],
        ),
      ),
    );
  }
}
