import 'package:flutter/material.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/bottomsheets/option_sheet_register_grid_model.dart';
import 'package:oreed_clean/core/utils/option_item_register.dart';
import 'package:oreed_clean/features/carform/data/models/brand.dart';
import 'package:oreed_clean/features/carform/data/models/carmodel.dart';
import 'package:oreed_clean/features/carform/presentation/cubit/carform_cubit.dart';
import 'package:provider/provider.dart';
class CarFormDataHandler {
  static Future<List<Brand>> loadBrands({
    required BuildContext context,
    required int sectionId,
  }) async {
    final cubit = context.read<CarformCubit>();

    cubit.fetchBrands(sectionId);

    final state = await cubit.stream.firstWhere(
      (s) => s is CarformBrandsLoaded || s is CarformError,
    );

    if (state is CarformBrandsLoaded) {
      return state.brands
          .map(
            (e) => Brand(
              id: e.id.toString(),
              name: e.name,
              imageUrl: e.image,
            ),
          )
          .toList();
    }

    return [];
  }

  static Future<void> showModelSheet({
    required BuildContext context,
    required int? brandIdSelected,
    required String? currentModelName,
    required Function(CarModel, int) onModelSelected,
  }) async {
    final appTrans = AppTranslations.of(context);
    final cubit = context.read<CarformCubit>();

    if (brandIdSelected == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            appTrans?.text('select_brand_first') ??
                'Please select brand first',
          ),
        ),
      );
      return;
    }

    cubit.fetchModels(brandIdSelected);

    final state = await cubit.stream.firstWhere(
      (s) => s is CarformModelsLoaded || s is CarformError,
    );

    if (state is! CarformModelsLoaded || state.models.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            appTrans?.text('error.no_models') ??
                'No models available for this brand',
          ),
        ),
      );
      return;
    }

    final options = state.models
        .map((m) => OptionItemregister(label: m.name, colorTag: 4))
        .toList();

    final pickedName = await showAppOptionSheetregistergridmodel(
      context: context,
      title: appTrans?.text('select.choose_model') ?? 'Select Model',
      subtitle:
          appTrans?.text('subtitle.select_model') ??
          'Select the model that fits your brand.',
      options: options,
      current: currentModelName,
    );

    if (pickedName != null) {
      final selected = state.models.firstWhere(
        (e) => e.name == pickedName,
      );

      onModelSelected(
        CarModel(id: selected.id.toString(), name: selected.name),
        selected.id,
      );
    }
  }
}
