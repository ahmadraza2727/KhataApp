import 'package:app_1/constants/predefined.dart';
import 'package:flutter/material.dart';

class NavigationProvider with ChangeNotifier {
  late screenNames currentScreenName;
  NavigationProvider() {
    currentScreenName = screenNames.HOME;
    // initialize();
  }

  bool _searchTextFeildOpenStatus = false;
  bool get searchTextFeildOpenStatus => _searchTextFeildOpenStatus;
  bool toggle_searchTextFeildOpenStatus() {
    bool ret = _searchTextFeildOpenStatus;
    _searchTextFeildOpenStatus = !_searchTextFeildOpenStatus;
    notifyListeners(); // Notify all listeners about the change
    return ret;
  }

  void set_searchTextFeildOpenStatus([bool b = false]) {
    _searchTextFeildOpenStatus = b;
    notifyListeners(); // Notify all listeners about the change
  }

  bool _menuOptionsOpenStatus = false;
  bool get menuOptionsOpenStatus => _menuOptionsOpenStatus;
  bool toggle_menuOptionsOpenStatus() {
    bool ret = _menuOptionsOpenStatus;
    _menuOptionsOpenStatus = !_menuOptionsOpenStatus;
    notifyListeners(); // Notify all listeners about the change
    return ret;
  }

  void set_menuOptionsOpenStatus([bool b = false]) {
    _menuOptionsOpenStatus = b;
    notifyListeners(); // Notify all listeners about the change
  }

  int? getCurrentPage() {
    return currentScreenName.index;
  }

  void setCurrentPage(int name) {
    currentScreenName = screenNames.values[name];
    notifyListeners();
  }
}
