import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import '../providers/color_scheme.dart';
import '../classes/file_manager.dart';

enum CustomThemeMode {
  dark,
  light,
}

class UserSettings with ChangeNotifier {
  bool location = false;
  CustomThemeMode mode = CustomThemeMode.light;
  CustomColorScheme colors;

  UserSettings({required this.colors});

  void toggleLocalization() {
    location = !location;
    notifyListeners();
  }

  void setThemeMode(mode) {
    if (mode == CustomThemeMode.light) {
      colors.setLightMode();
    } else if (mode == CustomThemeMode.dark) {
      colors.setDarkMode();
    }
    FileManager().writeFile(mode.toString());
    notifyListeners();
  }

  Future<bool> loadSettings() async {
    var sett = await FileManager().readFile();

    //TODO: This delay should be removed in production
    await Future.delayed(const Duration(milliseconds: 1000));
    if (sett == 'CustomThemeMode.dark') {
      colors.setDarkMode();
    } else {
      colors.setLightMode();
    }
    notifyListeners();
    return true;
  }
}
