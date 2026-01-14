
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oreed_clean/features/notification/data/models/notification_model.dart';

class NotificationTile extends StatelessWidget {
  final NotificationModel n;
  final String icon;
  final BuildContext context;
  final VoidCallback onTap;

  const NotificationTile({super.key, required this.n, required this.icon, required this.context, required this.onTap});

  @override
  Widget build(BuildContext context) {
   
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        color: n.isRead ? Colors.transparent : const Color(0xFF2563EB).withValues(alpha: 0.02),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (n.image != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(imageUrl: n.image!, width: 80, height: 60, fit: BoxFit.cover),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(n.title, style: TextStyle(fontSize: 14, fontWeight: n.isRead ? FontWeight.w600 : FontWeight.w800)),
                  Text(n.body, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)), maxLines: 2),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(color: Color(0xFFEFF6FF), shape: BoxShape.circle),
              child: SvgPicture.asset(icon, width: 18, colorFilter: const ColorFilter.mode(Color(0xFF2563EB), BlendMode.srcIn)),
            ),
          ],
        ),
      ),
    );
  }
}
