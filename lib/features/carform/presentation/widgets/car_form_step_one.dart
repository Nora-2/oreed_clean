import 'package:flutter/material.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/textstyle/appfonts.dart';
import 'package:oreed_clean/core/utils/shared_widgets/custom_form_field.dart';
import 'package:oreed_clean/features/company_types_by_company/presentation/widgets/select_sheet_field_ads.dart';
import 'package:oreed_clean/features/realstateform/presentation/widgets/SectionCard.dart';

class CarFormStepOne extends StatelessWidget {
  final TextEditingController titleCtrl;
  final String? brandName;
  final String? modelName;
  final String? yearSelected;
  final String? colorName;
  final String? governorateId;
  final String? cityId;
  final bool isLoadingModels;
  final VoidCallback onTapBrand;
  final VoidCallback onTapModel;
  final VoidCallback onTapYear;
  final VoidCallback onTapColor;
  final VoidCallback onTapState;
  final VoidCallback onTapCity;

  const CarFormStepOne({
    super.key,
    required this.titleCtrl,
    this.brandName,
    this.modelName,
    this.yearSelected,
    this.colorName,
    this.governorateId,
    this.cityId,
    required this.isLoadingModels,
    required this.onTapBrand,
    required this.onTapModel,
    required this.onTapYear,
    required this.onTapColor,
    required this.onTapState,
    required this.onTapCity,
  });

  @override
  Widget build(BuildContext context) {
    final appTrans = AppTranslations.of(context);
    final _blue = AppColors.primary;
    final _orange = AppColors.accentLight;

    return Column(
      children: [
        const SizedBox(height: 30),
        SectionCard(
          boxShadows: [
            BoxShadow(
                color: _blue.withValues(alpha: 0.12),
                blurRadius: 25,
                offset: const Offset(0, 12)),
            BoxShadow(
                color: _orange.withValues(alpha: 0.12),
                blurRadius: 25,
                offset: const Offset(0, 12)),
          ],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                controller: titleCtrl,
                hint: appTrans?.text('hint.car_example') ??
                    'Example: Toyota Corolla 2020',
                label: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: appTrans?.text('field.title') ?? 'Title',
                      ),
                      const TextSpan(
                        text: ' *',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
                validator: (String? p1) => null,
              ),
              const SizedBox(
                height: 30,
              ),
              SelectSheetFieldads(
                label: Text.rich(TextSpan(children: [
                  TextSpan(
                      text: appTrans?.text('field.brand') ?? 'الماركة',
                      style: AppFonts.body
                          .copyWith(fontWeight: FontWeight.w500, fontSize: 18)),
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.red),
                  )
                ])),
                onTap: onTapBrand,
                hint: brandName ??
                    (appTrans?.text('select.choose_brand') ?? 'Select Brand'),
              ),
              const SizedBox(
                height: 30,
              ),
              SelectSheetFieldads(
                label: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: (appTrans?.text('field.model') ?? 'الموديل'),
                        style: AppFonts.body.copyWith(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      const TextSpan(
                          text: ' *', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
                hint: isLoadingModels
                    ? (appTrans?.text('loading') ?? 'جاري التحميل...')
                    : (modelName ??
                        (appTrans?.text('select.choose_model') ??
                            'اختر الموديل')),
                onTap: onTapModel,
              ),
              const SizedBox(height: 30),
              SelectSheetFieldads(
                hint: yearSelected ??
                    (appTrans?.text('select.choose_year') ?? 'Select Year'),
                label: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                          text: appTrans?.text('field.year') ??
                              'Manufacture Year',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                onTap: onTapYear,
              ),
              const SizedBox(
                height: 30,
              ),
              SelectSheetFieldads(
                label: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                          text: appTrans?.text('field.color') ?? 'Color',
                          style: AppFonts.body.copyWith(
                              fontSize: 18, fontWeight: FontWeight.w500)),
                      const TextSpan(
                        text: '',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
                hint: colorName ??
                    (appTrans?.text('select.choose_color') ?? 'Select Color'),
                onTap: onTapColor,
              ),
              const SizedBox(height: 30),
              SelectSheetFieldads(
                label: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                          text: appTrans?.text('field.state') ??
                              'Governorate / City',
                          style: AppFonts.body.copyWith(
                              fontSize: 18, fontWeight: FontWeight.w500)),
                      const TextSpan(
                        text: ' *',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
                hint: governorateId ??
                    (appTrans?.text('select.choose_state') ??
                        'Select Governorate'),
                onTap: onTapState,
              ),
              const SizedBox(
                height: 30,
              ),
              SelectSheetFieldads(
                label: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                          text: appTrans?.text('field.city') ?? 'Region',
                          style: AppFonts.body.copyWith(
                              fontSize: 18, fontWeight: FontWeight.w500)),
                      const TextSpan(
                        text: ' *',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
                hint: cityId ??
                    (appTrans?.text('select.choose_city') ?? 'Select City'),
                onTap: onTapCity,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
