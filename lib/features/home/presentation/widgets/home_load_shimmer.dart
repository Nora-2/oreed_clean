
import 'package:flutter/material.dart';

class _ShimmerBox extends StatelessWidget {
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final BorderRadiusGeometry? borderRadius;

  const _ShimmerBox({
    this.height,
    this.width,
    this.margin,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
    );
  }
}

class _ShimmerCircle extends StatelessWidget {
  final double size;

  const _ShimmerCircle({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey,
      ),
    );
  }
}

/// Shimmer loading state
class LoadingShimmer extends StatefulWidget {
  final bool isTablet;

  const LoadingShimmer({super.key, required this.isTablet});

  @override
  State<LoadingShimmer> createState() => LoadingShimmerState();
}

class LoadingShimmerState extends State<LoadingShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  double get bannerHeight => widget.isTablet ? 220 : 180;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ===== Header Shimmer =====
                Padding(
                  padding: EdgeInsets.all(widget.isTablet ? 20 : 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const _ShimmerCircle(size: 40),
                          _ShimmerBox(
                            height: 25,
                            width: 25,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _ShimmerBox(height: 12, width: 140),
                      const SizedBox(height: 8),
                      _ShimmerBox(height: 18, width: 200),
                      const SizedBox(height: 16),
                      _ShimmerBox(
                        height: 48,
                        width: double.infinity,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ],
                  ),
                ),

                /// ===== Banner Shimmer =====
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      _ShimmerBox(
                        height: bannerHeight,
                        width: double.infinity,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          3,
                          (_) => _ShimmerBox(
                            height: 6,
                            width: 11,
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                /// ===== Categories Grid Shimmer =====
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: 8,
                    itemBuilder: (_, i) => Column(
                      children: [
                        _ShimmerBox(
                          height: 60,
                          width: 60,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        const SizedBox(height: 6),
                        _ShimmerBox(height: 10, width: 40),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                /// ===== Ads / Products Shimmer =====
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: List.generate(
                      2,
                      (_) => _ShimmerBox(
                        height: 200,
                        margin: const EdgeInsets.only(bottom: 16),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
