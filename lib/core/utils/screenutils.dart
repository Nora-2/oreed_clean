// screen_utils.dart
import 'package:flutter/material.dart';

class ScreenUtils {
  static late double _screenWidth;
  static late double _screenHeight;
  static late double _statusBarHeight;
  static late double _bottomBarHeight;
  static late Orientation _orientation;

  static void init(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    _screenWidth = mediaQuery.size.width;
    _screenHeight = mediaQuery.size.height;
    _statusBarHeight = mediaQuery.padding.top;
    _bottomBarHeight = mediaQuery.padding.bottom;
    _orientation = mediaQuery.orientation;
  }

  static double get screenWidth => _screenWidth;
  static double get screenHeight => _screenHeight;
  static double get statusBarHeight => _statusBarHeight;
  static double get bottomBarHeight => _bottomBarHeight;
  static bool get isPortrait => _orientation == Orientation.portrait;

  // Responsive sizing based on design width (375px as base)
  static double setWidth(double width) => _screenWidth / 375 * width;
  static double setHeight(double height) => _screenHeight / 812 * height;
  static double setFontSize(double fontSize) => _screenWidth / 375 * fontSize;
  
  static double get padding => setWidth(16);
  static double get smallPadding => setWidth(8);
  static double get largePadding => setWidth(24);
}