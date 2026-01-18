import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glasses/core/routing/routes.dart';
import 'package:glasses/core/utils/appcolors/app_colors.dart';
import 'package:glasses/core/utils/appstring/app_string.dart';
import 'package:glasses/core/utils/widgets/my_flutter_app_icons.dart';

// ignore: must_be_immutable
class OnboardingbottomPart extends StatelessWidget {
  OnboardingbottomPart({
    super.key,
    required this.pageIndex,
    required this.pageController,
  });
  int pageIndex;
  PageController pageController;

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Previous button
        Visibility(
          visible: pageIndex > 0,
          child: GestureDetector(
            onTap: () {
              pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 9.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.r),
                border: Border.all(color: appcolors.whicolor, width: 1),
              ),
              child: Text(
                Appstring.previous,
                style: TextStyle(
                  color: appcolors.whicolor,
                  fontSize: 14.sp,
                  fontFamily: Appstring.fontfamily,
                ),
              ),
            ),
          ),
        ),

        SizedBox(width: 10.w),
       
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              if (pageIndex < 3 - 1) {
                pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              } else {
                
            Navigator.pushReplacementNamed(context, Routes.login
    ); }
            },
            icon: Icon(
             MyFlutterApp.arrow_left,
              color: appcolors.primarycolor,
              size: 22.w,
            ),
            label: Text(
              Appstring.next,
              style: TextStyle(
                color: appcolors.primarycolor,
                fontSize: 14.sp,
                fontFamily: Appstring.fontfamily,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: appcolors.buttoncoloronboarding,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            ),
          ),
        ),
      ],
    );
  }
}
