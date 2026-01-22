import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oreed_clean/core/enmus/enum.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appicons/app_icons.dart';
class AdTypeBadge extends StatelessWidget {
  final AdType type;
  final bool dense;
  final double radius;

  const AdTypeBadge({
    super.key,
    required this.type,
    this.dense = false,
    this.radius = 999,
  });

  @override
  Widget build(BuildContext context) {
     final isRTL = Directionality.of(context) == TextDirection.rtl;
  
    final style = _AdTypeStyle.of(type, context);
    return type == AdType.free
        ? Container()
        : Row(
            textDirection: isRTL ? TextDirection.ltr : TextDirection.rtl,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: style.backcolor,
                ),
                child: Text(
                  style.label,
                  style: TextStyle(
                    fontSize: dense ? 11 : 13,
                    fontWeight: FontWeight.w800,
                    color: style.fg,
                    letterSpacing: .2,
                  ),
                ),
              ),
              const SizedBox(width: 2,),
              SvgPicture.asset(
                style.icon,
                height: 26,
                width: 26,
              ),
            ],
          );
  }
}

class _AdTypeStyle {
  final String label;
  final String icon;
  final Color fg;
  final Color? color;
  final Color? backcolor;

  final BoxBorder? border;
  final List<BoxShadow>? shadow;

  _AdTypeStyle({
    required this.label,
    required this.icon,
    required this.fg,
    this.color,
    this.backcolor,
    this.border,
    this.shadow,
  });

  static _AdTypeStyle of(AdType t, BuildContext context) {
    final tr = AppTranslations.of(context);

    switch (t) {
      case AdType.free:
        return _AdTypeStyle(
          label: tr?.text('ad_type.free') ?? 'Free',
          icon: '',
          fg: const Color(0xFF111827),
          color: const Color(0xFFF7F8FA),
          border: Border.all(color: const Color(0xFFE6E8EC)),
          shadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        );

      case AdType.featured:
        return _AdTypeStyle(
            label: tr?.text('ad_type.featured') ?? 'Featured',
            icon: AppIcons.star,
            fg: Colors.white,
            backcolor: const Color(
              0xff8133F1,
            ));

      case AdType.pinned:
        return _AdTypeStyle(
            label: tr?.text('ad_type.pinned') ?? 'Pinned',
            icon: AppIcons.pin,
            fg: const Color(0xFFF7F8FA),
            backcolor: const Color(0xffFF8A00));
    }
  }
}

class AdTypeCornerRibbon extends StatelessWidget {
  final AdType type;
  final double size; // width/height of the corner area
  final double angle; // ribbon tilt

  const AdTypeCornerRibbon({
    super.key,
    required this.type,
    this.size = 72,
    this.angle = -0.75, // radians ~ -43°
  });

  @override
  Widget build(BuildContext context) {
    final s = _AdTypeStyle.of(type, context);

    final deco = BoxDecoration(
      color: s.color,
      boxShadow: s.shadow,
      borderRadius: const BorderRadius.only(
        bottomRight: Radius.circular(12),
      ),
    );

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          // clipped triangle corner
          Align(
            alignment: Alignment.topLeft,
            child: ClipPath(
              clipper: _CornerClipper(),
              child: Container(decoration: deco),
            ),
          ),
          // tilted label
          Positioned(
            top: 16,
            left: -8,
            child: Transform.rotate(
              angle: angle,
              child: Row(
                children: [
                  SvgPicture.asset(s.icon),
                  const SizedBox(width: 6),
                  Text(
                    s.label,
                    style: TextStyle(
                      color: s.fg,
                      fontWeight: FontWeight.w800,
                      fontSize: 11,
                      letterSpacing: .3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CornerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // makes a diagonal triangle in the top-left
    return Path()
      ..lineTo(size.width, 0)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
