import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oreed_clean/core/utils/appicons/app_icons.dart';

class PhoneActionRow extends StatelessWidget {
  final String phone;
  final VoidCallback onCall;
  final VoidCallback onWhatsApp;

  const PhoneActionRow({
    super.key,
    required this.phone,
    required this.onCall,
    required this.onWhatsApp,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.ltr,
      children: [
        // Left Side: Action Buttons
        GestureDetector(
          onTap: onCall,
          child: Container(
            width: 38,
            height: 38,
            padding: EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFFE8F5E9), // Very light green
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(AppIcons.phone, color: Color(0xff3AA517)),
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: onWhatsApp,
          child: Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              color: Color(0xFFF5F5F5), // Light gray
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                AppIcons.whatsapp,
                width: 30,
                height: 30,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),

        const Spacer(),

        // Right Side: Phone number and blue icon
        Text(
          phone,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xff557BE1), // Blue color from image
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 10),
        SvgPicture.asset(
          AppIcons.phone,
          color: Color(0xff557BE1),
          width: 22,
          height: 22,
        ),
      ],
    );
  }
}
