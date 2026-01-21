import 'package:flutter/material.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/textstyle/appfonts.dart';
import 'package:oreed_clean/core/utils/shared_widgets/custom_form_field.dart';
import 'package:oreed_clean/features/company_types_by_company/presentation/widgets/select_sheet_field_ads.dart';
import 'package:oreed_clean/features/realstateform/presentation/widgets/SectionCard.dart';
import 'option_radio_group.dart';

class CarFormStepTwo extends StatelessWidget {
  final TextEditingController priceCtrl;
  final TextEditingController kmCtrl;
  final String? engineCc;
  final String? gear;
  final String? fuel;
  final String? condition;
  final String? paint;
  final VoidCallback onTapEngine;
  final ValueChanged<String?> onGearChanged;
  final ValueChanged<String?> onFuelChanged;
  final ValueChanged<String?> onConditionChanged;
  final ValueChanged<String?> onPaintChanged;

  const CarFormStepTwo({
    super.key,
    required this.priceCtrl,
    required this.kmCtrl,
    this.engineCc,
    this.gear,
    this.fuel,
    this.condition,
    this.paint,
    required this.onTapEngine,
    required this.onGearChanged,
    required this.onFuelChanged,
    required this.onConditionChanged,
    required this.onPaintChanged,
  });

  String _tr(AppTranslations? t, String key, String fb) => t?.text(key) ?? fb;

  Widget _buildRadioOption({
    required BuildContext context,
    required String label,
    required String value,
    required String? groupValue,
    required ValueChanged<String?> onChanged,
  }) {
    return OptionRadioGroup(
      label: label,
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    final appTrans = AppTranslations.of(context);
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Column(
      children: [
        const SizedBox(height: 20),
        SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Condition
              AppTextField(
                controller: priceCtrl,
                hint: appTrans?.text('hint.price_example') ??
                    '300 ${appTrans?.text('currency_kwd') ?? 'KWD'}',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                label: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: appTrans?.text('field.price') ?? 'Price'),
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

              const SizedBox(
                height: 30,
              ),
              AppTextField(
                controller: kmCtrl,
                hint: appTrans?.text('hint.km_counter') ??
                    'KM Counter (Optional)',
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: false, signed: false),
                label: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: appTrans?.text('field.km') ?? 'Kilometers (KM)',
                      ),
                      const TextSpan(
                        text: '',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
                validator: (String? p1) {
                  return null;
                },
              ),

              const SizedBox(height: 20),

              SelectSheetFieldads(
                hint: engineCc ??
                    (appTrans?.text('select.choose_engine') ?? 'Select Engine'),
                label: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                          text: appTrans?.text('field.engine_size') ??
                              'Engine CC',
                          style: AppFonts.body.copyWith(
                              fontWeight: FontWeight.w500, fontSize: 18)),
                      const TextSpan(
                        text: '',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
                onTap: onTapEngine,
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Label
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: appTrans?.text('field.gear') ?? 'Transmission',
                          style: AppFonts.body.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        const TextSpan(
                          text: '',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Radio buttons in a row
                  Row(
                    children: [
                      _buildRadioOption(
                        context: context,
                        label: _tr(appTrans, 'options.gear.manual', 'Manual'),
                        value: 'manual',
                        groupValue: gear,
                        onChanged: onGearChanged,
                      ),
                      const SizedBox(width: 50),
                      _buildRadioOption(
                        context: context,
                        label: _tr(
                            appTrans, 'options.gear.automatic', 'Automatic'),
                        value: 'automatic',
                        groupValue: gear,
                        onChanged: onGearChanged,
                      ),
                      const SizedBox(width: 100),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Label
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: appTrans?.text('field.fuel') ?? 'Fuel Type',
                          style: AppFonts.body.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        const TextSpan(
                          text: '',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Radio buttons in a row
                  Row(
                    children: [
                      _buildRadioOption(
                        context: context,
                        label: _tr(appTrans, 'options.fuel.petrol', 'Petrol'),
                        value: 'petrol',
                        groupValue: fuel,
                        onChanged: onFuelChanged,
                      ),
                      isRTL
                          ? const SizedBox(width: 30)
                          : const SizedBox(width: 20),
                      _buildRadioOption(
                        context: context,
                        label: _tr(appTrans, 'options.fuel.diesel', 'Diesel'),
                        value: 'diesel',
                        groupValue: fuel,
                        onChanged: onFuelChanged,
                      ),
                      isRTL
                          ? const SizedBox(width: 30)
                          : const SizedBox(width: 20),
                      _buildRadioOption(
                        context: context,
                        label: _tr(appTrans, 'options.fuel.hybrid', 'Hybrid'),
                        value: 'hybrid',
                        groupValue: fuel,
                        onChanged: onFuelChanged,
                      ),
                      isRTL
                          ? const SizedBox(width: 30)
                          : const SizedBox(width: 20),
                      _buildRadioOption(
                        context: context,
                        label:
                            _tr(appTrans, 'options.fuel.electric', 'Electric'),
                        value: 'electric',
                        groupValue: fuel,
                        onChanged: onFuelChanged,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Label
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text:
                              appTrans?.text('field.condition') ?? 'Condition',
                          style: AppFonts.body.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        const TextSpan(
                          text: '',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Radio buttons in a row
                  Row(
                    children: [
                      _buildRadioOption(
                        context: context,
                        label: _tr(appTrans, 'options.condition.new', 'New'),
                        value: 'new',
                        groupValue: condition,
                        onChanged: onConditionChanged,
                      ),
                      const SizedBox(width: 50),
                      _buildRadioOption(
                        context: context,
                        label: _tr(appTrans, 'options.condition.used', 'Used'),
                        value: 'used',
                        groupValue: condition,
                        onChanged: onConditionChanged,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Label
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: appTrans?.text('field.paint') ??
                              'Paint Condition',
                          style: AppFonts.body.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        const TextSpan(
                          text: '',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Radio buttons in a row
                  Row(
                    children: [
                      _buildRadioOption(
                        context: context,
                        label: _tr(
                            appTrans, 'options.paint.agency', 'Agency Paint'),
                        value: 'agency',
                        groupValue: paint,
                        onChanged: onPaintChanged,
                      ),
                      isRTL
                          ? const SizedBox(width: 10)
                          : const SizedBox(width: 3),
                      _buildRadioOption(
                        context: context,
                        label: _tr(appTrans, 'options.paint.partially_painted',
                            'Partially Painted'),
                        value: 'partially_painted',
                        groupValue: paint,
                        onChanged: onPaintChanged,
                      ),
                      isRTL
                          ? const SizedBox(width: 10)
                          : const SizedBox(width: 3),
                      _buildRadioOption(
                        context: context,
                        label: _tr(appTrans, 'options.paint.fully_painted',
                            'Fully Painted'),
                        value: 'fully_painted',
                        groupValue: paint,
                        onChanged: onPaintChanged,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }
}
