import 'package:flutter/material.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/shared_widgets/custom_form_field.dart';

class AnythingFormFields extends StatelessWidget {
  final TextEditingController titleCtrl;
  final TextEditingController priceCtrl;
  final TextEditingController descCtrl;

  const AnythingFormFields({
    super.key,
    required this.titleCtrl,
    required this.priceCtrl,
    required this.descCtrl,
  });

  @override
  Widget build(BuildContext context) {
    final appTrans = AppTranslations.of(context);
    return Column(
      children: [
        AppTextField(
          controller: titleCtrl,
          hint: appTrans?.text('hint.title') ?? 'Enter a clear title',
          label: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: appTrans?.text('field.ad_title') ?? 'Ad Title',
                ),
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
          validator: (String? p1) {
            return null;
          },
        ),
        const SizedBox(height: 30),
        AppTextField(
          controller: priceCtrl,
          hint: appTrans?.text('hint.price_example') ??
              '0.0 ${appTrans?.text('currency_kwd') ?? 'KWD'}',
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
          ),
          label: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: appTrans?.text('field.price') ?? 'السعر',
                ),
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
          validator: (p) {
            return null;
          },
        ),
        const SizedBox(height: 30),
        AppTextField(
          controller: descCtrl,
          hint: appTrans?.text('hint.description') ??
              'Write service/product details...',
          label: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: appTrans?.text('field.description') ?? 'Description',
                ),
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
          min: 5,
          max: 10,
          keyboardType: TextInputType.multiline,
          validator: (String? p1) {
            return null;
          },
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
