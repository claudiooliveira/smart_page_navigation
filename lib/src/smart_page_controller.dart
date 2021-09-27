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
  Duration duration = Duration(milliseconds: 300);
  int _currentPageIndex = 0;
  bool _hideBottomNavigationBar = false;
  late BuildContext context;

  int? initialPage = 0;
  bool? keepPage = true;
  List<Function> _onBackPageListeners = [];
  List<Function(StatefulWidget page, int newPageIndex)> _onInsertPageListeners =
      [];
  List<Function(int page)> _onPageChangedListeners = [];
  List<Function(int index)> _onBottomNavigationBarChanged = [];
  List<Function(int index)> _onBottomOptionSelected = [];
  List<Function> _onResetNavigation = [];
  List<Function> _onListener = [];

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

  addOnBottomOptionSelected(Function(int index) listener) {
    this._onBottomOptionSelected.add(listener);
  }

  addOnInsertPageListener(
      Function(StatefulWidget page, int newPageIndex) listener) {
    this._onInsertPageListeners.add(listener);
  }

  addOnPageChangedListener(Function(int index) listener) {
    this._onPageChangedListeners.add(listener);
  }

  addOnResetNavigation(Function listener) {
    this._onResetNavigation.add(listener);
  }

  addListener(Function listener) {
    this._onListener.add(listener);
  }

  Future? insertPage(
    StatefulWidget newPage, {
    bool? goToNewPage = true,
    bool? ignoreTabHistory = false,
    bool? animated = true,
    bool? hideBottomNavigationBar,
  }) async {
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
      print("AQUI pageHistoryTabSelected $pageHistoryTabSelected");
    }
    this
        ._onInsertPageListeners
        .forEach((func) => func(newPage, _currentPageIndex + 1));
    if (goToNewPage) {
      return await goToPage(_currentPageIndex + 1,
          animated: animated, dontUpdateHistoryTabSelected: true);
    } else {
      this
          ._onBottomNavigationBarChanged
          .forEach((func) => func(this.currentBottomIndex));
      this._onListener.forEach((func) => func());
    }
  }

  goToPage(
    int index, {
    bool? animated = true,
    bool? dontUpdateHistoryTabSelected,
    bool? hideBottomNavigationBar,
  }) async {
    if (dontUpdateHistoryTabSelected == false ||
        dontUpdateHistoryTabSelected == null) {
      pageHistoryTabSelected.add(index);
      print('ADICIONADA $pageHistoryTabSelected');
    }
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
    print("PAGES $pages");
    print("pageHistoryTabSelected $pageHistoryTabSelected");
    if (animated == true) {
      var nextPage = pages[index];
      print(
          'nextPage! $nextPage myIndex: $index _currentPageIndex+1:${_currentPageIndex + 1} _currentPageIndex: $_currentPageIndex');
      pages.insert(_currentPageIndex + 1, nextPage);
      this._onListener.forEach((func) => func());
      await _animateToPage(_currentPageIndex + 1);
      _pageViewController!.jumpToPage(index);
      pages.removeAt(_currentPageIndex + 1);
    } else {
      _pageViewController!.jumpToPage(index);
    }
    _currentPageIndex = index;
    //_pageViewController!.jumpToPage(index);
    this
        ._onBottomNavigationBarChanged
        .forEach((func) => func(this.currentBottomIndex));
    this._onPageChangedListeners.forEach((func) => func(index));
    this._onListener.forEach((func) => func());
  }

  Future<void> _animateToPage(int index, {Curve? curve}) {
    return _pageViewController!.animateToPage(
      index,
      duration: duration,
      //curve: Curves.fastOutSlowIn,
      curve: curve == null ? Curves.fastOutSlowIn : curve,
    );
  }

  selectBottomTab(int index) {
    this._onBottomNavigationBarChanged.forEach((func) => func(index));
    this._onBottomOptionSelected.forEach((func) => func(index));
    this._onListener.forEach((func) => func());
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
    this._onResetNavigation.forEach((func) => func());
    this._onListener.forEach((func) => func());
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
    // if (pages.length > initialPages.length && lastPage > 0) {
    //   if (pages.length > lastPage) {
    //     pages.removeAt(_currentPageIndex);
    //     _currentPageIndex--;
    //   }
    // }

    var pageOnBack =
        pageHistory.length >= 2 ? pageHistory[pageHistory.length - 2] : 0;
    print("pageOnBack>>> $pageOnBack $pages");
    _pageViewController!.animateToPage(
      pageOnBack,
      duration: Duration(milliseconds: 250),
      curve: Curves.easeInToLinear,
    );
    if (pages.length > initialPages.length && lastPage > 0) {
      print("remove?");
      await Future.delayed(Duration(milliseconds: 250), () {
        pages.removeAt(_currentPageIndex);
      });
      _currentPageIndex--;
    }

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

      // _pageViewController!.jumpToPage(
      //   lastPage,
      // );

      print("PAGES BACK $pages $pageHistoryTabSelected");

      this._onBackPageListeners.forEach((func) => func());
      this._onListener.forEach((func) => func());

      return false;
    }
    return true;
  }
}
