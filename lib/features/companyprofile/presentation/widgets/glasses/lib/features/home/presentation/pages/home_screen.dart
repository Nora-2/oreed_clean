import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glasses/core/utils/appcolors/app_colors.dart';
import 'package:glasses/core/utils/appstring/app_string.dart';
import 'package:glasses/features/home/presentation/widgets/CategoryList.dart';
import 'package:glasses/features/home/presentation/widgets/OfferSlider.dart';
import 'package:glasses/features/home/presentation/widgets/SearchBarWidget.dart';
import 'package:glasses/features/home/presentation/widgets/SectionHeader.dart';
import 'package:glasses/features/home/presentation/widgets/home_header.dart';
import 'package:glasses/features/home/presentation/widgets/product_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(elevation: 0, backgroundColor: appcolors.transcolor),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              appcolors.gradient1, // light green
              appcolors.gradient2,
              appcolors.whicolor,
              appcolors.whicolor,
              appcolors.whicolor,
              appcolors.whicolor,
              appcolors.whicolor,
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(25.r),
            bottomLeft: Radius.circular(25.r),
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const HomeHeader(), // space for search bar overlay
                SizedBox(height: 20.h),
                const SearchBarWidget(),
                SizedBox(height: 8.h),
                SectionHeader(
                  title: Appstring.sectionheaderoffer,
                  onTap: () {},
                ),
                SizedBox(height: 8.h),
                const OfferSlider(),
                SizedBox(height: 20.h),
                Text(
                  Appstring.sectionheadercategory,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: Appstring.fontfamily,
                  ),
                ),
                SizedBox(height: 8.h),
                const CategoryList(),
                SizedBox(height: 20.h),
                SectionHeader(
                  title: Appstring.sectionheadertopsales,
                  onTap: () {},
                ),
                SizedBox(height: 10.h),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 4,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.w,
                    mainAxisSpacing: 10.h,
                    childAspectRatio: 0.66,
                  ),
                  itemBuilder: (context, index) => const ProductCard(),
                ),
                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
