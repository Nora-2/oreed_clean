import 'package:flutter/material.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';

// ignore: must_be_immutable
class CircleBack extends StatelessWidget {
   CircleBack({super.key, required this.context,required this.background_color});

  final BuildContext context;
    Color? background_color=AppColors.whiteColor;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        decoration: BoxDecoration(
          color: background_color,
          borderRadius: BorderRadius.circular(25),
        ),
        padding: const EdgeInsets.all(6),
        child: Icon(Icons.arrow_back, color: AppColors.primary),
      ),
    );
  }
}
