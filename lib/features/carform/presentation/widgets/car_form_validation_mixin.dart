// mixins/car_form_validation_mixin.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/features/technicalforms/domain/entities/state_entity.dart';
import 'package:oreed_clean/features/technicalforms/domain/entities/city_entity.dart';

mixin CarFormValidationMixin {
  List<String> validateCurrentStep({
    required int step,
    required TextEditingController titleCtrl,
    required TextEditingController priceCtrl,
    required TextEditingController descCtrl,
    required int? brandIdSelected,
    required int? modelIdSelected,
    required StateEntity? selectedState,
    required CityEntity? selectedCity,
    required File? mainImage,
    required String? mainImageUrl,
    required bool isEditing,
  }) {
    final errors = <String>[];

    switch (step) {
      case 1:
        if (titleCtrl.text.trim().isEmpty) {
          errors.add('title');
        }
        if (brandIdSelected == null) errors.add('brand');
        if (modelIdSelected == null) errors.add('model');
        if (selectedState == null) errors.add('state');
        if (selectedCity == null) errors.add('city');
        break;

      case 2:
        if (priceCtrl.text.trim().isEmpty) {
          errors.add('price');
        } else {
          final price = double.tryParse(priceCtrl.text.trim());
          if (price == null || price <= 0) {
            errors.add('price_invalid');
          }
        }
        break;

      case 3:
        if (descCtrl.text.trim().length < 3) {
          errors.add('description_short');
        }
        final hasMainImage = mainImage != null || mainImageUrl != null;
        if (!hasMainImage && !isEditing) {
          errors.add('main_image');
        }
        break;
    }

    return errors;
  }

  List<String> validateAllFields({
    required TextEditingController titleCtrl,
    required TextEditingController priceCtrl,
    required int? brandIdSelected,
    required int? modelIdSelected,
    required StateEntity? selectedState,
    required CityEntity? selectedCity,
    required File? mainImage,
    required String? mainImageUrl,
    required List<File> images,
  }) {
    final errs = <String>[];
    if (titleCtrl.text.trim().isEmpty) errs.add('title');
    if (priceCtrl.text.trim().isEmpty) errs.add('price');
    if (brandIdSelected == null) errs.add('brand');
    if (modelIdSelected == null) errs.add('model');
    if (selectedState == null) errs.add('state');
    if (selectedCity == null) errs.add('city');
    if ((mainImage == null && mainImageUrl == null) && images.isEmpty) {
      errs.add('images');
    }
    return errs;
  }

  bool hasAnySpecsFilled({
    required String? yearSelected,
    required TextEditingController kmCtrl,
    required String? engineCc,
    required String? condition,
    required String? gear,
    required String? fuel,
    required String? paint,
    required String? colorName,
  }) {
    return (yearSelected != null && yearSelected.trim().isNotEmpty) ||
        kmCtrl.text.trim().isNotEmpty ||
        (engineCc != null && engineCc.trim().isNotEmpty) ||
        (condition != null && condition.trim().isNotEmpty) ||
        (gear != null && gear.trim().isNotEmpty) ||
        (fuel != null && fuel.trim().isNotEmpty) ||
        (paint != null && paint.trim().isNotEmpty) ||
        (colorName != null && colorName.trim().isNotEmpty);
  }

  Future<bool> confirmOptionalSpecs(
    BuildContext context,
    AppTranslations? t,
    bool hasSpecs,
  ) async {
    if (hasSpecs) return true;

    return await showDialog<bool>(
          context: context,
          builder: (ctx) {
            final title = t?.text('validation.optional_specs_title') ?? '';
            final msg = t?.text('validation.optional_specs_message') ?? '';
            final fillNow = t?.text('validation.optional_specs_fill') ?? '';
            final continueAnyway = t?.text('validation.optional_specs_skip') ?? '';

            return Directionality(
              textDirection:
                  (t?.locale!.languageCode == 'ar' || t?.locale == null)
                      ? TextDirection.rtl
                      : TextDirection.ltr,
              child: AlertDialog(
                title: Text(title),
                content: Text(msg),
                actionsAlignment: MainAxisAlignment.spaceBetween,
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: Text(fillNow, textAlign: TextAlign.center),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: Text(continueAnyway, textAlign: TextAlign.center),
                  ),
                ],
              ),
            );
          },
        ) ??
        false;
  }

  void showFillAllFieldsSnack(BuildContext context, AppTranslations? t) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(t?.text('error.fill_required_fields') ?? '')),
    );
  }
}
