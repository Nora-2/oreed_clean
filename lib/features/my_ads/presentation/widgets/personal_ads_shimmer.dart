
import 'package:flutter/material.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/shared_widgets/shimmer.dart';

class UserAdsSectionShimmer extends StatelessWidget {
  const UserAdsSectionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12),

        // Stats row shimmer
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(3, (index) {
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2),
                ),
              ),
              child:  Column(
                children: [
                  ShimmerBox(
                    height: 24,
                    width: 40,
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                  SizedBox(height: 6),
                  ShimmerBox(
                    height: 14,
                    width: 60,
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                ],
              ),
            );
          }),
        ),
        const SizedBox(height: 20),

        // Ads grid shimmer
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.71,
          ),
          itemCount: 4,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Image shimmer
                   ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(14),
                    ),
                    child: ShimmerBox(
                      height: 120,
                      width: double.infinity,
                    ),
                  ),

                  // Content shimmer
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title shimmer
                        ShimmerBox(
                          height: 16,
                          width: double.infinity,
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        const SizedBox(height: 8),
                        const ShimmerBox(
                          height: 16,
                          width: 100,
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        const SizedBox(height: 12),

                        // Price shimmer
                         Row(
                          children: [
                            ShimmerBox(
                              width: 18,
                              height: 18,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                            ),
                            SizedBox(width: 8),
                            ShimmerBox(
                              height: 18,
                              width: 80,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Status badge shimmer
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const ShimmerBox(
                            height: 20,
                            width: 60,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
