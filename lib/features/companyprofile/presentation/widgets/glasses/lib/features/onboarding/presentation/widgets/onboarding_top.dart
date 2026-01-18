
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glasses/core/utils/appcolors/app_colors.dart';
import 'package:glasses/core/utils/widgets/my_flutter_app_icons.dart';
import 'package:glasses/features/onboarding/presentation/widgets/skip_button.dart';

// ignore: must_be_immutable
class Toppartonboparding extends StatelessWidget {
   Toppartonboparding({super.key,required this.pageIndex,});
  int pageIndex;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment
          .spaceBetween, // This might not be necessary with Spacer()
      children: [
        Visibility(
          
          visible: pageIndex ==1||pageIndex ==0,
          child: Container(
            // Removed redundant GestureDetector
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.5.h),
            decoration: BoxDecoration(
              color:  appcolors.buttoncoloronboarding.withAlpha(28), // Use const for better performance
              borderRadius: BorderRadius.circular(25.r),
            ),
            child: const Skipbutton(), // Use const for better performance
          ),
        ),
        Icon(
        MyFlutterApp.logo,
          size: 35.w,
          color: appcolors.primarycolor,
        ),
      ],
    );
  }
}
