import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import '../providers/color_scheme.dart';
import '../classes/file_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
  String baseUrl = 'https://runwithme.msuki.tk';
  CustomThemeMode mode = CustomThemeMode.light;
  CustomColorScheme colors;
  var settings = Settings();
  final secureStorage = const FlutterSecureStorage();

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
    // First it reads software settings from file
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

    // Then it checks for user credentials
    _checkUserCredentials();

    notifyListeners();
    return true;
  }

  Future<bool> userLogin(userName, password) async {
    try {
      // Makes the http request for the login
      var request =
          http.MultipartRequest('POST', Uri.parse(baseUrl + '/login'));
      request.fields.addAll({
        'username': userName,
        'password': password,
      });
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        // Decode the jwt from the response
        var jwt = json.decode(await response.stream.bytesToString());
        // Saves users info into safe storage for future use
        await secureStorage.write(key: 'username', value: userName);
        await secureStorage.write(key: 'password', value: password);
        await secureStorage.write(key: 'jwt', value: jwt['access_token']);
        // Set isLoggedIn to true, This variable is used internally as a soft lock to avoid checking for the jwt every time
        settings.isLoggedIn = true;
        // Saves the new isLoggedIn value to file and notify all listeners
        FileManager()
            .writeFile(json.encode(settings.toJson()), settingsFileName);
        notifyListeners();
        return true;
      } else {
        settings.isLoggedIn = false;
        FileManager()
            .writeFile(json.encode(settings.toJson()), settingsFileName);
        notifyListeners();
        print(response.reasonPhrase);
        return false;
      }
    } catch (error) {
      settings.isLoggedIn = false;
      FileManager().writeFile(json.encode(settings.toJson()), settingsFileName);
      notifyListeners();
      rethrow;
    }
  }

  Future<void> _checkUserCredentials() async {
    print("checking user crendentials...");
    String? username = await secureStorage.read(key: 'username');
    String? password = await secureStorage.read(key: 'password');
    if (username != null && password != null) {
      try {
        // Makes the http request for the login
        var request =
            http.MultipartRequest('POST', Uri.parse(baseUrl + '/login'));
        request.fields.addAll({
          'username': username,
          'password': password,
        });
        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          // Decode the jwt from the response
          var jwt = json.decode(await response.stream.bytesToString());
          // Saves users info into safe storage for future use
          await secureStorage.write(key: 'jwt', value: jwt['access_token']);
          // Set isLoggedIn to true, This variable is used internally as a soft lock to avoid checking for the jwt every time
          settings.isLoggedIn = true;
          // Saves the new isLoggedIn value to file and notify all listeners
          FileManager()
              .writeFile(json.encode(settings.toJson()), settingsFileName);
          notifyListeners();
        } else {
          settings.isLoggedIn = false;
          FileManager()
              .writeFile(json.encode(settings.toJson()), settingsFileName);
          notifyListeners();
        }
      } catch (error) {
        settings.isLoggedIn = false;
        FileManager()
            .writeFile(json.encode(settings.toJson()), settingsFileName);
        notifyListeners();
        rethrow;
      }
    } else {
      print("Login credentials are empty");
      // IsLoggedIn is set to false so that the app knows not to render registered content
      settings.isLoggedIn = false;
      FileManager().writeFile(json.encode(settings.toJson()), settingsFileName);
      notifyListeners();
    }
  }

  Future<void> userLogout() async {
    await secureStorage.delete(key: 'username');
    await secureStorage.delete(key: 'password');
    await secureStorage.delete(key: 'jwt');
    settings.isLoggedIn = false;
    FileManager().writeFile(json.encode(settings.toJson()), settingsFileName);

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
