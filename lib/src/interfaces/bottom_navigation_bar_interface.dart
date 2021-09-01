import 'package:flutter/material.dart';

class SmartPageBottomNavigationOptions {
  double height = 50.0;
  bool showIndicator = true;
  Color? indicatorColor;
  Color? backgroundColor;
  bool showBorder = true;
  Color? borderColor;
  Color selectedColor;
  Color unselectedColor;
  SmartPageBottomNavigationOptions({
    required this.height,
    required this.showIndicator,
    required this.showBorder,
    required this.selectedColor,
    required this.unselectedColor,
    this.indicatorColor,
    this.borderColor,
    this.backgroundColor,
  });
}
