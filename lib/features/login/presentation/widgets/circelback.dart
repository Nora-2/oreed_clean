
import 'package:flutter/material.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';

class CircleBack extends StatelessWidget {
  const CircleBack({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: AppColors.whicolor,
                            borderRadius: BorderRadius.circular(25)),
                        padding: const EdgeInsets.all(6),
                        child:  Icon(
                          Icons.arrow_back,
                          color: AppColors.primary,
                        ),
                      ),
                    );
  }
}
