import 'package:flutter/material.dart';
import 'package:oreed_clean/core/utils/shared_widgets/shimmer.dart';

class Shimmercompany extends StatelessWidget {
  const Shimmercompany({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: const [
            Align(
              alignment: Alignment.centerLeft,
              child: ShimmerBox(height: 40, width: 40),
            ),
            SizedBox(height: 16),
            ShimmerBox(height: 180, width: double.infinity),
            SizedBox(height: 20),
            ShimmerBox(height: 40, width: 150),
          ],
        ),
      ),
    );
  }
}
