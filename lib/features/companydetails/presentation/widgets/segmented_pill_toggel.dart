import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oreed_clean/core/enmus/enum.dart';
import 'package:oreed_clean/core/utils/appicons/app_icons.dart';

class SegmentedPillToggle extends StatelessWidget {
  final ViewMode value;
  final ValueChanged<ViewMode> onChanged;

  // Dimensions
  final double height;
  final double width;
  final double padding; // Space between border and the toggle

  // Colors
  final Color activeColor; // Blue background
  final Color activeIconColor; // White icon
  final Color inactiveIconColor; // Grey icon
  final Color trackColor; // White background
  final Color borderColor; // Orange border

  final List<String> icons;

  const SegmentedPillToggle({
    super.key,
    required this.value,
    required this.onChanged,
    this.height = 30,
    this.width = 70, // Reduced width since there is no text
    this.padding = 3,
    // Colors based on your image
    this.activeColor = const Color(0xFF1559C9), // The Blue Fill
    this.activeIconColor = Colors.white,
    this.inactiveIconColor = const Color(0xFF757575),
    this.trackColor = Colors.white,
    this.borderColor = const Color(0xFFFFA000), // The Orange Border
    // Icons matching the image (2 bars vs 3 bars)
    this.icons = const [
      AppIcons.two // Looks like the left icon
      ,
     AppIcons.three // Looks like the right icon (3 vertical bars)
    ],
  }) : assert(icons.length == 2, 'icons must have exactly 2 items');

  @override
  Widget build(BuildContext context) {
    // Check direction for animation logic
    final dir = Directionality.of(context);
    final isRtl = dir == TextDirection.rtl;
    final isList = value == ViewMode.list;

    // Determine Alignment based on RTL/LTR
    // If List is selected: Left (LTR) or Right (RTL)
    final Alignment thumbAlign = (isList && isRtl) || (!isList && !isRtl)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      height: height,
      width: width,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: trackColor,
        borderRadius: BorderRadius.circular(height), // Fully rounded capsule
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final innerW = constraints.maxWidth;
          final innerH = constraints.maxHeight;
          final segW = innerW / 2; // Each segment takes half the width

          return Stack(
            children: [
              // 1. The Moving Blue Circle/Pill
              AnimatedAlign(
                duration: const Duration(milliseconds: 250),
                curve: Curves.fastOutSlowIn,
                alignment: thumbAlign,
                child: Container(
                  width: segW,
                  height: innerH,
                  decoration: BoxDecoration(
                    color: activeColor,
                    borderRadius: BorderRadius.circular(height),
                    boxShadow: [
                      BoxShadow(
                        color: activeColor.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),

              // 2. The Icons (Clickable Areas)
              Row(
                textDirection: dir,
                children: [
                  // List Button
                  _IconSegment(
                    width: segW,
                    height: innerH,
                    icon: icons[0],
                    isSelected: isList,
                    activeIconColor: activeIconColor,
                    inactiveIconColor: inactiveIconColor,
                    onTap: () => onChanged(ViewMode.list),
                  ),
                  // Grid Button
                  _IconSegment(
                    width: segW,
                    height: innerH,
                    icon: icons[1],
                    isSelected: !isList,
                    activeIconColor: activeIconColor,
                    inactiveIconColor: inactiveIconColor,
                    onTap: () => onChanged(ViewMode.grid),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _IconSegment extends StatelessWidget {
  final double width;
  final double height;
  final String icon;
  final bool isSelected;
  final Color activeIconColor;
  final Color inactiveIconColor;
  final VoidCallback onTap;

  const _IconSegment({
    required this.width,
    required this.height,
    required this.icon,
    required this.isSelected,
    required this.activeIconColor,
    required this.inactiveIconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: onTap,
          child: Center(
            child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: SvgPicture.asset(
                  icon,
                  height: 15,
                  width: 15,
                  color: isSelected ? activeIconColor : inactiveIconColor,
                )),
          ),
        ),
      ),
    );
  }
}
