import 'package:flutter/material.dart';
import 'package:smart_page_navigation/src/components/keep_alive_page.dart';
import 'package:smart_page_navigation/src/interfaces/widget_options_interface.dart';
import 'package:smart_page_navigation/src/smart_page_controller.dart';

class SmartPageNavigation extends StatefulWidget {
  SmartPageController controller;
  SmartPageNavigationOptions? options;
  Function(int index)? onPageChanged;
  SmartPageNavigation({
    Key? key,
    required this.controller,
    this.options,
    this.onPageChanged,
  }) : super(key: key);

  @override
  _SmartPageNavigationState createState() => _SmartPageNavigationState();
}

class _SmartPageNavigationState extends State<SmartPageNavigation> {
  @override
  void initState() {
    super.initState();
    widget.controller.addOnBackPageListener(() => setState(() {}));
    widget.controller.addOnInsertPageListener((page) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      pageSnapping: false,
      controller: widget.controller.getPageViewController(),
      scrollDirection: widget.options?.axis ?? Axis.horizontal,
      physics: widget.options?.physics ?? NeverScrollableScrollPhysics(),
      onPageChanged: widget.onPageChanged,
      itemCount: widget.controller.pages.length,
      itemBuilder: (context, index) {
        return KeepAlivePage(child: widget.controller.pages[index]);
      },
    );
  }
}
