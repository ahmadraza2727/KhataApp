import 'package:app_1/constants/predefined.dart';
import 'package:flutter/material.dart';
import 'package:iconic/iconic.dart';

class CounterProvider with ChangeNotifier {
  late screenNames currentScreenName;
  CounterProvider() {
    currentScreenName = screenNames.HOME;
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

  // bool? toggle_currentPageHome() {
  //   bool? ret = icons_boolList["HOME"];
  //   icons_boolList["HOME"] = !(icons_boolList["HOME"] ?? false);
  //   notifyListeners(); // Notify all listeners about the change
  //   return ret;
  // }
  //
  // bool? toggle_currentPageTransactions() {
  //   bool? ret = icons_boolList["TRANSACTIONS"];
  //   icons_boolList["TRANSACTIONS"] = !(icons_boolList["TRANSACTIONS"] ?? false);
  //   notifyListeners(); // Notify all listeners about the change
  //   return ret;
  // }
  //
  // bool? toggle_currentPageCalender() {
  //   bool? ret = icons_boolList["CALENDER"];
  //   icons_boolList["CALENDER"] = !(icons_boolList["CALENDER"] ?? false);
  //   notifyListeners(); // Notify all listeners about the change
  //   return ret;
  // }
  //
  // bool? toggle_currentPagePeople() {
  //   bool? ret = icons_boolList["PEOPLE"];
  //   icons_boolList["PEOPLE"] = !(icons_boolList["PEOPLE"] ?? false);
  //   notifyListeners(); // Notify all listeners about the change
  //   return ret;
  // }
  //
  // bool? toggle_currentPageInform() {
  //   bool? ret = icons_boolList["INFORM"];
  //   icons_boolList["INFORM"] = !(icons_boolList["INFORM"] ?? false);
  //   notifyListeners(); // Notify all listeners about the change
  //   return ret;
  // }

  int? getCurrentPage() {
    // for (int i = 0; i < icons_List.length; i++) {
    //   if (icons_boolList[icons_Names[i]] == true) return i;
    // }
    return currentScreenName.index;
  }

  void setCurrentPage(int name) {
    currentScreenName = screenNames.values[name];
    notifyListeners();
  }
}
