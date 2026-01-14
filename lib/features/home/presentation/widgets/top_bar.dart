import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oreed_clean/core/utils/appicons/app_icons.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage('assets/images/logo.png'),
          ),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/notification'),
            icon: SvgPicture.asset(AppIcons.notification, width: 25),
          ),
        ],
      ),
    );
  }
}
