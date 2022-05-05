import 'dart:async';
import 'dart:convert';

import 'package:runwithme/models/map_style.dart';

import '../providers/color_scheme.dart';
import '../classes/file_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../providers/user.dart';
import '../classes/config.dart';

enum CustomThemeMode {
  dark,
  light,
}

enum NotificationMode {
  all,
  important,
  off,
}

class UserSettings with ChangeNotifier {
  String settingsFileName = 'settings.json';
  bool location = false;

  CustomThemeMode mode = CustomThemeMode.light;
  late CustomColorScheme colors;
  Settings settings = Settings();
  final secureStorage = const FlutterSecureStorage();
  late User user;
  Config config = Config();

  void setColorScheme(colors) {
    this.colors = colors;
  }

  void toggleLocalization() {
    location = !location;
    notifyListeners();
  }

  void setThemeMode(mode) {
    print("here");
    if (mode == CustomThemeMode.light) {
      colors.setLightMode();
      settings.mapStyle = MapStyle().light;
    } else if (mode == CustomThemeMode.dark) {
      colors.setDarkMode();
      settings.mapStyle = MapStyle().night;
    }
    settings.theme = mode;
    FileManager().writeFile(json.encode(settings.toJson()), settingsFileName);
    notifyListeners();
  }

  void setUser(user) {
    this.user = user;
  }

  @visibleForTesting
  void setisLoggedIn(bool set) {
    settings.isLoggedIn = set;
  }

  void _saveLoginCredentials(username, password, jwt, userId) {
    secureStorage.write(key: 'username', value: username);
    secureStorage.write(key: 'password', value: password);
    secureStorage.write(key: 'jwt', value: jwt);
    secureStorage.write(key: 'userId', value: userId);
  }

  bool isLoggedIn() {
    return settings.isLoggedIn;
  }

  void _saveSettingsAndNotify() {
    FileManager().writeFile(json.encode(settings.toJson()), settingsFileName);
    notifyListeners();
  }

  Future<bool> loadSettings() async {
    // First it reads software settings from file
    var settingsString = await FileManager().readFile(settingsFileName);
    if (settingsString == 'Null' || settingsString == "") {
      settingsString = json.encode(settings.toJson());
      FileManager().writeFile(settingsString, settingsFileName);
    }
    print(settingsString);
    settings.fromJson(jsonDecode(settingsString));

    // ignore: todo
    //TODO: This delay should be removed in production
    // await Future.delayed(const Duration(milliseconds: 2000));
    if (settings.theme == CustomThemeMode.dark) {
      colors.setDarkMode();
      settings.mapStyle = MapStyle().night;
    } else {
      colors.setLightMode();
      settings.mapStyle = MapStyle().light;
    }

    // Then it checks for user credentials
    await _checkUserCredentials();

    notifyListeners();
    return true;
  }

  Future<List> userLogin(userName, password) async {
    print('SettingsManager.userLogin');
    try {
      // Makes the http request for the login
      var request = http.MultipartRequest(
          'POST', Uri.parse(config.getBaseUrl() + '/login'));
      request.fields.addAll({
        'username': userName,
        'password': password,
      });
      http.StreamedResponse response =
          await request.send().timeout(Duration(seconds: config.apiTimeout));
      if (response.statusCode == 200) {
        // Decode the jwt from the response
        var result = json.decode(await response.stream.bytesToString());
        // Saves users info into safe storage for future use
        _saveLoginCredentials(userName, password,
            result['access_token'].toString(), result['user_id'].toString());

        user.userId = result['user_id'];
        await user.getUserInfo();

        settings.isLoggedIn = true;
        // Set isLoggedIn to true, This variable is used internally as a soft lock to avoid checking for the jwt every time
        // Saves the new isLoggedIn value to file and notify all listeners
        // If the getUserInfo request is successfull, then flag the user as logged in
        _saveSettingsAndNotify();
        return [true, 'Logging in'];
      } else if (response.statusCode == 401) {
        settings.isLoggedIn = false;
        _saveSettingsAndNotify();

        print("userLogin errored with message: " +
            response.reasonPhrase.toString());
        return [false, 'Incorrect Username or Password!'];
      } else {
        settings.isLoggedIn = false;
        _saveSettingsAndNotify();

        print("userLogin errored with message: " +
            response.reasonPhrase.toString());
        return [false, 'Dafuq did just happen'];
      }
    } catch (error) {
      print(error);
      settings.isLoggedIn = false;
      _saveSettingsAndNotify();
      return [false, 'Internal Server Error'];
    }
  }

  Future<void> _checkUserCredentials() async {
    print("checking user crendentials...");
    String? username = await secureStorage.read(key: 'username');
    String? password = await secureStorage.read(key: 'password');
    if (username != null && password != null) {
      try {
        // Makes the http request for the login
        var request = http.MultipartRequest(
            'POST', Uri.parse(config.getBaseUrl() + '/login'));
        request.fields.addAll({
          'username': username,
          'password': password,
        });
        http.StreamedResponse response = await request
            .send()
            .timeout(Duration(seconds: config.getApiTimeout()));

        if (response.statusCode == 200) {
          // Decode the jwt from the response
          var jwt = json.decode(await response.stream.bytesToString());
          // Saves users info into safe storage for future use
          print(jwt);
          await secureStorage.write(key: 'jwt', value: jwt['access_token']);
          await secureStorage.write(
              key: 'userId', value: jwt['user_id'].toString());
          // Set isLoggedIn to true, This variable is used internally as a soft lock to avoid checking for the jwt every time
          // Saves the new isLoggedIn value to file and notify all listeners
          FileManager()
              .writeFile(json.encode(settings.toJson()), settingsFileName);
          notifyListeners();
          user.userId = jwt['user_id'];
          print("setting user info");

          settings.isLoggedIn = await user.getUserInfo();
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
        print(
            "Could not get user Info, probably because user is not logged in");
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
    user.username = '';
    _saveSettingsAndNotify();
  }
}

class Settings {
  CustomThemeMode theme = CustomThemeMode.light;
  bool location = false;
  NotificationMode notification = NotificationMode.off;
  var mapStyle = MapStyle().light;
  bool isLoggedIn = false;

  fromJson(Map<String, dynamic> json) {
    theme = CustomThemeMode.values
        .firstWhere((e) => describeEnum(e) == json['theme']);
    location = json['location'] == 'true';
    notification = NotificationMode.values
        .firstWhere((e) => describeEnum(e) == json['notification']);
    // mapStyle = MapStyleMode.values
    //     .firstWhere((e) => describeEnum(e) == json['map_style']);
    isLoggedIn = json['loggedIn'] == 'true';
  }

  Map<String, dynamic> toJson() => {
        'theme': theme.name,
        'location': location.toString(),
        'notification': notification.name,
        // 'map_style': mapStyle.name,
        'loggedIn': isLoggedIn.toString(),
      };
}
