// widgets/navigation_buttons.dart
import 'package:flutter/material.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/shared_widgets/custom_button.dart';

class NavigationButtons extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final bool isEditing;
  final bool isValid;
  final Future<void> Function() onNext;

  const NavigationButtons({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.isEditing,
    required this.isValid,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final appTrans = AppTranslations.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (currentStep > 1) const SizedBox(width: 12),
          Expanded(
            flex: currentStep > 1 ? 1 : 2,
            child: CustomButton(
              font: 15,
              onTap: onNext,
              text: _getButtonText(appTrans),
            ),
          ),
        ],
      ),
    );
  }

  String _getButtonText(AppTranslations? appTrans) {
    if (currentStep < totalSteps) {
      return appTrans?.text('action.next_desc') ??
          'Next: Description and Media';
    }

    if (isEditing) {
      return appTrans?.text('action.save_changes') ?? 'Save Changes';
    }

    return appTrans?.text('action.review') ?? 'Review';
  }
}
