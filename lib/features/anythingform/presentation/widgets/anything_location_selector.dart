import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/appicons/app_icons.dart';
import 'package:oreed_clean/core/utils/bottomsheets/option_sheet_register_list.dart';
import 'package:oreed_clean/core/utils/option_item_register.dart';
import 'package:oreed_clean/core/utils/textstyle/appfonts.dart';
import 'package:oreed_clean/features/anythingform/presentation/cubit/create_anything_cubit.dart';
// import 'package:oreed_clean/features/anythingform/presentation/cubit/create_anything_state.dart';
// (State is implied by cubit usage, explicit import might be needed if I use state class directly)
import 'package:oreed_clean/features/company_types_by_company/presentation/widgets/select_sheet_field_ads.dart';

class AnythingLocationSelector extends StatelessWidget {
  final int? selectedCountryId;
  final String? selectedCountryName;
  final String? selectedStateName;
  final Function(int id, String name) onCountrySelected;
  final Function(int id, String name) onStateSelected;

  const AnythingLocationSelector({
    super.key,
    required this.selectedCountryId,
    required this.selectedCountryName,
    required this.selectedStateName,
    required this.onCountrySelected,
    required this.onStateSelected,
  });

  Color _tagColor(int tag) =>
      tag.isEven ? AppColors.primary : AppColors.secondary;

  @override
  Widget build(BuildContext context) {
    final appTrans = AppTranslations.of(context);
    final cubit = context.read<CreateAnythingCubit>();

    return Column(
      children: [
        SelectSheetFieldads(
          label: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: appTrans?.text('field.state') ?? 'المحافظة',
                  style: AppFonts.body.copyWith(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
          hint:
              selectedCountryName ??
              appTrans?.text('field.state') ??
              'المحافظة / المدينة',
          onTap: () async {
            if (cubit.state.loadingCountries) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    appTrans?.text('loading.loading') ??
                        'جاري تحميل المحافظات...',
                  ),
                ),
              );
              return;
            }

            final countries = cubit.state.countries;
            if (countries.isEmpty) {
              await cubit.fetchCountries();
            }

            final options = List.generate(countries.length, (i) {
              return OptionItemregister(
                label: countries[i].name,
                icon: AppIcons.locationCountry,
                colorTag: i,
              );
            });

            final chosen = await showAppOptionSheetregister(
              context: context,
              title: appTrans?.text('select.choose_state') ?? 'Select State',
              hint: appTrans?.text('select.search_state') ?? 'Search for state',
              subtitle:
                  appTrans?.text('select.state_subtitle') ??
                  'Choose your state to view ads and services.',
              options: options,
              tagColor: _tagColor,
              current: selectedCountryName,
            );

            if (chosen != null) {
              final selected = countries.firstWhere((c) => c.name == chosen);
              onCountrySelected(selected.id, selected.name);
              // Logic to clear state selection happens in parent via setState or calling logic
              await cubit.fetchStates(selected.id);
            }
          },
        ),
        const SizedBox(height: 30),
        SelectSheetFieldads(
          label: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: appTrans?.text('field.city') ?? 'المدينة',
                  style: AppFonts.body.copyWith(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
          hint:
              selectedStateName ??
              (appTrans?.text('select.select_city') ?? 'Select City'),
          onTap: () async {
            if (selectedCountryId == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    appTrans?.text('error.select_state_first') ??
                        'اختَر المحافظة أولًا',
                  ),
                ),
              );
              return;
            }

            if (cubit.state.loadingStates) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    appTrans?.text('loading.loading') ?? 'جاري تحميل المدن...',
                  ),
                ),
              );
              return;
            }

            final states = cubit.state.states;
            if (states.isEmpty) {
              await cubit.fetchStates(selectedCountryId!);
            }

            final options = List.generate(states.length, (i) {
              return OptionItemregister(
                label: states[i].name,
                icon: AppIcons.location,
                colorTag: i,
              );
            });

            final chosen = await showAppOptionSheetregister(
              context: context,
              title: appTrans?.text('select.choose_city') ?? 'Select City',
              hint: appTrans?.text('select.search_city') ?? 'Search for city',
              subtitle:
                  appTrans?.text('select.city_subtitle') ??
                  'Choose your city to view ads and services.',
              options: options,
              tagColor: _tagColor,
              current: selectedStateName,
            );

            if (chosen != null) {
              final selected = states.firstWhere((s) => s.name == chosen);
              onStateSelected(selected.id, selected.name);
            }
          },
        ),
      ],
    );
  }
}
