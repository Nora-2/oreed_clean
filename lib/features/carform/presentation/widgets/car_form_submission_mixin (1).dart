// mixins/car_form_submission_mixin.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Changed from Provider
import 'package:oreed_clean/core/app_shared_prefs.dart';
import 'package:oreed_clean/core/routing/routes.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/features/carform/data/models/brand.dart';
import 'package:oreed_clean/features/carform/data/models/carmodel.dart';
import 'package:oreed_clean/features/carform/presentation/cubit/carform_cubit.dart';
import 'package:oreed_clean/features/carform/presentation/widgets/car_form_helpers.dart';
import 'package:oreed_clean/features/carform/presentation/widgets/car_form_review_builder.dart';
import 'package:oreed_clean/features/chooseplane/domain/entities/package_entity.dart';
import 'package:oreed_clean/features/mainlayout/presentation/cubit/mainlayout_cubit.dart';
import 'package:oreed_clean/features/technicalforms/domain/entities/state_entity.dart';
import 'package:oreed_clean/features/technicalforms/domain/entities/city_entity.dart';
import 'package:oreed_clean/core/utils/shared_widgets/generic_review_screen.dart';
import 'package:oreed_clean/core/utils/shared_widgets/pin_choice_screen.dart';
import 'package:oreed_clean/features/technicalforms/presentation/widgets/review_section.dart';
import 'package:oreed_clean/features/verification/presentation/pages/payment_webview.dart';
mixin CarFormSubmissionMixin {
  Future<void> handleFinalSubmission({
    required BuildContext context,
    required AppTranslations? appTrans,

    required dynamic widget,
    required TextEditingController titleCtrl,
    required TextEditingController priceCtrl,
    required TextEditingController kmCtrl,
    required TextEditingController descCtrl,
    required TextEditingController engineCtrl,
    required Brand? brand, // Updated to Entity
    required CarModel? model, // Updated to Entity
    required int? brandIdSelected,
    required int? modelIdSelected,
    required StateEntity? selectedState,
    required CityEntity? selectedCity,
    required String? condition,
    required String? fuel,
    required String? gear,
    required String? paint,
    required String? colorName,
    required String? yearSelected,
    required String? engineCc,
    required String? governorateId,
    required String? cityId,
    required File? mainImage,
    required String? mainImageUrl,
    required List<String> galleryUrls,
    required List<File> galleryImages,
    required List<String> certImageUrls,
    required List<File> certImages,
    required bool isEditing,
    required Function(int) setCurrentStep,
  }) async {
    final sections = CarFormReviewBuilder.buildReviewSections(
      t: appTrans,
      titleCtrl: titleCtrl,
      priceCtrl: priceCtrl,
      kmCtrl: kmCtrl,
      brand: brand,
      model: model,
      condition: condition,
      colorName: colorName,
      yearSelected: yearSelected,
      engineCc: engineCc,
      fuel: fuel,
      gear: gear,
      paint: paint,
      governorateId: governorateId,
      cityId: cityId,
      mainImage: mainImage,
      mainImageUrl: mainImageUrl,
      galleryUrls: galleryUrls,
      galleryImages: galleryImages,
      certImageUrls: certImageUrls,
      certImages: certImages,
    );

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GenericReviewScreen(
          pageTitle: isEditing
              ? (appTrans?.text('review.car_edit_page_title') ?? 'Review Car Ad Edit')
              : (appTrans?.text('review.car_page_title') ?? 'Review Car Ad'),
          sections: sections,
          requireAgreement: true,
          confirmLabel: isEditing
              ? (appTrans?.text('action.confirm_save') ?? 'Confirm and Save')
              : (appTrans?.text('action.confirm_publish') ?? 'Confirm and Publish'),
          onConfirm: () => _performSubmission(
            context: context,
            appTrans: appTrans,
            widget: widget,
            titleCtrl: titleCtrl,
            priceCtrl: priceCtrl,
            kmCtrl: kmCtrl,
            descCtrl: descCtrl,
            engineCtrl: engineCtrl,
            brandIdSelected: brandIdSelected,
            modelIdSelected: modelIdSelected,
            selectedState: selectedState,
            selectedCity: selectedCity,
            condition: condition,
            fuel: fuel,
            gear: gear,
            paint: paint,
            colorName: colorName,
            yearSelected: yearSelected,
            engineCc: engineCc,
            mainImage: mainImage,
            galleryImages: galleryImages,
            certImages: certImages,
            isEditing: isEditing,
          ),
        ),
      ),
    );

    if (result is ReviewScreenResult && !result.confirmed && result.editSection != null) {
      if (result.editSection == 'basics') {
        setCurrentStep(1);
      } else if (result.editSection == 'specs') {
        setCurrentStep(2);
      } else if (result.editSection == 'images') {
        setCurrentStep(3);
      }
    }
  }

  Future<void> _performSubmission({
    required BuildContext context,
    required AppTranslations? appTrans,
    required dynamic widget,
    required TextEditingController titleCtrl,
    required TextEditingController priceCtrl,
    required TextEditingController kmCtrl,
    required TextEditingController descCtrl,
    required TextEditingController engineCtrl,
    required int? brandIdSelected,
    required int? modelIdSelected,
    required StateEntity? selectedState,
    required CityEntity? selectedCity,
    required String? condition,
    required String? fuel,
    required String? gear,
    required String? paint,
    required String? colorName,
    required String? yearSelected,
    required String? engineCc,
    required File? mainImage,
    required List<File> galleryImages,
    required List<File> certImages,
    required bool isEditing,
  }) async {
    Navigator.pop(context); // Close Review Screen

    try {
      final userId = AppSharedPreferences().getUserIdD();
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(appTrans?.text('error.user_not_found') ?? 'User not found')),
        );
        return;
      }

      final conditionKey = _mapToApiKey(condition, _getConditionMap(appTrans));
      final fuelKey = _mapToApiKey(fuel, _getFuelMap(appTrans));
      final paintKey = _mapToApiKey(paint, _getPaintMap(appTrans));
      final engineKey = _mapToApiKey(engineCc, _getEngineMap(appTrans));

      final cubit = context.read<CarformCubit>();

      if (isEditing) {
        await _updateAd(
          context: context,
          cubit: cubit,
          widget: widget,
          appTrans: appTrans,
          userId: userId,
          titleCtrl: titleCtrl,
          priceCtrl: priceCtrl,
          kmCtrl: kmCtrl,
          descCtrl: descCtrl,
          brandIdSelected: brandIdSelected,
          modelIdSelected: modelIdSelected,
          selectedState: selectedState,
          selectedCity: selectedCity,
          conditionKey: conditionKey,
          fuelKey: fuelKey,
          paintKey: paintKey,
          engineKey: engineKey,
          colorName: colorName,
          yearSelected: yearSelected,
          gear: gear,
          mainImage: mainImage,
          galleryImages: galleryImages,
          certImages: certImages,
        );
      } else {
        await _createAd(
          context: context,
          cubit: cubit,
          widget: widget,
          appTrans: appTrans,
          userId: userId,
          titleCtrl: titleCtrl,
          priceCtrl: priceCtrl,
          kmCtrl: kmCtrl,
          descCtrl: descCtrl,
          brandIdSelected: brandIdSelected,
          modelIdSelected: modelIdSelected,
          selectedState: selectedState,
          selectedCity: selectedCity,
          conditionKey: conditionKey,
          fuelKey: fuelKey,
          paintKey: paintKey,
          engineKey: engineKey,
          colorName: colorName,
          yearSelected: yearSelected,
          gear: gear,
          mainImage: mainImage,
          galleryImages: galleryImages,
          certImages: certImages,
        );
      }
    } catch (e) {
      debugPrint('Submission error: $e');
    }
  }

  Future<void> _updateAd({
    required BuildContext context,
    required CarformCubit cubit,
    required dynamic widget,
    required AppTranslations? appTrans,
    required int userId,
    required TextEditingController titleCtrl,
    required TextEditingController priceCtrl,
    required TextEditingController kmCtrl,
    required TextEditingController descCtrl,
    required int? brandIdSelected,
    required int? modelIdSelected,
    required StateEntity? selectedState,
    required CityEntity? selectedCity,
    required String conditionKey,
    required String fuelKey,
    required String paintKey,
    required String engineKey,
    required String? colorName,
    required String? yearSelected,
    required String? gear,
    required File? mainImage,
    required List<File> galleryImages,
    required List<File> certImages,
  }) async {
    await cubit.updateCarAd(
      id: widget.adId!,
      titleAr: titleCtrl.text.trim(),
      descriptionAr: descCtrl.text.trim(),
      price: priceCtrl.text.trim(),
      userId: userId,
      sectionId: widget.sectionId,
      categoryId: widget.categoryId,
      subCategoryId: widget.supCategoryId,
      brandId: brandIdSelected ?? 0,
      carModelId: modelIdSelected ?? 0,
      stateId: selectedState?.id ?? 0,
      cityId: selectedCity?.id ?? 0,
      color: colorName ?? '',
      year: yearSelected ?? '',
      kilometers: kmCtrl.text.trim(),
      engineSize: engineKey,
      condition: conditionKey,
      fuelType: fuelKey,
      transmission: CarFormHelpers.mapGearToApi(gear),
      paintCondition: paintKey,
      mainImage: mainImage,
      certImages: certImages,
      galleryImages: galleryImages.length > 1 ? galleryImages : const [],
      companyId: widget.companyId,
      companyTypeId: widget.companyTypeId,
    );

    if (cubit.state is CarformUpdateSuccess) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(appTrans?.text('success.car_updated') ?? 'Updated successfully ✅')),
        );
        Navigator.pop(context);
      }
    } else if (cubit.state is CarformError) {
      final errorState = cubit.state as CarformError;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorState.message)));
      }
    }
  }

  Future<void> _createAd({
    required BuildContext context,
    required CarformCubit cubit,
    required dynamic widget,
    required AppTranslations? appTrans,
    required int userId,
    required TextEditingController titleCtrl,
    required TextEditingController priceCtrl,
    required TextEditingController kmCtrl,
    required TextEditingController descCtrl,
    required int? brandIdSelected,
    required int? modelIdSelected,
    required StateEntity? selectedState,
    required CityEntity? selectedCity,
    required String conditionKey,
    required String fuelKey,
    required String paintKey,
    required String engineKey,
    required String? colorName,
    required String? yearSelected,
    required String? gear,
    required File? mainImage,
    required List<File> galleryImages,
    required List<File> certImages,
  }) async {
    await cubit.submitCarAd(
      titleAr: titleCtrl.text.trim(),
      descriptionAr: descCtrl.text.trim(),
      price: priceCtrl.text.trim(),
      userId: userId,
      sectionId: widget.sectionId,
      categoryId: widget.categoryId,
      subCategoryId: widget.supCategoryId,
      brandId: brandIdSelected ?? 0,
      carModelId: modelIdSelected ?? 0,
      stateId: selectedState?.id ?? 0,
      cityId: selectedCity?.id ?? 0,
      color: colorName ?? '',
      year: yearSelected ?? '',
      kilometers: kmCtrl.text.trim(),
      engineSize: engineKey,
      condition: conditionKey,
      fuelType: fuelKey,
      transmission: CarFormHelpers.mapGearToApi(gear),
      paintCondition: paintKey,
      mainImage: mainImage ?? (galleryImages.isNotEmpty ? galleryImages.first : File('')),
      certImages: certImages,
      galleryImages: galleryImages,
      companyId: widget.companyId,
      companyTypeId: widget.companyTypeId,
    );

    final state = cubit.state;
    if (state is CarformSubmitSuccess && state.response.status) {
      final adResponse = state.response;
      
      if (widget.companyId != null) {
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(context, Routes.homelayout, (_) => false);
        }
      } else {
        if (context.mounted) {
          PackageEntity? choice = await PinChoiceScreen.show(context);
          if (choice == null) {
            Navigator.pushNamedAndRemoveUntil(context, Routes.homelayout, (_) => false);
          } else {
            final url = 'https://oreedo.net/payment/request?user_id=$userId&packageId=${choice.id}&ads_id=${adResponse.id}&model=car';
            final result = await Navigator.push<PaymentResult>(
              context,
              MaterialPageRoute(
                builder: (_) => PaymentWebView(
                  title: AppTranslations.of(context)!.text('payment_title'),
                  url: url,
                  successMatcher: (u) => u.contains('payment/success') || u.contains('status=success'),
                  cancelMatcher: (u) => u.contains('payment/cancel') || u.contains('status=cancel'),
                ),
              ),
            );

            if (!context.mounted) return;

            if (result == PaymentResult.success) {
              context.read<HomelayoutCubit>().changeTabIndex(2);
              Navigator.pushNamedAndRemoveUntil(context, Routes.homelayout, (_) => false, arguments: 2);
            } else if (result == PaymentResult.cancelled) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(appTrans?.text('payment.cancelled') ?? 'Payment cancelled')),
              );
            }
          }
        }
      }
    } else if (state is CarformError) {
       if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.message), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  // --- Helpers (unchanged logic) ---
  String _mapToApiKey(String? value, Map<String, String> dict) =>
      CarFormHelpers.keyFromLabel(value, dict) ?? value ?? '';

  Map<String, String> _getConditionMap(AppTranslations? t) => {
        'new': CarFormHelpers.tr(t, 'options.condition.new', ''),
        'used': CarFormHelpers.tr(t, 'options.condition.used', ''),
      };

  Map<String, String> _getFuelMap(AppTranslations? t) => {
        'petrol': CarFormHelpers.tr(t, 'options.fuel.petrol', ''),
        'diesel': CarFormHelpers.tr(t, 'options.fuel.diesel', ''),
        'electric': CarFormHelpers.tr(t, 'options.fuel.electric', ''),
      };

  Map<String, String> _getPaintMap(AppTranslations? t) => {
        'agency': CarFormHelpers.tr(t, 'options.paint.agency', ''),
        'partially_painted': CarFormHelpers.tr(t, 'options.paint.partially_painted', ''),
        'fully_painted': CarFormHelpers.tr(t, 'options.paint.fully_painted', ''),
      };

  Map<String, String> _getEngineMap(AppTranslations? t) => {
        '0_499': CarFormHelpers.tr(t, 'options.engine.0_499', ''),
        '500_999': CarFormHelpers.tr(t, 'options.engine.500_999', ''),
        '1000_1600': CarFormHelpers.tr(t, 'options.engine.1000_1600', ''),
        '1700_2200': CarFormHelpers.tr(t, 'options.engine.1700_2200', ''),
        '2300_2999': CarFormHelpers.tr(t, 'options.engine.2300_2999', ''),
        '3000_3999': CarFormHelpers.tr(t, 'options.engine.3000_3999', ''),
        '4000_4999': CarFormHelpers.tr(t, 'options.engine.4000_4999', ''),
        '5000_5999': CarFormHelpers.tr(t, 'options.engine.5000_5999', ''),
      };
}