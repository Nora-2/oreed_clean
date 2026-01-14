// lib/view/screens/details_ads/widgets/inspection_certificate_badge.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:oreed_clean/features/addetails/presentation/widgets/full_screen_gallery.dart';

class InspectionCertificateBadge extends StatelessWidget {
  final List<String> images;
  final String label;

  const InspectionCertificateBadge({
    super.key,
    required this.images,
    this.label = 'شهادة فحص معتمدة',
  });

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) return const SizedBox.shrink();

    // ألوان متناسقة وهادية
    const Color green = Color(0xFF2E7D32);
    const Color greenLight = Color(0xFFEAF6EC);

    return Align(
      alignment: Alignment.centerRight,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => FullScreenGalleryView(
                images: images,
                initialIndex: 0,
                heroTagPrefix: '',
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsetsDirectional.fromSTEB(14, 8, 10, 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: green.withOpacity(.25), width: 1),
            boxShadow: const [
              BoxShadow(
                color: Color(0x12000000),
                blurRadius: 10,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // دائرة أيقونة صغيرة بظل خفيف
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: greenLight,
                  shape: BoxShape.circle,
                  border: Border.all(color: green.withOpacity(.15)),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  FontAwesomeIcons.shieldAlt,
                  size: 14,
                  color: green,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: green,
                  height: 1.1,
                ),
              ),
              const SizedBox(width: 8),
              // سهم صغير يوحي إن في تنقّل لعرض
              const Icon(
                Icons.arrow_back_ios_new_rounded, // RTL -> سهم لليسار
                size: 14,
                color: green,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
