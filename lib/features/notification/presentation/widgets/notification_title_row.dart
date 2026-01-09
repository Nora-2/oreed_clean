import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/features/notification/presentation/cubit/notification_cubit.dart';

import '../../../../core/utils/appicons/app_icons.dart';

class TitleRow extends StatelessWidget {
  const TitleRow({
    super.key,
    required NotificationsCubit? cubit,
    required this.tr,
    required this.state,
  }) : _cubit = cubit;

  final NotificationsCubit? _cubit;
  final AppTranslations? tr;
  final NotificationsState state;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(tr?.text('notifications') ?? 'Notifications', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
        GestureDetector(
          onTap: state.unreadCount == 0 ? null : () => _cubit?.markAllAsRead(),
          child: Row(
            children: [
              Text(tr?.text('mark_all_read') ?? 'Mark all read', style:  TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary, fontSize: 13)),
              const SizedBox(width: 5),
              SvgPicture.asset(AppIcons.read)
            ],
          ),
        )
      ],
    );
  }
}



