import 'dart:async';

import 'package:flutter/material.dart';

class SmartPageController extends InheritedWidget {
  PageController? _pageViewController;
  List<StatefulWidget> pages = [];
  List<StatefulWidget> initialPages = [];
  List<int> pageHistory = [0];
  List<int> pageHistoryTabSelected = [0];
  int currentBottomIndex = 0;
  Duration duration = Duration(milliseconds: 500);
  int _currentPageIndex = 0;
  bool _hideBottomNavigationBar = false;

  int? initialPage = 0;
  bool? keepPage = true;
  List<Function> _onBackPageListeners = [];
  List<Function(StatefulWidget page)> _onInsertPageListeners = [];
  List<Function(int page)> _onPageChangedListeners = [];
  List<Function> _onBottomNavigationBarChanged = [];
  List<Function(int index)> _onBottomOptionSelected = [];

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
      this._currentPageIndex = this.initialPage!;
      this.pages.addAll(this.initialPages);
    }
    return this;
  }

  static SmartPageController of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<SmartPageController>()!;

  addOnBackPageListener(Function listener) {
    this._onBackPageListeners.add(listener);
  }

  addOnBottomNavigationBarChanged(Function listener) {
    this._onBottomNavigationBarChanged.add(listener);
  }

  addOnBottomOptionSelected(Function(int index) listener) {
    this._onBottomOptionSelected.add(listener);
  }

  addOnInsertPageListener(Function(StatefulWidget page) listener) {
    this._onInsertPageListeners.add(listener);
  }

  addOnPageChangedListener(Function(int index) listener) {
    this._onPageChangedListeners.add(listener);
  }

  insertPage(
    StatefulWidget newPage, {
    bool? goToNewPage = true,
    bool? ignoreTabHistory = false,
    bool? hideBottomNavigationBar,
  }) {
    if (goToNewPage == null) {
      goToNewPage = true;
    }
    //this.pages.add(newPage);
    this.pages.insert(_currentPageIndex + 1, newPage);

    if (hideBottomNavigationBar != null) {
      if (hideBottomNavigationBar == true) {
        this._hideBottomNavigationBar = true;
      } else {
        this._hideBottomNavigationBar = false;
      }
    }

    //this.pages.insert(_currentPageIndex + 1, newPage);
    if (ignoreTabHistory == null || ignoreTabHistory == false) {
      pageHistoryTabSelected.add(pageHistoryTabSelected.length > 0
          ? pageHistoryTabSelected[pageHistoryTabSelected.length - 1]
          : 0);
    }
    this._onInsertPageListeners.forEach((func) => func(newPage));
    this._onBottomNavigationBarChanged.forEach((func) => func());
    if (goToNewPage) {
      goToPage(_currentPageIndex + 1,
          animated: ignoreTabHistory == false,
          dontUpdateHistoryTabSelected: true);
    }
  }

  goToPage(
    int index, {
    bool? animated = true,
    bool? dontUpdateHistoryTabSelected,
    bool? hideBottomNavigationBar,
  }) {
    if (dontUpdateHistoryTabSelected == false ||
        dontUpdateHistoryTabSelected == null) {
      pageHistoryTabSelected.add(index);
    }
    _currentPageIndex = index;
    if (index < initialPages.length &&
        (dontUpdateHistoryTabSelected == null ||
            dontUpdateHistoryTabSelected == false)) {
      this.currentBottomIndex = index;
    }
    pageHistory.add(index);
    if (hideBottomNavigationBar != null) {
      if (hideBottomNavigationBar == true) {
        this._hideBottomNavigationBar = true;
      } else {
        this._hideBottomNavigationBar = false;
      }
    }
    /*if (animated == true) {
      _animateToPage(index);
    } else {
      _pageViewController!.jumpToPage(index);
    }*/
    _pageViewController!.jumpToPage(index);
    this._onBottomNavigationBarChanged.forEach((func) => func());
    this._onPageChangedListeners.forEach((func) => func(index));
  }

  _animateToPage(int index, {Curve? curve}) {
    _pageViewController!.animateToPage(
      index,
      duration: duration,
      //curve: Curves.fastOutSlowIn,
      curve: curve == null ? Curves.fastOutSlowIn : curve,
    );
  }

  selectBottomTab(int index) {
    this._onBottomOptionSelected.forEach((func) => func(index));
    if (pages.length > initialPages.length) {
      this.currentBottomIndex = index;
      this.pageHistoryTabSelected.add(index);
    }
  }

  PageController? getPageViewController() {
    return this._pageViewController;
  }

  resetNavigation({bool? resetListeners = true}) {
    pages.clear();
    pages.addAll(this.initialPages);
    pageHistory = [0];
    pageHistoryTabSelected = [0];
    currentBottomIndex = 0;
    _currentPageIndex = 0;
    if (resetListeners == null || resetListeners == true) {
      _onBackPageListeners = [];
      _onInsertPageListeners = [];
      _onPageChangedListeners = [];
    }
  }

  resetPageController() {
    this._pageViewController = PageController(
      initialPage: this.initialPage!,
      keepPage: this.keepPage!,
    );
  }

  showBottomNavigationBar() {
    this._hideBottomNavigationBar = false;
    this._onBottomNavigationBarChanged.forEach((func) => func());
  }

  hideBottomNavigationBar() {
    this._hideBottomNavigationBar = true;
    this._onBottomNavigationBarChanged.forEach((func) => func());
  }

  int get currentPageIndex => _currentPageIndex;
  bool get bottomNavigationBarIsHidden => _hideBottomNavigationBar;

  Future<bool> back() async {
    var lastPage =
        pageHistory.length >= 2 ? pageHistory[pageHistory.length - 1] : 0;
    if (pages.length > initialPages.length && lastPage > 0) {
      if (pages.length > lastPage) {
        pages.removeAt(_currentPageIndex);
        _currentPageIndex--;
      }
    }

    /*var pageOnBack =
        pageHistory.length >= 2 ? pageHistory[pageHistory.length - 2] : 0;
    _pageViewController!.animateToPage(
      pageOnBack,
      duration: Duration(milliseconds: 250),
      curve: Curves.easeInToLinear,
    );
    if (pages.length > initialPages.length && lastPage > 0) {
      await Future.delayed(Duration(milliseconds: 250), () {
        pages.removeAt(lastPage);
      });
      _currentPageIndex--;
    }*/

    if (_pageViewController!.page! > 0) {
      if (pageHistory.length >= 2) {
        lastPage = pageHistory[pageHistory.length - 2];
        pageHistory.removeAt(pageHistory.length - 1);
        pageHistoryTabSelected.removeAt(pageHistoryTabSelected.length - 1);
      }

      if (pageHistoryTabSelected.length >= 1) {
        currentBottomIndex =
            pageHistoryTabSelected[pageHistoryTabSelected.length - 1];
      }

      _currentPageIndex = lastPage;

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
