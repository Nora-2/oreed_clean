import 'package:flutter/material.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';

class AuthToggleSelector extends StatelessWidget {
  final String leftLabel;
  final String rightLabel;
  final bool isLeftSelected;
  final Function(bool) onToggle;
  final bool isMobile;

  const AuthToggleSelector({
    super.key,
    required this.leftLabel,
    required this.rightLabel,
    required this.isLeftSelected,
    required this.onToggle,
    this.isMobile = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: AppColors.secondary),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          _buildTab(leftLabel, isLeftSelected),
          _buildTab(rightLabel, !isLeftSelected),
        ],
      ),
    );
  }

  Widget _buildTab(String text, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onToggle(isSelected),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: isMobile ? 12 : 15),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? AppColors.whicolor : AppColors.primary,
              fontSize: isMobile ? 14 : 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}