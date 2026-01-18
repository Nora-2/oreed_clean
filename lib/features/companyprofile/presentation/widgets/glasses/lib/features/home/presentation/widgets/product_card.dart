import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glasses/core/utils/appcolors/app_colors.dart';
import 'package:glasses/core/utils/appstring/app_string.dart';
import 'package:glasses/features/home/presentation/widgets/Imagecontainer.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: appcolors.whicolor,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Imagecontainer(),
          SizedBox(height: 6.h),
          Container(
            decoration: BoxDecoration(
              color: appcolors.producthiligt,
              borderRadius: BorderRadius.circular(16.r),
            ),
            padding: EdgeInsets.all(6),
            width: 40.w,
            child: Text(
              Appstring.category1,
              style: TextStyle(
                color: appcolors.producttext,
                fontSize: 11.sp,
                fontWeight: FontWeight.w400,
                fontFamily: Appstring.fontfamily,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Text(
            Appstring.cardtitel,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
              fontFamily: Appstring.fontfamily,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
          Appstring.carddesc,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontSize: 10.sp,
              color: appcolors.graylinethrough,
              fontFamily: Appstring.fontfamily,
            ),
          ),
          Spacer(),
          Row(
            textDirection: TextDirection.rtl,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    textDirection: TextDirection.rtl,
               '500 ع.د',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: appcolors.buttoncoloronboarding,
                      fontFamily:Appstring.fontfamily,
                      fontSize: 14.sp,
                    ),
                  ),
                  Text(
                    '500 ع.د',
                      textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: Appstring.fontfamily,
                      decoration: TextDecoration.lineThrough,
                      fontSize: 12.sp,
                      color: appcolors.graylinethrough
                    ),
                  ),
                ],
              ),
              CircleAvatar(
                backgroundColor: appcolors.buttoncoloronboarding,
                radius: 20.r,
                child: IconButton(
                  onPressed: () {},
                  icon:  Icon(
                    Icons.shopping_cart_outlined,
                    color: appcolors.primarycolor
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
