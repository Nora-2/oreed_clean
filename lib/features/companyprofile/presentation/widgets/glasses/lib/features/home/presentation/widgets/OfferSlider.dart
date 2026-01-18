import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glasses/core/utils/appcolors/app_colors.dart';
import 'package:glasses/core/utils/appimage/app_images.dart';
import 'package:glasses/core/utils/appstring/app_string.dart';
import 'package:glasses/core/utils/widgets/my_flutter_app_icons.dart';

class OfferSlider extends StatelessWidget {
  const OfferSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return 
      CarouselSlider(
        options: CarouselOptions(height: 160.h,aspectRatio: 2/3,
      viewportFraction: 0.90,
      initialPage: 0,
      padEnds: false,
      enableInfiniteScroll: true,
      reverse: true,
      autoPlay: true,
      autoPlayInterval: Duration(seconds: 3),
      autoPlayAnimationDuration: Duration(milliseconds: 800),
      autoPlayCurve: Curves.fastOutSlowIn,),
        items: [1, 2, 3, ].map((i) {
          return Builder(
            builder: (BuildContext context) {
              return Padding(
                padding:  EdgeInsets.only(left:6.r),
                child: Container(
                  width: 1.sw,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    image:  DecorationImage(
                      image: AssetImage(Appimage.home),
                      fit: BoxFit.fill,
                    ),
                  ),
                
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                           Appstring.slidertitel,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: appcolors.whicolor,
                          fontSize: 13.sp,
                          fontFamily:  Appstring.fontfamily,
                          fontWeight: FontWeight.w600, // Responsive font size
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        Appstring.sliderdesc,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: appcolors.slider,
                          fontSize: 10.sp, // Responsive font size
                          fontWeight: FontWeight.w400,
                          fontFamily:  Appstring.fontfamily
                        ),
                      ),
                
                      SizedBox(height: 14.h),
                      Padding(
                        padding:  EdgeInsets.only(left: 80.r,right: 5.r),
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            decoration: BoxDecoration(
                              color: appcolors.whicolor,
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 15.w,
                              vertical: 5.h,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(MyFlutterApp.arrow_left, color: appcolors.black),
                                SizedBox(width: 7.w),
                                Text(
                                 Appstring.bestoffers,
                                  style: TextStyle(
                                    color: appcolors.black,
                                    fontSize: 14.sp,
                                    fontFamily: Appstring.fontfamily
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }).toList(),
      
    );
  }
}
