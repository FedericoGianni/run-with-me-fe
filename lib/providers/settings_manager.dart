import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import '../providers/color_scheme.dart';
import '../classes/file_manager.dart';
import 'package:flutter/foundation.dart';

enum CustomThemeMode {
  dark,
  light,
}

enum NotificationMode {
  all,
  important,
  off,
}

enum MapStyle {
  light,
  dark,
}

class UserSettings with ChangeNotifier {
  String settingsFileName = 'settings.json';
  bool location = false;
  var settings = Settings();
  CustomThemeMode mode = CustomThemeMode.light;
  CustomColorScheme colors;

  UserSettings({required this.colors});

  void toggleLocalization() {
    location = !location;
    notifyListeners();
  }

  void setThemeMode(mode) {
    print("here");
    if (mode == CustomThemeMode.light) {
      colors.setLightMode();
    } else if (mode == CustomThemeMode.dark) {
      colors.setDarkMode();
    }
    settings.theme = mode;
    FileManager().writeFile(json.encode(settings.toJson()), settingsFileName);
    notifyListeners();
  }

  Future<bool> loadSettings() async {
    var settingsString = await FileManager().readFile(settingsFileName);
    if (settingsString == 'Null') {
      settingsString = json.encode(settings.toJson());
      FileManager().writeFile(settingsString, settingsFileName);
    }
    settings.fromJson(jsonDecode(settingsString));

    // ignore: todo
    //TODO: This delay should be removed in production
    // await Future.delayed(const Duration(milliseconds: 2000));
    if (settings.theme == CustomThemeMode.dark) {
      colors.setDarkMode();
    } else {
      colors.setLightMode();
    }
    notifyListeners();
    return true;
  }

  void userLogin() {
    settings.isLoggedIn = true;
    notifyListeners();
  }

  void userLogout() {
    settings.isLoggedIn = false;
    notifyListeners();
  }
}

class Settings {
  CustomThemeMode theme = CustomThemeMode.light;
  bool location = false;
  NotificationMode notification = NotificationMode.off;
  MapStyle mapStyle = MapStyle.light;
  bool isLoggedIn = false;

  fromJson(Map<String, dynamic> json) {
    theme = CustomThemeMode.values
        .firstWhere((e) => describeEnum(e) == json['theme']);
    location = json['location'] == 'true';
    notification = NotificationMode.values
        .firstWhere((e) => describeEnum(e) == json['notification']);
    mapStyle =
        MapStyle.values.firstWhere((e) => describeEnum(e) == json['map_style']);
    isLoggedIn = json['loggedIn'] == 'true';
  }

  Map<String, dynamic> toJson() => {
        'theme': theme.name,
        'location': location.toString(),
        'notification': notification.name,
        'map_style': mapStyle.name,
        'loggedIn': isLoggedIn.toString(),
      };
}
