import 'package:flutter/material.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/features/addetails/domain/entities/ad_detiles_entity.dart';
import 'package:oreed_clean/features/addetails/presentation/widgets/fullscreen_imageview.dart';

class BuildInspectioncert extends StatelessWidget {
  const BuildInspectioncert({
    super.key,
    required this.context,
    required this.ad,
    required this.carDoc,
    required this.t,
  });

  final BuildContext context;
  final AdDetailesEntity ad;
  final String carDoc;
  final AppTranslations? t;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0x11E53935), Color(0x112563EB)],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(1.2),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: const Color(0x0F000000)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Row(
                children: [
                  Container(width: 3, height: 20, color: AppColors.secondary),
                  const SizedBox(width: 5),
                  Text(
                    t?.text('ad_details.inspection_certificate') ??
                        'شهادة الفحص',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () => _openImageFullScreen(
                  context,
                  carDoc,
                  heroTag: 'car-doc-${ad.id}',
                ),
                child: Hero(
                  tag: 'car-doc-${ad.id}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      carDoc,
                      height: 60,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===================== Full-screen image viewer =====================
void _openImageFullScreen(BuildContext context, String url, {String? heroTag}) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => FullScreenImageView(imageUrl: url, heroTag: heroTag),
    ),
  );
}
