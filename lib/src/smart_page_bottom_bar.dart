import 'package:flutter/material.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';
import 'package:smart_page_navigation/src/interfaces/bottom_navigation_bar_interface.dart';

class SmartPageBottomNavigationBar extends StatefulWidget {
  SmartPageController controller;
  SmartPageBottomNavigationOptions? options;
  List<BottomIcon> children;
  bool Function(int index)? onTap;
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

  bool bottomNavigationBarIsHidden = false;
  Duration animDuration = Duration(milliseconds: 150);

  @override
  void initState() {
    super.initState();

    defineOptions();

    if (options.showBorder == null) options.showBorder = true;
    if (options.showIndicator == null) options.showIndicator = true;
    if (options.selectedColor == null)
      options.selectedColor = Colors.blueAccent;
    if (options.unselectedColor == null) options.unselectedColor = Colors.grey;
    if (options.backgroundColor == null) options.backgroundColor = Colors.white;
    if (options.borderColor == null)
      options.borderColor = Color(0xff707070).withOpacity(0.20);
    if (options.indicatorColor == null)
      options.indicatorColor = Colors.blueAccent;
    if (options.height == null) options.height = 50;
    if (options.slideDownDuration == null)
      options.slideDownDuration = Duration(milliseconds: 150);

    widgetListeners();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  widgetListeners() {
    widget.controller.addListener(() {
      if (mounted) setState(() {});
    });
    widget.controller.addOnBackPageListener(() {
      BottomIcon bottomIcon =
          widget.children[widget.controller.currentBottomIndex];
      if (bottomIcon.hideBottomNavigationBar == true) {
        widget.controller.hideBottomNavigationBar();
      } else if (widget.controller.bottomNavigationBarIsHidden) {
        widget.controller.showBottomNavigationBar();
      }
      if (mounted) setState(() {});
    });
    widget.controller.addOnBottomNavigationBarChanged((int index) async {
      if (!bottomNavigationBarIsHidden) {
        await Future.delayed(animDuration, () {});
      }
      bottomNavigationBarIsHidden =
          widget.controller.bottomNavigationBarIsHidden;
      if (mounted) setState(() {});
    });
    widget.controller.addOnBottomOptionSelected((currentIndex) async {
      var bottomIcon = widget.children[currentIndex];
      bool enabledToGoPage = true;
      if (widget.onTap != null) {
        enabledToGoPage = widget.onTap!(currentIndex);
      }
      if (enabledToGoPage) {
        StatefulWidget pageToRedirect =
            widget.controller.initialPages[currentIndex];
        // if (widget.controller.pages.length >
        //     widget.controller.initialPages.length) {
        //   await widget.controller.insertPage(
        //     pageToRedirect,
        //     ignoreTabHistory: true,
        //     animated: true,
        //     hideBottomNavigationBar: bottomIcon.hideBottomNavigationBar == true,
        //   );
        // } else {
        //   await widget.controller.goToPage(
        //     currentIndex,
        //     animated: true,
        //     hideBottomNavigationBar: bottomIcon.hideBottomNavigationBar == true,
        //   );
        // }
        await widget.controller.goToPage(
          widget.controller.pages.indexOf(pageToRedirect),
          animated: true,
          hideBottomNavigationBar: bottomIcon.hideBottomNavigationBar == true,
        );
        if (widget.controller.pages.length >
            widget.controller.initialPages.length) {
          widget.controller.currentBottomIndex = currentIndex;
          widget.controller.pageHistoryTabSelected.add(currentIndex);
          print("adding ${widget.controller.pageHistoryTabSelected}");
        }
        if (mounted) setState(() {});
      }
    });
  }

  void defineOptions() {
    options = widget.options != null
        ? widget.options!
        : SmartPageBottomNavigationOptions(
            height: 50,
            showBorder: true,
            showIndicator: true,
            backgroundColor: Colors.white,
            borderColor: Color(0xff707070).withOpacity(0.20),
            indicatorColor: Colors.blueAccent,
            selectedColor: Colors.blueAccent,
            unselectedColor: Colors.grey,
          );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final borderWidth = (constraints.maxWidth / widget.children.length);
      return Visibility(
        visible: !bottomNavigationBarIsHidden,
        child: Container(
          width: constraints.maxWidth,
          height: options.height,
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: Duration(milliseconds: 150),
                width: constraints.maxWidth,
                height: widget.controller.bottomNavigationBarIsHidden
                    ? 0
                    : options.height,
                top: widget.controller.bottomNavigationBarIsHidden
                    ? options.height
                    : 0,
                child: Container(
                  width: constraints.maxWidth,
                  height: options.height,
                  child: Stack(
                    children: [
                      AnimatedPositioned(
                        width: constraints.maxWidth,
                        height: widget.controller.bottomNavigationBarIsHidden
                            ? 0
                            : options.height,
                        top: widget.controller.bottomNavigationBarIsHidden
                            ? options.height
                            : 0,
                        duration: Duration(milliseconds: 150),
                        child: Container(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: widget.children.map((bottomIcon) {
                                    var currentIndex =
                                        widget.children.indexOf(bottomIcon);
                                    bool isSelected =
                                        widget.controller.currentBottomIndex ==
                                            currentIndex;
                                    Color color = isSelected
                                        ? options.selectedColor!
                                        : options.unselectedColor!;
                                    if (bottomIcon.badgeColor == null) {
                                      bottomIcon.badgeColor =
                                          options.indicatorColor!;
                                    }
                                    return InkWell(
                                      onTap: () {
                                        widget.controller
                                            .selectBottomTab(currentIndex);
                                        setState(() {});
                                      },
                                      child: Container(
                                        width: borderWidth,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12),
                                        child: bottomIcon.icon != null
                                            ? LayoutBuilder(
                                                builder: (context,
                                                    stackConstraints) {
                                                  return Stack(
                                                    children: [
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .stretch,
                                                        children: [
                                                          Icon(
                                                            bottomIcon.icon,
                                                            color: color,
                                                          ),
                                                          Visibility(
                                                            visible: bottomIcon
                                                                    .title !=
                                                                null,
                                                            child: Container(
                                                              margin: const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 2),
                                                              child: Text(
                                                                bottomIcon.title ==
                                                                        null
                                                                    ? ""
                                                                    : bottomIcon
                                                                        .title!,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: bottomIcon
                                                                            .textStyle !=
                                                                        null
                                                                    ? bottomIcon
                                                                        .textStyle!
                                                                        .copyWith(
                                                                            color:
                                                                                color)
                                                                    : TextStyle(
                                                                        color:
                                                                            color,
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight: isSelected
                                                                            ? FontWeight.bold
                                                                            : FontWeight.normal,
                                                                      ),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      if (bottomIcon.badge !=
                                                          null)
                                                        Positioned(
                                                          right: (stackConstraints
                                                                      .maxWidth /
                                                                  2) -
                                                              32,
                                                          top: 6,
                                                          child: SizedBox(
                                                            width: 16,
                                                            height: 16,
                                                            child: Container(
                                                              width: 16,
                                                              height: 16,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            100),
                                                                color: bottomIcon
                                                                    .badgeColor,
                                                              ),
                                                              child: Center(
                                                                  child: bottomIcon
                                                                      .badge!),
                                                            ),
                                                          ),
                                                        )
                                                    ],
                                                  );
                                                },
                                              )
                                            : isSelected
                                                ? bottomIcon.selectedWidget
                                                : bottomIcon.unselectedWidget,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                              Visibility(
                                visible: options.showIndicator == true,
                                child: AnimatedPositioned(
                                  top: 0,
                                  left: borderWidth *
                                      widget.controller.currentBottomIndex,
                                  child: Container(
                                    width: borderWidth,
                                    height: 2,
                                    decoration: BoxDecoration(
                                      color: options.indicatorColor,
                                    ),
                                  ),
                                  duration: Duration(milliseconds: 300),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
  Widget? badge;
  Color? badgeColor;
  bool? hideBottomNavigationBar;
  BottomIcon({
    this.selectedWidget,
    this.unselectedWidget,
    this.icon,
    this.title,
    this.badge,
    this.badgeColor,
    this.hideBottomNavigationBar,
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
