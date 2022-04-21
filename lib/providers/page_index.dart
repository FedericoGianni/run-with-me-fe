///{@category Providers}
/// A provider responsible for handling the current page of the app.
import 'package:flutter/cupertino.dart';

///All app screens enumerated by name.
enum Screens {
  HOME,
  SEARCH,
  NEW,
  EVENTS,
  USER,
}

///Object representing the page index.
class PageIndex extends ChangeNotifier {
  int index = 0;

  ///Sets the current active page by its index [ind]
  void setPage(int ind) {
    index = ind;
    notifyListeners();
  }
}
