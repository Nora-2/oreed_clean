import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotificationTitleBar extends StatelessWidget {
  final String title;
  final String markReadLabel;
  final bool isMarkReadEnabled;
  final VoidCallback? onMarkReadTap;

  const NotificationTitleBar({
    super.key,
    required this.title,
    this.markReadLabel = 'Mark all read',
    this.isMarkReadEnabled = true,
    this.onMarkReadTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
        GestureDetector(
          onTap: isMarkReadEnabled ? onMarkReadTap : null,
          child: Opacity(
            opacity: isMarkReadEnabled ? 1.0 : 0.5,
            child: Row(
              children: [
                Text(
                  markReadLabel,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.blue, // Replace with AppColors.primary
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 5),
                SvgPicture.asset('assets/svg/read.svg'),
              ],
            ),
          ),
        )
      ],
    );
  }
}