
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glasses/core/utils/appcolors/app_colors.dart';
import 'package:glasses/core/utils/appimage/app_images.dart';
import 'package:glasses/core/utils/appstring/app_string.dart';
import 'package:glasses/core/utils/widgets/my_flutter_app_icons.dart';
class Imagecontainer extends StatelessWidget {
  const Imagecontainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: appcolors.carshilight,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            textDirection: TextDirection.rtl,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: appcolors.card,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12.r),
                    bottomLeft: Radius.circular(14.r),
                  ),
                ),
                child: Text(Appstring.newone),
              ),
              Padding(
                padding: EdgeInsets.all(2.r),
                child: Icon(MyFlutterApp.heart, color: appcolors.black, size: 24),
              ),
            ],
          ),
          Image.asset(Appimage.cardglass, width: 120.w),
          Row(
            textDirection: TextDirection.rtl,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('4.8', style: TextStyle(fontWeight: FontWeight.w500)),
              Icon(Icons.star, color: appcolors.black, size: 14),
              SizedBox(width: 2.w),
            ],
          ),
        ],
      ),
    );
  }
}
