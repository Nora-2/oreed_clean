// filepath: /Volumes/Darc/projects/oreed/lib/core/widgets/shimmer.dart
import 'package:flutter/material.dart';

/// Lightweight shimmer/pulse effect without external packages.
class ShimmerPulse extends StatefulWidget {
  final Widget child;
  final Duration duration;
  const ShimmerPulse({super.key, required this.child, this.duration = const Duration(milliseconds: 1400)});

  @override
  State<ShimmerPulse> createState() => _ShimmerPulseState();
}

class _ShimmerPulseState extends State<ShimmerPulse> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)..repeat(reverse: true);
    _opacity = Tween<double>(begin: 0.45, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _opacity,
      builder: (_, __) => Opacity(opacity: _opacity.value, child: widget.child),
    );
  }
}

class ShimmerBox extends StatelessWidget {
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;
  final Color? color;

  const ShimmerBox({super.key, this.height, this.width, this.margin, this.padding, this.borderRadius, this.color});

  @override
  Widget build(BuildContext context) {
    final base = (color ?? Colors.grey.shade300);
    return ShimmerPulse(
      child: Container(
        height: height,
        width: width,
        margin: margin,
        padding: padding,
        decoration: BoxDecoration(
          color: base,
          borderRadius: borderRadius ?? BorderRadius.circular(10),
        ),
      ),
    );
  }
}

