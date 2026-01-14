import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SocilaButton extends StatelessWidget {
  final String profileUrl; // لينك حساب الفني على تيك توك
  final String iconAsset; // صورة أيقونة تيك توك (png/svg)

  const SocilaButton({
    super.key,
    required this.profileUrl,
    required this.iconAsset,
  });

  Future<void> _openTikTok() async {
    final uri = Uri.parse(profileUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openTikTok,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),

          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.asset(
                iconAsset,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
