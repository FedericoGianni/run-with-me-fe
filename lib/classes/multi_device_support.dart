import 'package:flutter/material.dart';

class MultiDeviceSupport {
  final context;
  double screenHeight = 0.0;
  double screenWidth = 0.0;
  double _title = 0.0;
  double _h1 = 0.0;
  double _h2 = 0.0;
  double _h3 = 0.0;
  double _h4 = 0.0;
  double _h5 = 0.0;
  double _h0 = 0.0;

  double _columnPadding = 0.0;
  double _paddingTop2 = 0.0;
  double _tablet = 0.0;

  MultiDeviceSupport(this.context);

  void init() {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 800) {
      _columnPadding = screenWidth / 7;
      _paddingTop2 = screenHeight / 50;
      _title = 28;
      _h0 = 22;
      _h1 = 18;
      _h2 = 16;
      _h3 = 14;
      _h4 = 12;
    } else {
      _columnPadding = screenWidth / 5;
      _paddingTop2 = screenHeight / 40;
      _tablet = 1;
      _title = 40;
      _h0 = 30;
      _h1 = 28;
      _h2 = 22;
      _h3 = 18;
      _h4 = 16;
    }
  }

  double get tablet {
    return _tablet;
  }

  double get title {
    return _title;
  }

  double get paddingTop2 {
    return _paddingTop2;
  }

  double get columnPadding {
    return _columnPadding;
  }

  double get h0 {
    return _h0;
  }

  double get h1 {
    return _h1;
  }

  double get h2 {
    return _h2;
  }

  double get h3 {
    return _h3;
  }

  double get h4 {
    return _h4;
  }

  double get h5 {
    return _h5;
  }
}
