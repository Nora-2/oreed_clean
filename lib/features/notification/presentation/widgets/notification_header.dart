import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';

class NotificationHeader extends StatelessWidget {
  final VoidCallback onBackTap;
  final VoidCallback? onDeleteAllTap;
  final bool isDeleteEnabled;
  final String deleteLabel;

  const NotificationHeader( {
    super.key,
    required this.onBackTap,
    this.onDeleteAllTap,
    this.isDeleteEnabled = true,
    this.deleteLabel = 'Delete all',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: onBackTap,
          icon: const Icon(Icons.arrow_back, color: Color(0xFF000000)), // Replace with AppColors.primary
          style: IconButton.styleFrom(backgroundColor: const Color(0xffe8e8e9)),
        ),
        GestureDetector(
          onTap: isDeleteEnabled ? onDeleteAllTap : null,
          child: Opacity(
            opacity: isDeleteEnabled ? 1.0 : 0.5,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: const Color(0xffF7F7F7),
              ),
              child: Row(
                children: [
                  Text(
                    deleteLabel,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xff676768),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 5),
                  SvgPicture.asset('assets/svg/trash.svg'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}