import 'package:flutter/material.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';
import 'package:smart_page_navigation/src/interfaces/bottom_navigation_bar_interface.dart';

class SmartPageBottomNavigationBar extends StatefulWidget {
  SmartPageController controller;
  SmartPageBottomNavigationOptions? options;
  List<BottomIcon> children;
  Function(int index)? onTap;
  SmartPageBottomNavigationBar({
    Key? key,
    required this.controller,
    required this.children,
    this.options,
    this.onTap,
  }) : super(key: key);

  @override
  _SmartPageBottomNavigationBarState createState() =>
      _SmartPageBottomNavigationBarState();
}

class _SmartPageBottomNavigationBarState
    extends State<SmartPageBottomNavigationBar> {
  late SmartPageBottomNavigationOptions options;

  @override
  void initState() {
    super.initState();
    options = widget.options ??
        SmartPageBottomNavigationOptions(
          height: 50,
          showBorder: true,
          showIndicator: true,
          backgroundColor: Colors.white,
          borderColor: Color(0xff707070).withOpacity(0.20),
          indicatorColor: Colors.blueAccent,
          selectedColor: Colors.blueAccent,
          unselectedColor: Colors.grey,
        );

    if (options.showBorder == null) options.showBorder = true;
    if (options.selectedColor == null)
      options.selectedColor = Colors.blueAccent;
    if (options.unselectedColor == null) options.unselectedColor = Colors.grey;

    widget.controller.addOnBackPageListener(() => setState(() {}));
    widget.controller.addOnInsertPageListener((page) => setState(() {}));
    widget.controller.addOnPageChangedListener((index) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final borderWidth = (constraints.maxWidth / widget.children.length);
      return Container(
        height: options.height,
        decoration: BoxDecoration(
          color: options.backgroundColor,
          border: options.showBorder!
              ? Border(
                  top: BorderSide(
                    color: options.borderColor!,
                    width: 1,
                  ),
                )
              : null,
        ),
        child: Stack(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: widget.children.map((bottomIcon) {
                  var currentIndex = widget.children.indexOf(bottomIcon);
                  bool isSelected =
                      widget.controller.currentBottomIndex == currentIndex;
                  Color color = isSelected
                      ? options.selectedColor!
                      : options.unselectedColor!;
                  return InkWell(
                    onTap: () {
                      StatefulWidget pageToRedirect =
                          widget.controller.initialPages[currentIndex];
                      if (widget.controller.pages.length >
                          widget.controller.initialPages.length) {
                        widget.controller
                            .insertPage(pageToRedirect, ignoreTabHistory: true);
                        widget.controller.selectBottomTab(currentIndex);
                      } else {
                        widget.controller.goToPage(currentIndex);
                      }
                      if (widget.onTap != null) {
                        widget.onTap!(currentIndex);
                      }
                      setState(() {});
                    },
                    child: Container(
                      width: borderWidth,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: bottomIcon.icon != null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Icon(
                                  bottomIcon.icon,
                                  color: color,
                                ),
                                Visibility(
                                  visible: bottomIcon.title != null,
                                  child: Container(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 2),
                                    child: Text(
                                      bottomIcon.title == null
                                          ? ""
                                          : bottomIcon.title!,
                                      textAlign: TextAlign.center,
                                      style: bottomIcon.textStyle != null
                                          ? bottomIcon.textStyle!
                                              .copyWith(color: color)
                                          : TextStyle(
                                              color: color,
                                              fontSize: 12,
                                              fontWeight: isSelected
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                            ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          : isSelected
                              ? bottomIcon.selectedWidget
                              : bottomIcon.unselectedWidget,
                    ),
                  );
                }).toList(),
              ),
            ),
            AnimatedPositioned(
              top: 0,
              left: borderWidth * widget.controller.currentBottomIndex,
              child: Container(
                width: borderWidth,
                height: 2,
                decoration: BoxDecoration(
                  color: options.indicatorColor,
                ),
              ),
              duration: Duration(milliseconds: 300),
            ),
          ],
        ),
      );
    });
  }
}

class BottomIcon {
  Widget? selectedWidget;
  Widget? unselectedWidget;
  IconData? icon;
  String? title;
  TextStyle? textStyle;
  BottomIcon({
    this.selectedWidget,
    this.unselectedWidget,
    this.icon,
    this.title,
  });
}

class _SelectedBottomIcon extends StatelessWidget {
  final Widget child;
  const _SelectedBottomIcon({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: child,
    );
  }
}
