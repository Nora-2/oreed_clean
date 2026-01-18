// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glasses/core/routing/routes.dart';
import 'package:glasses/core/utils/appcolors/app_colors.dart';
import 'package:glasses/core/utils/appicons/app_icons.dart';
import 'package:glasses/core/utils/appimage/app_images.dart';
import 'package:glasses/core/utils/appstring/app_string.dart';
import 'package:glasses/core/utils/widgets/my_flutter_app_icons.dart';

class Signin_Signup extends StatefulWidget {
  const Signin_Signup({super.key});

  @override
  State<Signin_Signup> createState() => _Signin_SignupState();
}

class _Signin_SignupState extends State<Signin_Signup> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: appcolors.transcolor, elevation: 0),
      extendBodyBehindAppBar: true,
      body: Scaffold(
        body: Container(
          width: 1.sw, // 100% of screen width
          height: 1.sh, // 100% of screen height
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Appimage.login),
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
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 280.h), // Responsive spacer
                  Image.asset(
                    Appicons.logo,
                    width: 40.h,
                    height: 40.h,
                    color: appcolors.primarycolor
                  ),
                  Text(
                    Appstring.splashTitle,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: appcolors.whicolor,
                      fontSize: 20.sp, // Responsive font size
                      fontWeight: FontWeight.w600,
                      fontFamily: Appstring.fontfamily
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    Appstring.splashSubtitle,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: appcolors.graytestonboard.withOpacity(.8),
                      fontSize: 18.sp,
                      fontFamily: Appstring.fontfamily,
                      fontWeight: FontWeight.w400, // Responsive font size
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    Appstring.loginTitle,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: appcolors.whicolor,
                      fontSize: 20.sp, // Responsive font size
                      fontWeight: FontWeight.w600,
                      fontFamily: Appstring.fontfamily,
                    ),
                  ),

                  SizedBox(height: 14.h),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        color: appcolors.whicolor,
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 15.w,
                        vertical: 10.h,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            MyFlutterApp.user_add,
                            color: appcolors.black,
                            size: 20.w,
                          ),
                          SizedBox(width: 7.w),
                          Text(
                            Appstring.startNow,
                            style: TextStyle(
                               color: appcolors.black,
                              fontSize: 14.sp,
                              fontFamily: Appstring.fontfamily,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(
                        context,
                       Routes.layout
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: appcolors.transcolor,
                        borderRadius: BorderRadius.circular(30.r),
                        border: Border.all(color: appcolors.whicolor, width: 1),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 15.w,
                        vertical: 10.h,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            MyFlutterApp.user_tag,
                            color: appcolors.whicolor,
                            size: 20.w,
                          ),
                          SizedBox(width: 7.w),
                          Text(
                            Appstring.loginAsGuest,
                            style: TextStyle(
                              color: appcolors.whicolor,
                              fontSize: 14.sp,
                              fontFamily: Appstring.fontfamily,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 70.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
