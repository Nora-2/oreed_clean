import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oreed_clean/core/utils/appicons/app_icons.dart';

class SearchBarcompanytype extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final Color borderColor;

  const SearchBarcompanytype({
    super.key,
    required this.controller,
    required this.hintText,
    this.onChanged,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SvgPicture.asset(
              AppIcons.search,
              width: 16,
              height: 16,
              color: Colors.grey.shade400,
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              textAlign: isRTL ? TextAlign.right : TextAlign.left,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 7),
              ),
            ),
          ),
          if (controller.text.isNotEmpty)
            IconButton(
              icon: Icon(
                Icons.close_rounded,
                size: 20,
                color: Colors.grey.shade500,
              ),
              onPressed: () {
                controller.clear();
                onChanged?.call('');
              },
            ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
