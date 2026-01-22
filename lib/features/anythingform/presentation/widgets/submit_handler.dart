import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oreed_clean/core/app_shared_prefs.dart';
import 'package:oreed_clean/core/routing/routes.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/shared_widgets/pin_choice_screen.dart';
import 'package:oreed_clean/features/anythingform/domain/usecases/edit_anything_usecase.dart';
import 'package:oreed_clean/features/anythingform/presentation/cubit/create_anything_cubit.dart';
import 'package:oreed_clean/features/anythingform/presentation/cubit/create_anything_state.dart';
import 'package:oreed_clean/features/anythingform/presentation/widgets/state_manager.dart';
import 'package:oreed_clean/features/mainlayout/presentation/cubit/mainlayout_cubit.dart';
import 'package:oreed_clean/features/verification/presentation/pages/payment_webview.dart';
import 'package:oreed_clean/networking/api_provider.dart';


class AnythingSubmitHandler {
  final AnythingFormStateManager stateManager;
  final dynamic widget;
  final Function(bool) onLoadingChanged;

  AnythingSubmitHandler({
    required this.stateManager,
    required this.widget,
    required this.onLoadingChanged,
  });

  Future<void> handleSubmit(BuildContext context) async {
    final appTrans = AppTranslations.of(context);
    final cubit = context.read<CreateAnythingCubit>();
    
    try {
      final userId = AppSharedPreferences().getUserIdD();
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              appTrans?.text('error.user_not_found') ?? 'يرجى تسجيل الدخول مجددًا',
            ),
          ),
        );
        return;
      }

      if (widget.adId != null) {
        await _handleEdit(context, cubit, appTrans);
      } else {
        await _handleCreate(context, cubit, appTrans, userId);
      }
    } catch (e) {
      // Error handling
    } finally {
      if (context.mounted) {
        onLoadingChanged(false);
        stateManager.isLoading = false;
      }
    }
  }

  Future<void> _handleEdit(
    BuildContext context,
    CreateAnythingCubit cubit,
    AppTranslations? appTrans,
  ) async {
    await cubit.edit(
      EditAnythingParams(
        adId: widget.adId!,
        sectionId: widget.sectionId,
        nameAr: stateManager.titleCtrl.text.trim(),
        descriptionAr: stateManager.descCtrl.text.trim(),
        price: stateManager.priceCtrl.text.trim(),
        stateId: stateManager.selectedCountryId,
        cityId: stateManager.selectedStateId,
        dynamicFields: stateManager.dynamicFieldValues,
        mainImage: stateManager.mainImageFile,
        galleryImages: stateManager.galleryLocal.isNotEmpty 
            ? stateManager.galleryLocal 
            : null,
      ),
    );

    if (cubit.state.status == CreateAnythingStatus.success &&
        cubit.state.response?.status == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            appTrans?.text('success.anything_updated') ?? 'تم حفظ التعديلات ✅',
          ),
        ),
      );
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home',
          (_) => false,
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            appTrans?.text('ad_details.error_occurred') ?? 'An error occurred',
          ),
        ),
      );
    }
  }

  Future<void> _handleCreate(
    BuildContext context,
    CreateAnythingCubit cubit,
    AppTranslations? appTrans,
    int userId,
  ) async {
    if (stateManager.mainImageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            appTrans?.text('validation.at_least_one_image') ?? 
            'يرجى إضافة الصورة الرئيسية',
          ),
        ),
      );
      return;
    }

    if (stateManager.selectedCountryId == null || 
        stateManager.selectedStateId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            appTrans?.text('validation.select_location') ?? 
            'يرجى اختيار المحافظة والمدينة',
          ),
        ),
      );
      return;
    }

    onLoadingChanged(true);
    stateManager.isLoading = true;

    await cubit.createAd(
      nameAr: stateManager.titleCtrl.text.trim(),
      descriptionAr: stateManager.descCtrl.text.trim(),
      price: stateManager.priceCtrl.text.trim(),
      userId: userId,
      sectionId: widget.sectionId,
      categoryId: widget.categoryId,
      subCategoryId: widget.supCategoryId,
      stateId: stateManager.selectedCountryId!,
      cityId: stateManager.selectedStateId!,
      dynamicFields: stateManager.dynamicFieldValues,
      mainImage: stateManager.mainImageFile!,
      galleryImages: stateManager.galleryLocal,
      companyTypeId: widget.companyTypeId,
      companyId: widget.companyId,
    );

    if (cubit.state.status == CreateAnythingStatus.success && 
        cubit.state.response != null) {
      await _handlePaymentFlow(context, cubit, appTrans, userId);
    }
  }

  Future<void> _handlePaymentFlow(
    BuildContext context,
    CreateAnythingCubit cubit,
    AppTranslations? appTrans,
    int userId,
  ) async {
    if (widget.companyId != null) {
      Navigator.pushNamedAndRemoveUntil(
        context, 
        Routes.homelayout, 
        (_) => false,
      );
    } else {
      final choice = await PinChoiceScreen.show(context);
      if (choice == null || choice.isFree) {
        Navigator.pushNamedAndRemoveUntil(
          context, 
          Routes.homelayout, 
          (_) => false,
        );
      } else {
        final url = Uri.parse(
          ApiProvider.baseUrl + 
          '/payment/request?user_id=$userId&packageId=${choice.id}&ads_id=${cubit.state.response!.id}&model=anything',
        );
        final result = await Navigator.push<PaymentResult>(
          context,
          MaterialPageRoute(
            builder: (_) => PaymentWebView(
              url: url.toString(),
              title: AppTranslations.of(context)!.text('payment_title'),
              successMatcher: (u) => 
                  u.contains('payment/success') || u.contains('status=success'),
              cancelMatcher: (u) => 
                  u.contains('payment/cancel') || u.contains('status=cancel'),
            ),
          ),
        );

        if (!context.mounted) return;

        if (result == PaymentResult.success) {
          context.read<HomelayoutCubit>().changeTabIndex(2);
          Navigator.pushNamedAndRemoveUntil(
            context, 
            Routes.homelayout, 
            arguments: 2, 
            (_) => false,
          );
        } else if (result == PaymentResult.cancelled) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                appTrans?.text('payment.cancelled') ?? 'تم إلغاء الدفع',
              ),
            ),
          );
        }
      }
    }
  }
}
