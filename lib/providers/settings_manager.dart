///{@category Providers}

/// A provider responsible for all the settings related functions.
import 'dart:async';
import 'dart:convert';

import '../providers/color_scheme.dart';
import '../classes/file_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../providers/user.dart';
import '../classes/config.dart';

///All theme modes enumerated by name.
enum CustomThemeMode {
  dark,
  light,
}

///All notification modes enumerated by name.
///This Enum is DEPRECATED.
enum NotificationMode {
  all,
  important,
  off,
}

///All map styles enumerated by name.
///This Enum is DEPRECATED.
enum MapStyle {
  light,
  dark,
}

///The helper responsible for the user settings.
class UserSettings with ChangeNotifier {
  ///The name of the file in which to store all settings as a JSON.
  String settingsFileName = 'settings.json';

  ///Bool that indicates whether location services are enables or not in the app settings.
  bool location = false;

  ///Default theme mode at first startup is light.
  ///The app will then remember any user modification to this setting.
  CustomThemeMode mode = CustomThemeMode.light;
  late CustomColorScheme colors;
  Settings settings = Settings();
  final secureStorage = const FlutterSecureStorage();
  late User user;
  Config config = Config();

  ///Sets the appropriate color scheme depending on the current theme mode.
  void setColorScheme(colors) {
    this.colors = colors;
  }

  ///DEPRECATED
  ///Initially used to toggle on or off the location services.
  void toggleLocalization() {
    location = !location;
    notifyListeners();
  }

  ///Sets the theme mode to one of the possible theme modes depending on the input [mode].
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

  ///Returns a bool indicating whether the current user is logged in or not.
  bool isLoggedIn() {
    return settings.isLoggedIn;
  }

  ///Writes all current settings to file and notify any listeners of the changes.
  void _saveSettingsAndNotify() {
    FileManager().writeFile(json.encode(settings.toJson()), settingsFileName);
    notifyListeners();
  }

  ///Loads user settings from the settings file into memory,
  ///changes all internal toggles accordingly, then notifies all listeners.
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
    } else {
      colors.setLightMode();
    }

    // Then it checks for user credentials
    await _checkUserCredentials();

    notifyListeners();
    return true;
  }

  ///Performs all the necessary preliminary check, then execute the login
  ///request with the [userName] and [password] parameters in order to actually log in the current user
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

  ///Checks whether the current user login credentials stored in memory are corret or not.
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

  ///Perform a user logout request to notify the backend of the logout,
  ///then deletes all user credentials from the device storage.
  Future<void> userLogout() async {
    await secureStorage.delete(key: 'username');
    await secureStorage.delete(key: 'password');
    await secureStorage.delete(key: 'jwt');
    settings.isLoggedIn = false;
    user.username = '';
    _saveSettingsAndNotify();
  }
}

/// Object storing all possible user defined settings.
class Settings {
  CustomThemeMode theme = CustomThemeMode.light;
  bool location = false;
  NotificationMode notification = NotificationMode.off;
  MapStyle mapStyle = MapStyle.light;
  bool isLoggedIn = false;

  ///Converts the JSON representation of the settings back into the settings object.
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

  /// Converts the current settings object back into its JSON representation in
  /// order to store it into memory.
  Map<String, dynamic> toJson() => {
        'theme': theme.name,
        'location': location.toString(),
        'notification': notification.name,
        'map_style': mapStyle.name,
        'loggedIn': isLoggedIn.toString(),
      };
}
