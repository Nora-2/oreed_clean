import 'package:flutter/material.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';

enum ImageSourceChoice { camera, gallery }

Future<ImageSourceChoice?> showImageSourceSheet(
   BuildContext context,
    {
  
  String? cameraLabel,
  String? galleryLabel,
}) {
  final trans = AppTranslations.of(context);
  final actualCameraLabel =
      cameraLabel ?? trans?.text("photos.camera") ?? 'Camera';
  final actualGalleryLabel =
      galleryLabel ?? trans?.text("photos.gallery_source") ?? 'Gallery';

  return showModalBottomSheet<ImageSourceChoice>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
    ),
    builder: (_) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border.all(color: AppColors.secondary, width: 2),
              borderRadius: BorderRadius.circular(40)),
          child: Row(
            children: [
               Expanded(
                  child: GestureDetector(
                    onTap:()=>  Navigator.pop(context, ImageSourceChoice.camera),
                    child: Container(
                      padding:const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.primary),
                                    child: Text(
                                      actualCameraLabel,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: AppColors.whiteColor),
                                    ),
                                  ),
                  )),
            
              const SizedBox(width: 12),
              Expanded(
                  child: GestureDetector(
                    onTap:()=> Navigator.pop(context, ImageSourceChoice.gallery),
                    child: Container(
                      padding:const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.primary),
                                    child: Text(
                                      actualGalleryLabel,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: AppColors.whiteColor),
                                    ),
                                  ),
                  )),
            ],
          ),
        ),
      ),
    ),
  );
}
