import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oreed_clean/core/translation/appTranslations.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/appicons/app_icons.dart';
import 'package:oreed_clean/features/notification/presentation/cubit/notification_cubit.dart';

class BuildHeader extends StatelessWidget {
  const BuildHeader({
    super.key,
    required this.context,
    required this.tr,
    required this.state,
    required this. cubit,
  });

  final BuildContext context;
  final AppTranslations? tr;
  final NotificationsState state;
  final NotificationsCubit? cubit;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: AppColors.primary),
          style: IconButton.styleFrom(backgroundColor: const Color(0xffe8e8e9)),
        ),
        GestureDetector(
          onTap: state.isEmpty ? null : () => _confirmDeleteAll(context,cubit),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: const Color(0xffF7F7F7),
            ),
            child: Row(
              children: [
                Text(
                  tr?.text('delete_all') ?? 'Delete all',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xff676768),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 5),
                SvgPicture.asset(AppIcons.trash),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _confirmDeleteAll(BuildContext context, NotificationsCubit? cubit) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirm"),
        content: const Text("Delete all notifications?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              cubit?.deleteAll();
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
