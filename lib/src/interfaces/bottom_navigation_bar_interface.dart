import 'package:flutter/material.dart';

class SmartPageBottomNavigationOptions {
  double? height = 50.0;
  bool? showIndicator = true;
  Color? indicatorColor;
  Color? backgroundColor;
  bool? showBorder = true;
  Color? borderColor;
  Color? selectedColor;
  Color? unselectedColor;
  SmartPageBottomNavigationOptions({
    this.height,
    this.showIndicator,
    this.showBorder,
    this.selectedColor,
    this.unselectedColor,
    this.indicatorColor,
    this.borderColor,
    this.backgroundColor,
  });
}
