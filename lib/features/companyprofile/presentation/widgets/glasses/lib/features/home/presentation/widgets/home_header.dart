import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glasses/core/utils/appcolors/app_colors.dart';
import 'package:glasses/core/utils/appstring/app_string.dart';
import 'package:glasses/core/utils/widgets/my_flutter_app_icons.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
       
      
        decoration: BoxDecoration(
         
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(25.r),
            bottomLeft: Radius.circular(25.r),
          ),
        ),
        child: Row(
          textDirection: TextDirection.rtl,
          crossAxisAlignment: CrossAxisAlignment.center, // 👈 Top alignment
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              radius: 22.r,
              backgroundColor: Color(0xffCCCCCC),
              child: Icon(
                MyFlutterApp.profile_circle,
                color: Colors.white,
                size: 24,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  textDirection: TextDirection.rtl,
                  children: [
                    Text(
                      Appstring.homeheader,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: appcolors.black,

                        fontFamily: Appstring.fontfamily,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Center(
                      child: Icon(
                        MyFlutterApp.hand_469603_1__1_,
                        color: appcolors.black,
                        size: 24,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  Appstring.homeheaderdesc,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.grey[500],

                    fontFamily: 'Montserratregular',
                  ),
                ),
              ],
            ),

            Row(
              textDirection: TextDirection.rtl,
              children: [
                CircleAvatar(
                  radius: 20.r,
                  backgroundColor: appcolors.whicolor,
                  child: Icon(
                    MyFlutterApp.heart,
                    color: Colors.black,
                    size: 24,
                  ),
                ),
                SizedBox(width: 10.w),
                CircleAvatar(
                  radius: 20.r,
                  backgroundColor: appcolors.whicolor,
                  child: Icon(
                    MyFlutterApp.notification,
                    color: Colors.black,
                    size: 24,
                  ),
                ),
              ],
            ),
          ],
        ),
      
    );
  }
}
