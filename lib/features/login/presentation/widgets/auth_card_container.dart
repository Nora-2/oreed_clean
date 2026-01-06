import 'package:flutter/material.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';

class AuthCardContainer extends StatelessWidget {
  final Widget child;
  final double horizontalPadding;

  const AuthCardContainer({
    super.key,
    required this.child,
    this.horizontalPadding = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 20),
      decoration:  BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        border: Border(
          top: BorderSide(color: AppColors.secondary, width: 2),
        ),
      ),
      child: child,
    );
  }
}