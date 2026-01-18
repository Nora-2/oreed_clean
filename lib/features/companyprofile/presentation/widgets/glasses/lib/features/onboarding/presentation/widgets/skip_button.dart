
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:glasses/core/routing/routes.dart';
import 'package:glasses/core/utils/appcolors/app_colors.dart';
import 'package:glasses/core/utils/appicons/app_icons.dart';
import 'package:glasses/core/utils/appstring/app_string.dart';

class Skipbutton extends StatelessWidget {
  const Skipbutton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
               Navigator.pushReplacementNamed(context, Routes.login
    );
      },
      child: Row(
        children: [
          Text(
            Appstring.skip,
            style: TextStyle(
              color: appcolors.whicolor.withOpacity(.9),
              fontSize: 14.sp,
              height: 1.25,
              fontFamily:Appstring.fontfamily,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 5.w),
          SvgPicture.asset(Appicons.close),
        ],
      ),
    );
  }
}
