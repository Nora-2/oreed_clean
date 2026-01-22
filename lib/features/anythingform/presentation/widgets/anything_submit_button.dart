import 'package:flutter/material.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/shared_widgets/custom_button.dart';

class AnythingSubmitButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;

  const AnythingSubmitButton({
    super.key,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final appTrans = AppTranslations.of(context);
    return CustomButton(
      text: isLoading
          ? (appTrans?.text('action.sending') ?? 'Sending...')
          : (appTrans?.text('action.review_data') ?? 'Review all data'),
      onTap: isLoading ? () {} : onTap,
    );
  }
}
