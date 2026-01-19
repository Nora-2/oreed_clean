// widgets/step_indicator.dart
import 'package:flutter/material.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final VoidCallback? onTap;

  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.onTap,
  });

  static List<Widget> buildIndicators({
    required int currentStep,
    required int totalSteps,
    required Function(int) onStepTap,
  }) {
    return List.generate(totalSteps, (index) {
      final step = index + 1;
      final isActive = step == currentStep;
      final isCompleted = step < currentStep;

      return Row(
        children: [
          GestureDetector(
            onTap: step < currentStep ? () => onStepTap(step) : null,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isActive
                      ? AppColors.grey.withOpacity(.2)
                      : (isCompleted
                            ? AppColors.primary
                            : AppColors.grey.withOpacity(.2)),
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
            ),
          ),
          if (step < totalSteps)
            isCompleted
                ? Container(
                    width: 8,
                    height: 2,
                    color: AppColors.grey.withOpacity(.2),
                  )
                : const SizedBox(width: 5),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary,
        ),
        child: Center(
          child: Text(
            '$currentStep',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
