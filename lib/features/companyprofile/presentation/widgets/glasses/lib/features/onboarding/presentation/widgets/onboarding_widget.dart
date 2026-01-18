import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glasses/core/utils/appcolors/app_colors.dart';
import 'package:glasses/core/utils/appstring/app_string.dart';
import 'package:glasses/features/onboarding/data/models/on_boardingmodel.dart';
import 'package:glasses/features/onboarding/presentation/widgets/onboarding_bottom.dart';
import 'package:glasses/features/onboarding/presentation/widgets/onboarding_top.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

Widget buildOnboardingPage(
  BuildContext context,
  OnboardingItem pageData,
  int pageIndex,
  int totalPages,
  PageController pageController,
) {
  return Container(
    width: 1.sw, // 100% of screen width
    height: 1.sh, // 100% of screen height
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage(pageData.imageUrl),
        fit: BoxFit.cover,
      ),
    ),
    child: SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20.w, // Use .w for horizontal padding
          vertical: 10.h, // Use .h for vertical padding
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Toppartonboparding(pageIndex: pageIndex,),
            SizedBox(height: 380.h), // Responsive spacer
            // Main text content
            Text(
              pageData.title,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Colors.white,
                fontSize: 28.sp, // Responsive font size
                fontWeight: FontWeight.w600,
                fontFamily:  Appstring.fontfamily
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              pageData.description,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: appcolors.slider.withOpacity(.8),
                fontSize: 12.sp,
                fontFamily: Appstring.fontfamily,
                fontWeight: FontWeight.w400, // Responsive font size
              ),
            ),
            SizedBox(height: 12.h),

            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                padding: EdgeInsets.only(bottom: 30.h, left: 280.w, right: 2.w),
                child: Column(
                  children: [
                    SmoothPageIndicator(
                      controller: pageController,
                      count: 3,
                      textDirection: TextDirection.rtl,
                      effect: ExpandingDotsEffect(
                        activeDotColor: appcolors.primarycolor,
                        dotColor: appcolors.whicolor,
                        dotHeight: 5.w,
                        dotWidth: 6.w,
                        expansionFactor: 7, // Makes the active dot expand
                        spacing: 3.w,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 10.h,),
            OnboardingbottomPart(pageController: pageController,pageIndex: pageIndex,)
          ],
        ),
      ),
    ),
  );
}
