import 'package:flutter/material.dart';

class SmartPageController extends InheritedWidget {
  PageController? _pageViewController;
  List<StatefulWidget> pages = [];
  List<StatefulWidget> initialPages = [];
  List<int> pageHistory = [0];
  List<int> pageHistoryTabSelected = [0];
  SmartPageController? _instance;

  int? initialPage = 0;
  bool? keepPage = true;
  Function? _onBackPage;

  SmartPageController({required Widget child, Key? key})
      : super(key: key, child: child);

  SmartPageController init({
    required List<StatefulWidget> initialPages,
    int? initialPage,
    bool? keepPage,
  }) {
    if (_pageViewController == null) {
      this.initialPages = initialPages;
      this.initialPage = initialPage == null ? 0 : initialPage;
      this.keepPage = keepPage == null ? true : keepPage;
      this._pageViewController = PageController(
        initialPage: this.initialPage!,
        keepPage: this.keepPage!,
      );
      this.pages.addAll(this.initialPages);
    }
    return this;
  }

  static SmartPageController of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<SmartPageController>()!;

  addOnBackPageListener(Function listener) {
    this._onBackPage = listener;
  }

  insertPage(StatefulWidget newPage, {bool? goToNewPage = true}) {
    if (goToNewPage == null) {
      goToNewPage = true;
    }
  }

  getPageViewController() {
    return this._pageViewController;
  }

  bool back() {
    if (pages.length > initialPages.length) {
      pages.removeAt(pages.length - 1);
    }

    if (_pageViewController!.page! > 0) {
      var lastPage = pageHistory[pageHistory.length - 1];
      if (pageHistory.length >= 2) {
        lastPage = pageHistory[pageHistory.length - 2];
        pageHistory.removeAt(pageHistory.length - 1);
        pageHistoryTabSelected.removeAt(pageHistoryTabSelected.length - 1);
      }
      _pageViewController!.jumpToPage(
        lastPage,
      );
      if (this._onBackPage != null) {
        this._onBackPage!();
      }

      return false;
    }
    return true;
  }

  @override
  bool updateShouldNotify(SmartPageController oldWidget) => false;
}
