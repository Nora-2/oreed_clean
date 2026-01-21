// widgets/car_form_navigation.dart
import 'package:flutter/material.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/shared_widgets/custom_button.dart';

class CarFormNavigation extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final bool isLoading;
  final bool isEditing;
  final VoidCallback onNext;

  const CarFormNavigation({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.isLoading,
    required this.isEditing,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final appTrans = AppTranslations.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: CustomButton(
              isLoading: isLoading,
              font: 14,
              onTap: onNext,
              text: _getButtonText(appTrans),
            ),
          ),
        ],
      ),
    );
  }

  String _getButtonText(AppTranslations? appTrans) {
    if (currentStep == 1) {
      return appTrans?.text('action.next_specs') ?? 'Next : Specs and Price';
    } else if (currentStep == 2) {
      return appTrans?.text('action.next_desc') ?? 'Next : Description and Media';
    } else {
      return isEditing
          ? (appTrans?.text('action.save_changes') ?? 'Save')
          : (appTrans?.text('action.review_data') ?? 'Review all data');
    }
  }
}
