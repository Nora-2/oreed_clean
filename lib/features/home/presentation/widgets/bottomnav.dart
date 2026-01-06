import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/core/utils/appicons/app_icons.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  late NotchBottomBarController _controller;

  @override
  void initState() {
    super.initState();

    _controller = NotchBottomBarController(index: 2);
  }

  @override
  Widget build(BuildContext context) {
    

        return Padding(
          padding: const EdgeInsets.only(bottom: 0.0),
          child: AnimatedNotchBottomBar(
            
            notchBottomBarController: _controller,
            color: Colors.grey.shade300,
            showLabel: true,
            shadowElevation: 5,
            kBottomRadius: 30.0,
            topMargin: 10,
            notchColor: AppColors.primary,
            onTap: (index) {
             
            },
            kIconSize: 24.0,
            bottomBarItems: [
              BottomBarItem(
                inActiveItem: SvgPicture.asset(AppIcons.profile,
                    color: Colors.black),
                activeItem: SvgPicture.asset(AppIcons.profile,
                    color: Colors.white),
              ),
              BottomBarItem(
                inActiveItem: SvgPicture.asset(AppIcons.ads,
                    color: Colors.black),
                activeItem: SvgPicture.asset(AppIcons.ads,
                    color: Colors.white),
              ),
              BottomBarItem(
                inActiveItem: SvgPicture.asset(AppIcons.home,
                    color: Colors.black),
                activeItem: SvgPicture.asset(AppIcons.home,
                    color: Colors.white),
              ),
            ],
          ),
        );
      
    
  }
}
