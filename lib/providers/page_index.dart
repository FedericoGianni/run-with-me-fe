import 'package:flutter/cupertino.dart';

class PageIndex extends ChangeNotifier {
  int index = 0;

  void setPage(int ind) {
    index = ind;
    notifyListeners();
  }
}
