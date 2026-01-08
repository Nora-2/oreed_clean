import 'package:flutter/material.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/shared_widgets/circelback.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isMobile;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.isMobile = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
           Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [CircleBack(context: context,background_color: AppColors.whiteColor,)],
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 25 : 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: isMobile ? 14 : 16,
            ),
          ),
        ],
      ),
    );
  }
}