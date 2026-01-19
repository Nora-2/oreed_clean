// widgets/basic_info_fields.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appicons/app_icons.dart';
import 'package:oreed_clean/core/utils/bottomsheets/option_sheet_register_grid_model.dart';
import 'package:oreed_clean/core/utils/bottomsheets/option_sheet_register_list.dart';
import 'package:oreed_clean/core/utils/option_item_register.dart';
import 'package:oreed_clean/core/utils/shared_widgets/custom_form_field.dart';
import 'package:oreed_clean/features/comapany_register/domain/entities/country_entity.dart';
import 'package:oreed_clean/features/company_types_by_company/presentation/widgets/select_sheet_field_ads.dart';
import 'package:oreed_clean/features/realstateform/presentation/cubit/realstateform_cubit.dart';
import 'package:oreed_clean/features/technicalforms/domain/entities/state_entity.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';

class BasicInfoFields extends StatelessWidget {
  final TextEditingController titleCtrl;
  final TextEditingController priceCtrl;
  final TextEditingController areaCtrl;
  final String? countryId;
  final String? stateId;
  final String? rooms;
  final String? baths;
  final String? floor;
  final int? selectedCountryId;
  final List<CountryEntity> cachedCountries;
  final List<StateEntity> cachedStates;
  final Function(String, String?) onFieldUpdate;
  final Function(String, int?) onIdUpdate;

  const BasicInfoFields({
    super.key,
    required this.titleCtrl,
    required this.priceCtrl,
    required this.areaCtrl,
    required this.countryId,
    required this.stateId,
    required this.rooms,
    required this.baths,
    required this.floor,
    required this.selectedCountryId,
    required this.cachedCountries,
    required this.cachedStates,
    required this.onFieldUpdate,
    required this.onIdUpdate,
  });

  static final _blue = AppColors.primary;
  static final _orange = AppColors.accentLight;

  Color _tagColor(int tag) => tag.isEven ? _blue : _orange;

  @override
  Widget build(BuildContext context) {
    final appTrans = AppTranslations.of(context);

    return Column(
      children: [
        const SizedBox(height: 25),
        _buildTitleField(appTrans),
        const SizedBox(height: 25),
        _buildPriceField(appTrans),
        const SizedBox(height: 25),
        _buildCountryField(context, appTrans),
        const SizedBox(height: 25),
        _buildStateField(context, appTrans),
        const SizedBox(height: 25),
        _buildRoomsField(context, appTrans),
        const SizedBox(height: 25),
        _buildBathsField(context, appTrans),
        const SizedBox(height: 25),
        _buildAreaField(appTrans),
        const SizedBox(height: 25),
        _buildFloorField(context, appTrans),
      ],
    );
  }

  Widget _buildTitleField(AppTranslations? appTrans) {
    return AppTextField(
      controller: titleCtrl,
      hint: appTrans?.text('hint.name') ?? 'اكتب الاسم كاملًا',
      label: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: appTrans?.text('field.name') ?? 'الاسم'),
            const TextSpan(
              text: ' *',
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
      validator: (val) => val!.isEmpty
          ? (appTrans?.text('validation.name_required') ?? 'Please enter name')
          : null,
    );
  }

  Widget _buildPriceField(AppTranslations? appTrans) {
    return AppTextField(
      controller: priceCtrl,
      hint:
          appTrans?.text('hint.price_example') ??
          '0.0 ${appTrans?.text('currency_kwd') ?? 'د.ك'}',
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      label: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: appTrans?.text('field.price') ?? 'السعر'),
            const TextSpan(
              text: ' *',
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
      validator: (p) => null,
    );
  }

  Widget _buildCountryField(BuildContext context, AppTranslations? appTrans) {
    return SelectSheetFieldads(
      label: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text:
                  (appTrans?.text('register_office_governorate') ??
                  'State / City'),
            ),
            const TextSpan(
              text: ' *',
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
      hint:
          countryId ??
          (appTrans?.text('select.choose_state') ?? 'Select State'),
      onTap: () => _handleCountrySelection(context, appTrans),
    );
  }

  Future<void> _handleCountrySelection(
    BuildContext context,
    AppTranslations? appTrans,
  ) async {
    if (cachedCountries.isEmpty) {
      await context.read<RealstateformCubit>().fetchCountries();
      return;
    }

    final options = List.generate(cachedCountries.length, (i) {
      return OptionItemregister(
        label: cachedCountries[i].name,
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
      current: countryId,
    );

    if (chosen != null) {
      final country = cachedCountries.firstWhere((e) => e.name == chosen);
      onFieldUpdate('countryId', country.name);
      onIdUpdate('countryId', country.id);
      onFieldUpdate('stateId', null);
      await context.read<RealstateformCubit>().fetchStates(country.id);
    }
  }

  Widget _buildStateField(BuildContext context, AppTranslations? appTrans) {
    return SelectSheetFieldads(
      label: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: (appTrans?.text('field.city') ?? 'State / City')),
            const TextSpan(
              text: ' *',
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
      hint: stateId ?? (appTrans?.text('select.choose_city') ?? 'Select City'),
      onTap: () => _handleStateSelection(context, appTrans),
    );
  }

  Future<void> _handleStateSelection(
    BuildContext context,
    AppTranslations? appTrans,
  ) async {
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

    if (cachedStates.isEmpty) {
      await context.read<RealstateformCubit>().fetchStates(selectedCountryId!);
      return;
    }

    final options = List.generate(cachedStates.length, (i) {
      return OptionItemregister(
        label: cachedStates[i].name,
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
      current: stateId,
    );

    if (chosen != null) {
      final state = cachedStates.firstWhere((e) => e.name == chosen);
      onFieldUpdate('stateId', state.name);
      onIdUpdate('stateId', state.id);
    }
  }

  Widget _buildRoomsField(BuildContext context, AppTranslations? appTrans) {
    return SelectSheetFieldads(
      label: Text.rich(
        TextSpan(
          children: [TextSpan(text: appTrans?.text('field.rooms') ?? 'Rooms')],
        ),
      ),
      onTap: () => _handleRoomsSelection(context, appTrans),
      hint: rooms ?? appTrans?.text('select.choose_rooms') ?? 'اختر عدد الغرف',
    );
  }

  Future<void> _handleRoomsSelection(
    BuildContext context,
    AppTranslations? appTrans,
  ) async {
    final s = await showAppOptionSheetregistergridmodel(
      subtitle:
          appTrans?.text('select.choose_rooms_subtitle') ??
          'Choose the number of rooms suitable for you',
      context: context,
      title: appTrans?.text('select.choose_rooms') ?? 'Choose Rooms',
      options: [
        ...List.generate(
          10,
          (i) => OptionItemregister(
            label: '${i + 1}',
            icon: AppIcons.bed,
            colorTag: 0,
          ),
        ),
        const OptionItemregister(label: '+10', icon: AppIcons.bed, colorTag: 0),
      ],
    );
    if (s != null) onFieldUpdate('rooms', s);
  }

  Widget _buildBathsField(BuildContext context, AppTranslations? appTrans) {
    return SelectSheetFieldads(
      label: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: appTrans?.text('field.baths') ?? 'Bathrooms'),
          ],
        ),
      ),
      hint:
          baths ??
          (appTrans?.text('select.choose_baths') ?? 'Choose Bathrooms'),
      onTap: () => _handleBathsSelection(context, appTrans),
    );
  }

  Future<void> _handleBathsSelection(
    BuildContext context,
    AppTranslations? appTrans,
  ) async {
    final s = await showAppOptionSheetregistergridmodel(
      context: context,
      title: appTrans?.text('select.choose_baths') ?? 'Choose Bathrooms',
      options: [
        ...List.generate(
          10,
          (i) => OptionItemregister(
            label: '${i + 1}',
            icon: AppIcons.bath,
            colorTag: 1,
          ),
        ),
        const OptionItemregister(
          label: '+10',
          icon: AppIcons.bath,
          colorTag: 1,
        ),
      ],
      current: baths,
      subtitle:
          appTrans?.text('select.choose_baths_subtitle') ??
          'Choose the number of bathrooms suitable for you',
    );
    if (s != null) onFieldUpdate('baths', s);
  }

  Widget _buildAreaField(AppTranslations? appTrans) {
    return AppTextField(
      controller: areaCtrl,
      hint: appTrans?.text('hint.area') ?? 'أدخل المساحة بالأرقام',
      keyboardType: const TextInputType.numberWithOptions(decimal: false),
      label: Text.rich(
        TextSpan(
          children: [TextSpan(text: appTrans?.text('field.area') ?? 'Area')],
        ),
      ),
      validator: (String? p1) => null,
    );
  }

  Widget _buildFloorField(BuildContext context, AppTranslations? appTrans) {
    return SelectSheetFieldads(
      label: Text.rich(
        TextSpan(
          children: [TextSpan(text: appTrans?.text('field.floor') ?? 'الدور')],
        ),
      ),
      onTap: () => _handleFloorSelection(context, appTrans),
      hint: floor ?? appTrans?.text('select.choose_floor') ?? 'اختر الدور',
    );
  }

  Future<void> _handleFloorSelection(
    BuildContext context,
    AppTranslations? appTrans,
  ) async {
    final s = await showAppOptionSheetregistergridmodel(
      context: context,
      title: appTrans?.text('select.choose_floor') ?? 'اختر الدور',
      options: [
        ...List.generate(
          20,
          (i) => OptionItemregister(
            label: i.toString(),
            icon: AppIcons.floor,
            colorTag: 1,
          ),
        ),
        const OptionItemregister(
          label: '+20',
          icon: AppIcons.floor,
          colorTag: 1,
        ),
      ],
      current: floor,
      subtitle: '',
    );
    if (s != null) onFieldUpdate('floor', s);
  }
}
