// utils/submission_handler.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oreed_clean/core/app_shared_prefs.dart';
import 'package:oreed_clean/core/routing/routes.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/shared_widgets/generic_review_screen.dart';
import 'package:oreed_clean/core/utils/shared_widgets/pin_choice_screen.dart';
import 'package:oreed_clean/features/mainlayout/presentation/cubit/mainlayout_cubit.dart';
import 'package:oreed_clean/features/realstateform/data/models/properity_form_wizerd_state.dart';
import 'package:oreed_clean/features/realstateform/domain/entities/realstate_entity.dart';
import 'package:oreed_clean/features/realstateform/domain/repositories/realstate_repo.dart';
import 'package:oreed_clean/features/realstateform/presentation/cubit/realstateform_cubit.dart';
import 'package:oreed_clean/features/realstateform/presentation/pages/realstate_form.dart';
import 'package:oreed_clean/features/technicalforms/presentation/widgets/review_section.dart';
import 'package:oreed_clean/features/verification/presentation/pages/payment_webview.dart';
import 'package:oreed_clean/networking/api_provider.dart';

class SubmissionHandler {
  final RealEstateFormUI widget;
  final TextEditingController titleCtrl;
  final TextEditingController addressCtrl;
  final TextEditingController priceCtrl;
  final TextEditingController descCtrl;
  final TextEditingController areaCtrl;
  final String? Function() getRooms;
  final String? Function() getBaths;
  final String? Function() getFloor;
  final String? Function() getEstateType;
  final int? Function() getCountryId;
  final int? Function() getStateId;
  final ImageSlot? Function() getMainImage;
  final List<ImageSlot> Function() getImages;
  final Function(bool) setLoading;

  SubmissionHandler({
    required this.widget,
    required this.titleCtrl,
    required this.addressCtrl,
    required this.priceCtrl,
    required this.descCtrl,
    required this.areaCtrl,
    required this.getRooms,
    required this.getBaths,
    required this.getFloor,
    required this.getEstateType,
    required this.getCountryId,
    required this.getStateId,
    required this.getMainImage,
    required this.getImages,
    required this.setLoading,
  });

  Future<void> handleReview(
      BuildContext context, List<ReviewSection> sections) async {
    final appTrans = AppTranslations.of(context);

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GenericReviewScreen(
          pageTitle: appTrans?.text('review.property_page_title') ??
              'Review Property Ad',
          sections: sections,
          requireAgreement: true,
          confirmLabel:
              appTrans?.text('action.confirm_publish') ?? 'تأكيد ونشر',
          onConfirm: () async {
            Navigator.pop(context);
            await _submitForm(context);
          },
        ),
      ),
    );
  }

  Future<void> _submitForm(BuildContext context) async {
    final appTrans = AppTranslations.of(context);
    final cubit = context.read<RealstateformCubit>();

    try {
      final userId = AppSharedPreferences().getUserIdD();
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              appTrans?.text('error.user_not_found') ??
                  'لم يتم العثور على بيانات المستخدم، يرجى تسجيل الدخول مجددًا',
            ),
          ),
        );
        return;
      }

      setLoading(true);

      if (widget.adId != null) {
        await _updateProperty(cubit);
      } else {
        await _createProperty(cubit, userId);
      }
    } catch (e) {
      // Error handled in BLoC listener
    } finally {
      setLoading(false);
    }
  }

  Future<void> _updateProperty(RealstateformCubit cubit) async {
    File? mainImageFile = getMainImage()?.file;
    final galleryPickedFiles =
        getImages().where((s) => s.file != null).map((s) => s.file!).toList();
    List<File> galleryFiles = [];

    if (galleryPickedFiles.isNotEmpty) {
      galleryFiles = galleryPickedFiles.toList();
    }

    if (mainImageFile == null && galleryFiles.isNotEmpty) {
      mainImageFile = galleryFiles.first;
      if (galleryFiles.length > 1) {
        galleryFiles = galleryFiles.skip(1).toList();
      } else {
        galleryFiles = [];
      }
    }

    await cubit.updateProperty(
      EditPropertyParams(
        id: widget.adId!,
        titleAr: titleCtrl.text.trim().isNotEmpty ? titleCtrl.text.trim() : null,
        descriptionAr:
            descCtrl.text.trim().isNotEmpty ? descCtrl.text.trim() : null,
        addressAr:
            addressCtrl.text.trim().isNotEmpty ? addressCtrl.text.trim() : null,
        price: priceCtrl.text.trim().isNotEmpty ? priceCtrl.text.trim() : null,
        rooms: getRooms(),
        bathrooms: getBaths(),
        area: areaCtrl.text.trim().isNotEmpty ? areaCtrl.text.trim() : null,
        floor: getFloor(),
        type: getEstateType() == 'سكني' ? 'residential' : 'commercial',
        stateId: getCountryId(),
        cityId: getStateId(),
        mainImage: mainImageFile,
        galleryImages: galleryFiles,
      ),
    );
  }

  Future<void> _createProperty(RealstateformCubit cubit, int userId) async {
    final propertyTypeKey = (getEstateType() == 'سكني')
        ? 'residential'
        : (getEstateType() == 'تجاري')
            ? 'commercial'
            : '';

    final galleryPickedPaths =
        getImages().where((s) => s.file != null).map((s) => s.file!.path).toList();
    final imagePaths = <String>[];

    if (getMainImage()?.file != null) {
      imagePaths.add(getMainImage()!.file!.path);
      imagePaths.addAll(galleryPickedPaths);
    } else if (galleryPickedPaths.isNotEmpty) {
      imagePaths.add(galleryPickedPaths.first);
      if (galleryPickedPaths.length > 1) {
        imagePaths.addAll(galleryPickedPaths.skip(1));
      }
    }

    final property = PropertyEntity(
      titleAr: titleCtrl.text.trim(),
      descriptionAr: descCtrl.text.trim(),
      addressAr: addressCtrl.text.trim(),
      sectionId: widget.sectionId,
      categoryId: widget.categoryId,
      subCategoryId: widget.supCategoryId,
      price: priceCtrl.text.trim(),
      rooms: getRooms() ?? '',
      bathrooms: getBaths() ?? '',
      area: areaCtrl.text.trim(),
      floor: getFloor() ?? '',
      type: propertyTypeKey,
      stateId: getCountryId() ?? 0,
      cityId: getStateId() ?? 0,
      userId: userId,
      imagePaths: imagePaths,
      companyId: widget.companyId,
      companyTypeId: widget.companyTypeId,
    );

    await cubit.submitProperty(property);
  }

  void handleSuccess(BuildContext context, RealstateformSuccess state) {
    final appTrans = AppTranslations.of(context);

    if (widget.adId != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            appTrans?.text('success.property_updated') ??
                'تم حفظ التعديلات بنجاح ✅',
          ),
        ),
      );
      Navigator.pop(context, true);
    } else {
      if (widget.companyId != null || widget.companyTypeId != null) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(Routes.homelayout, (_) => false);
        return;
      }

      PinChoiceScreen.show(context).then((choice) {
        if (choice == null || choice.isFree) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(Routes.homelayout, (_) => false);
        } else {
          _handlePayment(context, choice.id, state.response.id!);
        }
      });
    }
  }

  void _handlePayment(BuildContext context, int packageId, int adId) {
    final appTrans = AppTranslations.of(context);
    final userId = AppSharedPreferences().getUserIdD();
    final url = Uri.parse(
        '${ApiProvider.baseUrl}/payment/request?user_id=$userId&packageId=$packageId&ads_id=$adId&model=property');

    Navigator.push<PaymentResult>(
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
    ).then((result) {
      if (!context.mounted) return;
      if (result == PaymentResult.success) {
        context.read<HomelayoutCubit>().changeTabIndex(2);
        Navigator.of(context).pushNamedAndRemoveUntil(
          Routes.homelayout,
          (_) => false,
          arguments: 2,
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
    });
  }
}