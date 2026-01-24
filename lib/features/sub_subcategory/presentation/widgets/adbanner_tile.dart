import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:oreed_clean/core/routing/routes.dart';
import 'package:oreed_clean/core/utils/shared_widgets/shimmer.dart';
import 'package:oreed_clean/features/home/data/models/ad_model.dart';
import 'package:url_launcher/url_launcher.dart';

class AdBannerTile extends StatelessWidget {
  final AdModel adItem;
  final double height;

  const AdBannerTile({
    super.key,
    required this.adItem,
    this.height = 160.0,
  });

  Future<void> _onAdPressed(BuildContext context) async {
    final link = adItem.link?.trim();

    if (link == null || link.isEmpty) return;

    // لينك خارجي
    if ((adItem.type ?? '').toLowerCase() == 'external') {
      final uri = Uri.tryParse(link);
      if (uri != null && await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
      return;
    }

    // لينك داخلي... نستخرج الـ id
    final match = RegExp(r'/technicans/([^/?#]+)').firstMatch(link);
    if (match != null && match.group(1) != null) {
      final String id = match.group(1)!;
      if (context.mounted) {
        Navigator.of(context).pushNamed(
           Routes.addetails,
           arguments: { 'workerId': id}
         
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String title = (adItem.title ?? '').trim();
    final String imageUrl = (adItem.image?.trim().isNotEmpty == true)
        ? adItem.image!.trim()
        : 'https://via.placeholder.com/1200x800?text=Ad';

    final double width = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () => _onAdPressed(context),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: width,
        height: height,
        margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // الصورة
              CachedNetworkImage(
                imageUrl: imageUrl,
                width: width,
                height: height,
                fit: BoxFit.cover,
                placeholder: (context, url) => ShimmerBox(
                  width: double.infinity,
                  height: double.infinity,
                  borderRadius: BorderRadius.circular(12),
                ),
                errorWidget: (_, __, ___) => Container(
                  color: Colors.grey.shade200,
                  alignment: Alignment.center,
                  child: const Icon(Icons.broken_image, size: 36),
                ),
              ),

              // تدرج غامق لقراءة العنوان
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: 70,
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.45),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // العنوان
              if (title.isNotEmpty)
                Positioned(
                  left: 12,
                  right: 12,
                  bottom: 12,
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17.0,
                      fontWeight: FontWeight.w600,
                      height: 1.1,
                      shadows: [
                        Shadow(
                          color: Colors.black54,
                          blurRadius: 4,
                          offset: Offset(0, 1),
                        ),
                      ],
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
