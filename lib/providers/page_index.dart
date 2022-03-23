import 'package:flutter/cupertino.dart';

enum Screens {
  HOME,
  SEARCH,
  NEW,
  EVENTS,
  USER,
}

class PageIndex extends ChangeNotifier {
  int index = 0;

  void setPage(int ind) {
    index = ind;
    notifyListeners();
  }
}
