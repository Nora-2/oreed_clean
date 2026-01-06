import 'package:flutter/material.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onTap,
    required this.text,
    this.isLoading = false,
    this.font = 18,
  });

  final VoidCallback onTap;
  final bool isLoading;
  final String text;
  final double font;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Disable tap if loading
      onTap: isLoading ? null : onTap,
      child: Container(
        width: double.infinity,
        height: 55,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(30),
        ),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Empty SizedBox to balance the Icon on the right, keeping text centered
                    const SizedBox(width: 40),

                    // Text takes remaining space and centers
                    Expanded(
                      child: Text(
                        text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.whicolor,
                          fontSize: font,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // Arrow icon on the right
                     Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.whicolor,
                        child: Icon(
                          Icons.arrow_forward,
                          size: 30,
                          color: AppColors.secondary,
                        ),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
