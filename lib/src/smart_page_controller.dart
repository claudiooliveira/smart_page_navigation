import 'dart:async';

import 'package:flutter/material.dart';

class SmartPageController {
  static late SmartPageController _instance;
  PageController? _pageViewController;
  List<StatefulWidget> pages = [];
  List<StatefulWidget> initialPages = [];
  List<int> pageHistory = [0];
  List<int> pageHistoryTabSelected = [0];
  int currentBottomIndex = 0;
  Duration duration = Duration(milliseconds: 500);
  int _currentPageIndex = 0;
  bool _hideBottomNavigationBar = false;
  late BuildContext context;

  int? initialPage = 0;
  bool? keepPage = true;
  List<Function> _onBackPageListeners = [];
  List<Function(StatefulWidget page)> _onInsertPageListeners = [];
  List<Function(int page)> _onPageChangedListeners = [];
  List<Function(int index)> _onBottomNavigationBarChanged = [];
  List<Function(int index, BuildContext context)> _onBottomOptionSelected = [];
  List<Function> _onResetNavigation = [];

  SmartPageController({
    required this.initialPages,
    required this.context,
    int? initialPage,
    bool? keepPage,
  }) {
    this.initialPage = initialPage == null ? 0 : initialPage;
    this.keepPage = keepPage == null ? true : keepPage;
    this._pageViewController = PageController(
      initialPage: this.initialPage!,
      keepPage: this.keepPage!,
    );
    this._currentPageIndex = this.initialPage!;
    this.pages.addAll(this.initialPages);
  }

  static SmartPageController newInstance({
    required List<StatefulWidget> initialPages,
    required BuildContext context,
    int? initialPage,
    bool? keepPage,
  }) {
    _instance = new SmartPageController(
      initialPages: initialPages,
      context: context,
      initialPage: initialPage,
      keepPage: keepPage,
    );
    return _instance;
  }

  static SmartPageController getInstance() {
    return _instance;
  }

  addOnBackPageListener(Function listener) {
    this._onBackPageListeners.add(listener);
  }

  addOnBottomNavigationBarChanged(Function(int index) listener) {
    this._onBottomNavigationBarChanged.add(listener);
  }

  addOnBottomOptionSelected(
      Function(int index, BuildContext context) listener) {
    if (this._onBottomOptionSelected.length == 0) {
      this._onBottomOptionSelected = [listener];
    }
  }

  addOnInsertPageListener(Function(StatefulWidget page) listener) {
    this._onInsertPageListeners.add(listener);
  }

  addOnPageChangedListener(Function(int index) listener) {
    this._onPageChangedListeners.add(listener);
  }

  addOnResetNavigation(Function listener) {
    this._onResetNavigation.add(listener);
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
    if (goToNewPage) {
      goToPage(_currentPageIndex + 1,
          animated: ignoreTabHistory == false,
          dontUpdateHistoryTabSelected: true);
    } else {
      this
          ._onBottomNavigationBarChanged
          .forEach((func) => func(this.currentBottomIndex));
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
    // if (animated == true) {
    //   _animateToPage(index);
    // } else {
    //   _pageViewController!.jumpToPage(index);
    // }
    _pageViewController!.jumpToPage(index);
    this
        ._onBottomNavigationBarChanged
        .forEach((func) => func(this.currentBottomIndex));
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
    this._onBottomNavigationBarChanged.forEach((func) => func(index));
    this._onBottomOptionSelected.forEach((func) => func(index, context));
  }

  PageController? getPageViewController() {
    return this._pageViewController;
  }

  resetNavigation({bool? resetListeners = false}) {
    pages.clear();
    pages.addAll(this.initialPages);
    pageHistory = [0];
    pageHistoryTabSelected = [0];
    currentBottomIndex = 0;
    _currentPageIndex = 0;
    if (resetListeners == true) {
      _onBackPageListeners = [];
      _onInsertPageListeners = [];
      _onPageChangedListeners = [];
      //_onBottomOptionSelected = []; //this listener could not be empty
      _onBottomNavigationBarChanged = [];
      _onResetNavigation = [];
    }
    this._onResetNavigation.forEach((func) => func());
  }

  resetPageController() {
    this._pageViewController = PageController(
      initialPage: this.initialPage!,
      keepPage: this.keepPage!,
    );
  }

  showBottomNavigationBar() {
    this._hideBottomNavigationBar = false;
    this
        ._onBottomNavigationBarChanged
        .forEach((func) => func(this.currentBottomIndex));
  }

  hideBottomNavigationBar() {
    this._hideBottomNavigationBar = true;
    this
        ._onBottomNavigationBarChanged
        .forEach((func) => func(this.currentBottomIndex));
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
        if (pageHistoryTabSelected.length > 0) {
          pageHistoryTabSelected.removeAt(pageHistoryTabSelected.length - 1);
        }
      }

      if (pageHistoryTabSelected.length >= 1) {
        currentBottomIndex =
            pageHistoryTabSelected[pageHistoryTabSelected.length - 1];
      }

      if (pageHistoryTabSelected.length == 0) {
        currentBottomIndex = 0;
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
