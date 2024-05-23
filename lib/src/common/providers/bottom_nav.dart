import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bottomNavProvider = ChangeNotifierProvider((ref) => BottomNavProvider());

class BottomNavProvider extends ChangeNotifier {
  bool leftMenuOpened = false;
  int currentPageIndex = 0;

  void changeCurrentPage(int index) {
    currentPageIndex = index;
    refresh();
  }
  void refresh() => notifyListeners();
}