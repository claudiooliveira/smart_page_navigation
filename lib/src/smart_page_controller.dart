import 'package:flutter/material.dart';

class SmartPageController extends InheritedWidget {
  PageController? _pageViewController;
  List<StatefulWidget> pages = [];
  List<StatefulWidget> initialPages = [];
  List<int> pageHistory = [0];
  List<int> pageHistoryTabSelected = [0];
  int currentBottomIndex = 0;

  int? initialPage = 0;
  bool? keepPage = true;
  List<Function> _onBackPageListeners = [];
  List<Function(StatefulWidget page)> _onInsertPageListeners = [];
  List<Function(int page)> _onPageChangedListeners = [];

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
    this._onBackPageListeners.add(listener);
  }

  addOnInsertPageListener(Function(StatefulWidget page) listener) {
    this._onInsertPageListeners.add(listener);
  }

  addOnPageChangedListener(Function(int index) listener) {
    this._onPageChangedListeners.add(listener);
  }

  insertPage(StatefulWidget newPage,
      {bool? goToNewPage = true, bool? ignoreTabHistory = false}) {
    if (goToNewPage == null) {
      goToNewPage = true;
    }
    this.pages.add(newPage);
    if (ignoreTabHistory == null || ignoreTabHistory == false) {
      pageHistoryTabSelected
          .add(pageHistoryTabSelected[pageHistoryTabSelected.length - 1]);
    }
    this._onInsertPageListeners.forEach((func) => func(newPage));
    if (goToNewPage) {
      goToPage(this.pages.length - 1, true);
    }
  }

  goToPage(int index, [bool? dontUpdateHistoryTabSelected]) {
    if (dontUpdateHistoryTabSelected == false ||
        dontUpdateHistoryTabSelected == null) {
      pageHistoryTabSelected.add(index);
    }
    if (index < initialPages.length) {
      this.currentBottomIndex = index;
    }
    pageHistory.add(index);
    _pageViewController!.jumpToPage(index);
    this._onPageChangedListeners.forEach((func) => func(index));
  }

  selectBottomTab(int index) {
    this.currentBottomIndex = index;
    this.pageHistoryTabSelected.add(index);
  }

  getPageViewController() {
    return this._pageViewController;
  }

  resetNavigation({bool? resetListeners = true}) {
    pages.clear();
    pages.addAll(this.initialPages);
    pageHistory = [0];
    pageHistoryTabSelected = [0];
    currentBottomIndex = 0;
    if (resetListeners == null || resetListeners == true) {
      _onBackPageListeners = [];
      _onInsertPageListeners = [];
      _onPageChangedListeners = [];
    }
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

      if (pageHistoryTabSelected.length >= 1) {
        currentBottomIndex =
            pageHistoryTabSelected[pageHistoryTabSelected.length - 1];
      }

      _pageViewController!.jumpToPage(
        lastPage,
      );

      this._onBackPageListeners.forEach((func) => func());

      return false;
    }
    return true;
  }

  @override
  bool updateShouldNotify(SmartPageController oldWidget) => false;
}
