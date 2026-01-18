
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BottomActionButton extends StatelessWidget {
  final String text;
  final String icon;
  final Color color;

  const BottomActionButton({super.key, 
    required this.text,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        textDirection: isRTL ? TextDirection.ltr : TextDirection.rtl,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          isRTL ? const SizedBox(width: 20) : const SizedBox(width: 0),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          SvgPicture.asset(
            icon,
            width: 25,
            height: 25,
            fit: BoxFit.fill,
          ),
        ],
      ),
    );
  }
}
