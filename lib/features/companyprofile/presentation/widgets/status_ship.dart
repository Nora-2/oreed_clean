
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appicons/app_icons.dart';

class StatusChip extends StatelessWidget {
  final String status;
  final String date;

  const StatusChip({super.key, required this.status, required this.date});

  String _formatDateOnly(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '';

    try {
      final dateTime = DateTime.tryParse(dateString);
      if (dateTime == null) return dateString;

      // Format as YYYY-MM-DD
      return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final t = AppTranslations.of(context);
    final s = status.trim();
    final bool isActive = s.toLowerCase() != 'pending';
    final bool isExpired = s.toLowerCase() == 'expired';

    if (isActive) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
          AppIcons.active,
            width: 25,
            height: 25,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xff3AA517),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xff3AA517), width: 1),
            ),
            child: Text(
              '${t?.text('active_until') ?? 'نشط حتي'} " ${_formatDateOnly(date)}"',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 10,
              ),
            ),
          ),
        ],
      );
    }
    if (isExpired) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            AppIcons.exit,
            width: 25,
            height: 25,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xffA72424),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xffA72424), width: 1),
            ),
            child: Text(
              t?.text('expired') ?? 'منتهي الصلاحية',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 10,
              ),
            ),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            AppIcons.bending,
            width: 25,
            height: 25,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xff1146D1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xff1146D1), width: 1),
            ),
            child: Text(
              t?.text('pending_approval') ?? 'بانتظار الموافقة',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 10,
              ),
            ),
          ),
        ],
      );
    }
  }
}


/// كبسولة معلومات صغيرة
class InfoPill extends StatelessWidget {
  final String icon;
  final String label;

  const InfoPill({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            icon,
            color: const Color(0xffE8E8E9),
            width: 10,
            height: 10,
          ),
          const SizedBox(width: 4),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 120),
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xffE8E8E9),
                fontWeight: FontWeight.w600,
                fontSize: 10,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

