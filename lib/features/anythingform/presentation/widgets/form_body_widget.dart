import 'package:flutter/material.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/shared_widgets/generic_review_screen.dart';
import 'package:oreed_clean/features/anythingform/presentation/widgets/anything_form_fields.dart';
import 'package:oreed_clean/features/anythingform/presentation/widgets/anything_form_header.dart';
import 'package:oreed_clean/features/anythingform/presentation/widgets/anything_images_section.dart';
import 'package:oreed_clean/features/anythingform/presentation/widgets/anything_location_selector.dart';
import 'package:oreed_clean/features/anythingform/presentation/widgets/anything_submit_button.dart';
import 'package:oreed_clean/features/anythingform/presentation/widgets/form_validator.dart';
import 'package:oreed_clean/features/anythingform/presentation/widgets/image_picker_handler.dart';
import 'package:oreed_clean/features/anythingform/presentation/widgets/remote_image_deleter.dart';
import 'package:oreed_clean/features/anythingform/presentation/widgets/review_builder.dart';
import 'package:oreed_clean/features/anythingform/presentation/widgets/state_manager.dart';
import 'package:oreed_clean/features/anythingform/presentation/widgets/submit_handler.dart';
import 'package:oreed_clean/features/dynamicfields/presentation/pages/dynamic_fields_section.dart';
import 'package:oreed_clean/features/technicalforms/presentation/widgets/image_source_sheet.dart';

class AnythingFormBody extends StatelessWidget {
  final AnythingFormStateManager stateManager;
  final dynamic widget;
  final AnythingImagePickerHandler imagePickerHandler;
  final AnythingRemoteImageDeleter remoteImageDeleter;
  final AnythingReviewBuilder reviewBuilder;
  final AnythingFormValidator validator;
  final AnythingSubmitHandler submitHandler;

  const AnythingFormBody({
    super.key,
    required this.stateManager,
    required this.widget,
    required this.imagePickerHandler,
    required this.remoteImageDeleter,
    required this.reviewBuilder,
    required this.validator,
    required this.submitHandler,
  });

  @override
  Widget build(BuildContext context) {
    final appTrans = AppTranslations.of(context);
    final isEditing = stateManager.isEditing(widget.adId);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const AnythingFormHeader(),
        
        AnythingFormFields(
          titleCtrl: stateManager.titleCtrl,
          priceCtrl: stateManager.priceCtrl,
          descCtrl: stateManager.descCtrl,
        ),

        AnythingLocationSelector(
          selectedCountryId: stateManager.selectedCountryId,
          selectedCountryName: stateManager.selectedCountryName,
          selectedStateName: stateManager.selectedStateName,
          onCountrySelected: (id, name) {
            stateManager.selectedCountryId = id;
            stateManager.selectedCountryName = name;
            stateManager.selectedStateId = null;
            stateManager.selectedStateName = null;
          },
          onStateSelected: (id, name) {
            stateManager.selectedStateId = id;
            stateManager.selectedStateName = name;
          },
        ),

        const SizedBox(height: 30),
        DynamicFieldsSection(
          sectionId: widget.sectionId,
          initData: stateManager.dynamicFieldValues,
          onChanged: (fields) => stateManager.dynamicFieldValues = fields,
        ),
        const SizedBox(height: 30),

        AnythingImagesSection(
          mainImageFile: stateManager.mainImageFile,
          mainImageUrl: stateManager.mainImageUrl,
          galleryRemote: stateManager.galleryRemote,
          galleryLocal: stateManager.galleryLocal,
          deletingRemote: stateManager.deletingRemote,
          onPickMainImage: (choice) async {
            if (choice == ImageSourceChoice.camera) {
              await imagePickerHandler.pickMainFromCamera();
            } else if (choice == ImageSourceChoice.gallery) {
              await imagePickerHandler.pickMainFromGallery();
            }
          },
          onPickGalleryImage: (choice) async {
            if (choice == ImageSourceChoice.camera) {
              await imagePickerHandler.pickGalleryFromCamera();
            } else if (choice == ImageSourceChoice.gallery) {
              await imagePickerHandler.pickGalleryFromGallery();
            }
          },
          onRemoveMainImage: () => imagePickerHandler.removeMainImage(),
          onRemoveLocalGalleryImage: imagePickerHandler.removeLocalGalleryAt,
          onConfirmDeleteRemoteImage: (mediaItem) {
            if (widget.adId != null) {
              remoteImageDeleter.confirmAndDelete(
                context,
                mediaItem,
                widget.adId!,
                widget.sectionId,
              );
            }
          },
        ),

        const SizedBox(height: 16),

        AnythingSubmitButton(
          isLoading: stateManager.isLoading,
          onTap: () => _handleSubmitTap(context, appTrans, isEditing),
        ),
      ],
    );
  }

  Future<void> _handleSubmitTap(
    BuildContext context,
    AppTranslations? appTrans,
    bool isEditing,
  ) async {
    final errors = validator.validateFields(appTrans, isEditing);
    if (errors.isNotEmpty && !isEditing) {
      validator.showFillAllFieldsSnack(context, appTrans);
      return;
    }

    final sections = reviewBuilder.buildSections(appTrans);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GenericReviewScreen(
          pageTitle: appTrans?.text('review.anything_page_title') ?? 
              'مراجعة الإعلان',
          sections: sections,
          requireAgreement: true,
          confirmLabel: appTrans?.text('action.confirm_publish') ?? 
              'تأكيد ونشر',
          onConfirm: () async {
            Navigator.pop(context);
            await submitHandler.handleSubmit(context);
          },
        ),
      ),
    );
  }
}
