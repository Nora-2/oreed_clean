import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glasses/core/utils/appimage/app_images.dart';
import 'package:glasses/core/utils/appstring/app_string.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'name': Appstring.category4, 'icon': Appimage.glass5},
      {'name': Appstring.category2, 'icon': Appimage.glass2},
      {'name': Appstring.category3, 'icon':Appimage.glass3},
      {'name': Appstring.category4, 'icon': Appimage.glass5},
      {'name':Appstring.category2 , 'icon': Appimage.glass2},
      {'name': Appstring.category1, 'icon': Appimage.glass1},
    ];

    return SizedBox(
      height: 85.h,
      child: ListView.separated(
        
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final item = categories[index];
          return Column(
            children: [
              CircleAvatar(
                radius: 35.r,
                backgroundColor: Colors.grey[100],
                child:Image.asset(item['icon']as String,width: 80.w,height: 80.h,),
              ),
              SizedBox(height: 2.h),
              Text(
                item['name'] as String,
                style: TextStyle(fontSize: 13.sp,fontWeight: FontWeight.w500,   
                 
                  fontFamily: Appstring.fontfamily,),
              ),
            ],
          );
        },
      ),
    );
  }
}
