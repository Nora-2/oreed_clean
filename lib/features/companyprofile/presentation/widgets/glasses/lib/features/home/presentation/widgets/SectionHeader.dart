import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glasses/core/utils/appcolors/app_colors.dart';
import 'package:glasses/core/utils/appstring/app_string.dart';
import 'package:glasses/core/utils/widgets/my_flutter_app_icons.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const SectionHeader({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold,   
                 
                  fontFamily: Appstring.fontfamily),
        ),
        GestureDetector(
          onTap: onTap,
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              Text(
                Appstring.viewall,
                style: TextStyle(
                  fontSize: 12.sp,
                  color:appcolors.grayviewall,
                  fontWeight: FontWeight.w200,
                 fontFamily:  Appstring.fontfamily
                ),
              ),
              SizedBox(width:  2.w),
              Icon(MyFlutterApp.arrow_left, color:appcolors.grayviewall,size: 20,)
            ],
          ),
        ),
      ],
    );
  }
}
