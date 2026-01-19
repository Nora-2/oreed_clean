import 'package:flutter/material.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appicons/app_icons.dart';
import 'package:oreed_clean/core/utils/bottomsheets/option_sheet_register_list.dart';
import 'package:oreed_clean/core/utils/option_item_register.dart';
import 'package:oreed_clean/features/company_types_by_company/presentation/widgets/select_sheet_field_ads.dart';
import 'package:oreed_clean/features/technicalforms/domain/entities/state_entity.dart';
import 'package:oreed_clean/features/technicalforms/domain/entities/city_entity.dart';

class StateSelector extends StatelessWidget {
  final StateEntity? selectedState;
  final List<StateEntity> states;
  final AppTranslations? appTrans;
  final Function(StateEntity) onStateSelected;
  final VoidCallback onError;
  final Color Function(int) tagColor;

  const StateSelector({
    super.key,
    required this.selectedState,
    required this.states,
    required this.onStateSelected,
    required this.onError,
    required this.tagColor,
    this.appTrans,
  });

  @override
  Widget build(BuildContext context) {
    return SelectSheetFieldads(
      label: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: appTrans?.text('field.state') ?? 'Governorate'),
            const TextSpan(
              text: ' *',
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
      hint:
          selectedState?.name ??
          (appTrans?.text('select.choose_state') ?? 'Select Governorate'),
      onTap: () async {
        if (states.isEmpty) {
          onError();
          return;
        }

        final options = states
            .map(
              (s) => OptionItemregister(
                label: s.name,
                icon: AppIcons.locationCountry,
              ),
            )
            .toList();

        final chosenLabel = await showAppOptionSheetregister(
          context: context,
          title: appTrans?.text('select.choose_state') ?? 'Select Governorate',
          options: options,
          tagColor: tagColor,
          current: selectedState?.name,
          hint: appTrans?.text('hint.search_state') ?? 'Search for governorate',
          subtitle:
              appTrans?.text('select.state_subtitle') ??
              'Choose your governorate to view ads and services.',
        );

        if (chosenLabel != null) {
          final chosen = states.firstWhere(
            (s) => s.name == chosenLabel,
            orElse: () => states.first,
          );
          onStateSelected(chosen);
        }
      },
    );
  }
}

class CitySelector extends StatelessWidget {
  final CityEntity? selectedCity;
  final StateEntity? selectedState;
  final List<CityEntity> cities;
  final AppTranslations? appTrans;
  final Function(CityEntity) onCitySelected;
  final VoidCallback onStateNotSelected;
  final VoidCallback onError;
  final Color Function(int) tagColor;

  const CitySelector({
    super.key,
    required this.selectedCity,
    required this.selectedState,
    required this.cities,
    required this.onCitySelected,
    required this.onStateNotSelected,
    required this.onError,
    required this.tagColor,
    this.appTrans,
  });

  @override
  Widget build(BuildContext context) {
    return SelectSheetFieldads(
      hint:
          selectedCity?.name ??
          (appTrans?.text('select.choose_city') ?? 'Select City'),
      label: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: selectedState == null
                  ? (appTrans?.text('field.city') ??
                        'Please select governorate first')
                  : (appTrans?.text('field.city') ?? 'Select City'),
            ),
            const TextSpan(
              text: ' *',
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
      onTap: () async {
        if (selectedState == null) {
          onStateNotSelected();
          return;
        }

        if (cities.isEmpty) {
          onError();
          return;
        }

        final options = cities
            .map(
              (c) => OptionItemregister(label: c.name, icon: AppIcons.location),
            )
            .toList();

        final chosenLabel = await showAppOptionSheetregister(
          context: context,
          title: appTrans?.text('select.choose_city') ?? 'Select City',
          options: options,
          tagColor: tagColor,
          current: selectedCity?.name,
          hint: appTrans?.text('hint.search_city') ?? 'Search for city',
          subtitle:
              appTrans?.text('select.state_subtitle') ??
              'Choose your governorate to view ads and services.',
        );

        if (chosenLabel != null) {
          final chosen = cities.firstWhere(
            (c) => c.name == chosenLabel,
            orElse: () => cities.first,
          );
          onCitySelected(chosen);
        }
      },
    );
  }
}
