// widgets/car_form_header.dart
import 'package:flutter/material.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';

class CarFormHeader extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final VoidCallback onBack;
  final Function(int) onStepTap;

  const CarFormHeader({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.onBack,
    required this.onStepTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildBackButton(),
          const Spacer(),
          ..._buildStepIndicators(),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: onBack,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xffe8e8e9),
          borderRadius: BorderRadius.circular(25),
        ),
        padding: const EdgeInsets.all(6),
        child: Icon(Icons.arrow_back, color: AppColors.primary),
      ),
    );
  }

  List<Widget> _buildStepIndicators() {
    return List.generate(totalSteps, (index) {
      final step = index + 1;
      final isActive = step == currentStep;
      final isCompleted = step < currentStep;

      return Row(
        children: [
          GestureDetector(
            onTap: step < currentStep ? () => onStepTap(step) : null,
            child: _buildStepCircle(step, isActive, isCompleted),
          ),
          if (step < totalSteps) _buildStepConnector(isCompleted),
        ],
      );
    });
  }

  Widget _buildStepCircle(int step, bool isActive, bool isCompleted) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isActive
              ? AppColors.grey.withValues(alpha: 0.2)
              : (isCompleted ? AppColors.primary : AppColors.grey.withOpacity(.2)),
          width: 2,
        ),
        color: isActive
            ? Colors.white
            : (isCompleted ? AppColors.primary : Colors.white),
        boxShadow: [
          if (isCompleted)
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.25),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Center(
        child: isCompleted
            ? Icon(Icons.check, color: AppColors.secondary, size: 20)
            : Text(
                '$step',
                style: TextStyle(
                  color: isActive ? AppColors.primary : Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
      ),
    );
  }

  Widget _buildStepConnector(bool isCompleted) {
    return Container(
      width: isCompleted ? 8 : 5,
      height: 2,
      color: isCompleted
          ? AppColors.grey.withOpacity(.2)
          : Colors.transparent,
    );
  }
}
