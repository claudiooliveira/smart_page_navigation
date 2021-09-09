import 'package:flutter/material.dart';

class SmartPageBottomNavigationOptions {
  double? height = 50.0;
  bool? showIndicator = true;
  Color? indicatorColor = Colors.blueAccent;
  Color? backgroundColor = Colors.white;
  bool? showBorder = true;
  Color? borderColor = Color(0xff707070).withOpacity(0.20);
  Color? selectedColor = Colors.blueAccent;
  Color? unselectedColor = Colors.grey;
  Duration? slideDownDuration;
  SmartPageBottomNavigationOptions({
    this.height,
    this.showIndicator,
    this.showBorder,
    this.selectedColor,
    this.unselectedColor,
    this.indicatorColor,
    this.borderColor,
    this.backgroundColor,
    this.slideDownDuration,
  });
}
