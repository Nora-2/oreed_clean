import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/appicons/app_icons.dart';
import 'package:oreed_clean/core/utils/appstring/app_string.dart';
import 'package:oreed_clean/core/utils/bottomsheets/option_sheet_register_list.dart';
import 'package:oreed_clean/core/utils/option_item_register.dart';
import 'package:oreed_clean/core/utils/shared_widgets/custom_button.dart';
import 'package:oreed_clean/core/utils/shared_widgets/custom_form_field.dart';
import 'package:oreed_clean/features/comapany_register/domain/entities/category_entity.dart';
import 'package:oreed_clean/features/comapany_register/domain/entities/country_entity.dart';
import 'package:oreed_clean/features/comapany_register/domain/entities/state_entity.dart';
import 'package:oreed_clean/features/comapany_register/presentation/cubit/comapany_register_cubit.dart';
import 'package:oreed_clean/features/comapany_register/presentation/cubit/comapany_register_state.dart';
import 'package:oreed_clean/features/comapany_register/presentation/widgets/category_picker.dart';
import 'package:oreed_clean/features/comapany_register/presentation/widgets/select_field.dart';
import 'package:oreed_clean/features/home/domain/entities/section_entity.dart';
import 'package:oreed_clean/features/login/presentation/widgets/custom_apptextfield.dart';
import 'package:oreed_clean/features/login/presentation/widgets/custom_phonefield.dart';

class CompanyRegistrationForm extends StatelessWidget {
  const CompanyRegistrationForm({
    super.key,
    required this.companyNameController,
    required this.mobileController,
    required this.whatsappController,
    required this.passwordController,
    required this.isPasswordHidden,
    required this.selectedCountry,
    required this.selectedGovernorate,
    required this.selectedMainCategory,
    required this.selectedSubCategory,
    required this.onCountrySelected,
    required this.onGovernorateSelected,
    required this.onMainCategorySelected,
    required this.onSubCategorySelected,
    required this.onSubmit,
  });

  final TextEditingController companyNameController;
  final TextEditingController mobileController;
  final TextEditingController whatsappController;
  final TextEditingController passwordController;

  final bool isPasswordHidden;

  final CountryEntity? selectedCountry;
  final StateEntity? selectedGovernorate;
  final SectionEntity? selectedMainCategory;
  final CategoryEntity? selectedSubCategory;

  final ValueChanged<CountryEntity> onCountrySelected;
  final ValueChanged<StateEntity> onGovernorateSelected;
  final ValueChanged<SectionEntity> onMainCategorySelected;
  final ValueChanged<CategoryEntity> onSubCategorySelected;

  final VoidCallback onSubmit;

  // ---------- helpers ----------
  Color _tagColor(int i) =>
      i.isEven ? AppColors.primary : AppColors.secondary;

  List<CategoryEntity> _getSubCats(CompanyRegisterState state) {
    if (selectedMainCategory?.id == 1) return state.categoriesCars;
    if (selectedMainCategory?.id == 2) return state.categoriesProperties;
    if (selectedMainCategory?.id == 3) return state.categoriesTechnicians;
    return state.categoriesAnyThing;
  }

  @override
  Widget build(BuildContext context) {
    final t = AppTranslations.of(context);

    return BlocBuilder<CompanyRegisterCubit, CompanyRegisterState>(
      builder: (context, state) {
        return Column(
          children: [
            AppTextField(
              hint: t?.text(AppString.companyNameHint) ?? 'Company Name',
              controller: companyNameController,
              label: Text(t?.text('company_name_label') ?? 'Company Name'), validator: (String? p1) {
                return null;
                },
            ),
            const SizedBox(height: 20),

            PhoneField(
              controller: mobileController,
              labletext: t?.text('phone_label') ?? 'Phone',
              lablehint: t?.text(AppString.phoneHint) ?? 'Phone', validator: (String? p1) {
                return null;
                },
            ),
            const SizedBox(height: 20),

            PhoneField(
              controller: whatsappController,
              labletext: t?.text('whatsapp_label') ?? 'WhatsApp',
              lablehint: t?.text(AppString.whatsappHint) ?? 'WhatsApp', validator: (String? p1) {
                return null;
                },
            ),
            const SizedBox(height: 20),

            PasswordField(
              controller: passwordController,
              isHidden: isPasswordHidden,
              labelText: t?.text('password_label') ?? 'Password',
            ),
            const SizedBox(height: 20),

            /// ---------------- COUNTRY ----------------
            FormField<CountryEntity>(
              validator: (_) => selectedCountry == null ? 'Required' : null,
              builder: (field) => SelectField(
                label: t?.text('governorate') ?? 'الدولة',
                value: selectedCountry?.name,
                errorText: field.errorText,
                onTap: () async {
                  final opts = state.countries
                      .asMap()
                      .entries
                      .map((e) => OptionItemregister(
                            label: e.value.name,
                            icon: AppIcons.global,
                            colorTag: e.key,
                          ))
                      .toList();

                  final res = await showAppOptionSheetregister(
                    context: context,
                    options: opts,
                    tagColor: _tagColor,
                    current: selectedCountry?.name,
                    title: t?.text('choose_governorate') ?? 'اختر الدولة',
                    subtitle: t?.text('choose_country_subtitle')??'',
                    hint: t?.text('select.search_governorate')??'',
                  );

                  if (res != null) {
                    final country =
                        state.countries.firstWhere((c) => c.name == res);
                    onCountrySelected(country);
                    field.didChange(country);
                  }
                },
              ),
            ),
            const SizedBox(height: 20),

            /// ---------------- STATE ----------------
            FormField<StateEntity>(
              validator: (_) =>
                  selectedGovernorate == null ? 'Required' : null,
              builder: (field) => SelectField(
                label: t?.text("location.area") ?? 'المحافظة',
                value: selectedGovernorate?.name,
                errorText: field.errorText,
                onTap: state.states.isEmpty
                    ? null
                    : () async {
                        final opts = state.states
                            .asMap()
                            .entries
                            .map((e) => OptionItemregister(
                                  label: e.value.name,
                                  icon: AppIcons.location,
                                  colorTag: e.key,
                                ))
                            .toList();

                        final res = await showAppOptionSheetregister(
                          context: context,
                          options: opts,
                          tagColor: _tagColor,
                          current: selectedGovernorate?.name,
                          title: t?.text('choose_country')??'',
                          subtitle:
                              t?.text('select.select_area_subtitle')??'',
                          hint: t?.text('select.search_area')??'',
                        );

                        if (res != null) {
                          final gov = state.states
                              .firstWhere((s) => s.name == res);
                          onGovernorateSelected(gov);
                          field.didChange(gov);
                        }
                      },
              ),
            ),
            const SizedBox(height: 20),

            /// ---------------- MAIN CATEGORY ----------------
            SectionPicker(
              label: t?.text('main_category_label'),
              value: selectedMainCategory?.name,
              errorRequired: selectedMainCategory == null,
              options: state.sections,
              onSelected: onMainCategorySelected,
              title:
                  t?.text('company_main_section_title') ?? 'القسم الرئيسي',  hint: AppTranslations.of(
                      context,
                    )!.text('search_main_section_hint'),
                    subtitle: AppTranslations.of(
                      context,
                    )!.text('select_main_section_subtitle'),
            ),
            const SizedBox(height: 20),

            /// ---------------- SUB CATEGORY ----------------
            CategoryPicker(
              label: t?.text('choose_sub_section'),
              value: selectedSubCategory?.name,
              errorRequired: selectedSubCategory == null,
              options: _getSubCats(state),
              onSelected: onSubCategorySelected,
              title: t?.text('sub_section_title') ?? 'القسم الفرعي', hint: AppTranslations.of(
                      context,
                    )!.text('search_sub_section_hint'),
                   
                    subtitle: AppTranslations.of(
                      context,
                    )!.text('select_sub_section_subtitle'),
            ),
            const SizedBox(height: 24),

            CustomButton(
              text: t?.text('verify_phone_number') ?? 'Next',
              onTap: onSubmit,
            ),
          ],
        );
      },
    );
  }
}
