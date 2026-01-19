import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oreed_clean/core/app_shared_prefs.dart';
import 'package:oreed_clean/core/routing/routes.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/shared_widgets/pin_choice_screen.dart';
import 'package:oreed_clean/features/mainlayout/presentation/cubit/mainlayout_cubit.dart';
import 'package:oreed_clean/features/verification/presentation/pages/payment_webview.dart';
import 'package:oreed_clean/networking/api_provider.dart';
import 'package:oreed_clean/features/technicalforms/presentation/cubit/technician_forms_cubit.dart';
import 'package:oreed_clean/features/technicalforms/presentation/cubit/technician_forms_state.dart';

enum PaymentResult { success, cancelled, failed }

class TechnicianAdService {
  static Future<void> submitAd({
    required BuildContext context,
    required AppTranslations? appTrans,
    required TextEditingController nameCtrl,
    required TextEditingController descCtrl,
    required TextEditingController phoneCtrl,
    required TextEditingController whatsappCtrl,
    required bool isEditing,
    required int? adId,
    required int sectionId,
    required int categoryId,
    required dynamic selectedState,
    required dynamic selectedCity,
    required List<File> galleryLocal,
    required File? mainImageFile,
    required int? companyId,
    required int? companyTypeId,
    required TechnicianFormsCubit cubit, // Changed from provider
    required VoidCallback showFillAllFieldsSnack,
    required List<String> Function()? validateFields,
  }) async {
    if (validateFields?.call().isNotEmpty ?? false) {
      showFillAllFieldsSnack();
      return;
    }

    try {
      final userId = AppSharedPreferences().getUserIdD();
      if (userId == null) {
        _showSnackBar(
          context,
          appTrans?.text('error.user_not_found') ??
              'لم يتم العثور على بيانات المستخدم، يرجى تسجيل الدخول مجددًا',
        );
        return;
      }

      if (isEditing) {
        await cubit.updateAd(
          id: adId!,
          name: nameCtrl.text,
          description: descCtrl.text,
          phone: phoneCtrl.text,
          whatsapp: whatsappCtrl.text,
          userId: userId,
          sectionId: sectionId,
          categoryId: categoryId,
          stateId: selectedState.id,
          cityId: selectedCity.id,
          mainImage: mainImageFile,
          galleryImages: galleryLocal,
          companyId: companyId,
          companyTypeId: companyTypeId,
        );

        if (cubit.state is AdUpdated) {
          _showSnackBar(
            context,
            appTrans?.text('success.technician_updated') ??
                'Ad updated successfully ✅',
          );
          if (context.mounted) Navigator.pop(context);
        } else if (cubit.state is AdUpdateError) {
          _showSnackBar(context, (cubit.state as AdUpdateError).message);
        }
      } else {
        // NEW AD MODE
        await cubit.submitAd(
          name: nameCtrl.text,
          description: descCtrl.text,
          phone: phoneCtrl.text,
          whatsapp: whatsappCtrl.text,
          userId: userId,
          sectionId: sectionId,
          categoryId: categoryId,
          stateId: selectedState.id,
          cityId: selectedCity.id,
          mainImage: mainImageFile!,
          galleryImages: galleryLocal,
          companyId: companyId,
          companyTypeId: companyTypeId,
        );

        final currentState = cubit.state;
        if (currentState is AdSubmitted) {
          await _handlePostSubmission(
            context: context,
            appTrans: appTrans,
            adResponseId: currentState.response.id ?? 0,
            userId: userId,
            companyId: companyId,
          );
        } else if (currentState is AdSubmissionError) {
          _showSnackBar(context, currentState.message);
        }
      }
    } catch (e) {
      _showSnackBar(
        context,
        '${appTrans?.text('error.publish_exception') ?? 'An error occurred'}: $e',
        isError: true,
      );
    }
  }

  static void _showSnackBar(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : null,
      ),
    );
  }

  static Future<void> _handlePostSubmission({
    required BuildContext context,
    required AppTranslations? appTrans,
    required int adResponseId,
    required int userId,
    int? companyId,
  }) async {
    // If it's a company, we usually skip the "Pin/Payment" step and go home
    if (companyId != null) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.homelayout,
        (_) => false,
      );
    } else {
      // Show screen to choose between Free or Paid Pin packages
      final choice = await PinChoiceScreen.show(context);

      if (choice == null || choice.isFree) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.homelayout,
          (_) => false,
        );
      } else {
        // Prepare Payment URL
        final url = Uri.parse(
          '${ApiProvider.baseUrl}/payment/request?user_id=$userId&packageId=${choice.id}&ads_id=$adResponseId&model=technician',
        );

        final result = await Navigator.push<PaymentResult>(
          context,
          MaterialPageRoute(
            builder: (_) => PaymentWebView(
              url: url.toString(),
              title: appTrans?.text('payment_title') ?? 'الدفع',
              successMatcher: (u) =>
                  u.contains('payment/success') || u.contains('status=success'),
              cancelMatcher: (u) =>
                  u.contains('payment/cancel') || u.contains('status=cancel'),
            ),
          ),
        );

        if (!context.mounted) return;

        switch (result) {
          case PaymentResult.success:
            // Assuming HomeProvider is still handled via Provider or adjust to Bloc
            context.read<HomelayoutCubit>().changeTabIndex(2);
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.homelayout,
              (_) => false,
              arguments: 2,
            );
            break;
          case PaymentResult.cancelled:
            _showSnackBar(
              context,
              appTrans?.text('payment.cancelled') ?? 'Payment cancelled',
            );
            break;
          default:
            _showSnackBar(
              context,
              appTrans?.text('payment.failed') ?? 'Payment failed',
            );
        }
      }
    }
  }
}
