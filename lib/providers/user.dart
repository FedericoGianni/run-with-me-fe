import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:runwithme/providers/locationHelper.dart';
import 'package:uuid/uuid.dart';
import '../classes/file_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'settings_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../classes/config.dart';

final double DEFAULT_FITNESS_LEVEL = 3.5;

class User with ChangeNotifier {
  final secureStorage = const FlutterSecureStorage();

  int? userId;
  String? username;
  String? name;
  String? surname;
  String? email;
  DateTime? createdAt;
  int? height;
  int? age;
  int? sex;

  // initialize to a default value to let suggestedEvent request works also if user is not registered/logged in
  double? fitnessLevel = DEFAULT_FITNESS_LEVEL;

  String? cityName;
  String? cityId;
  double? cityLat;
  double? cityLong;

  Config config = Config();

  void setId(userId) {
    this.userId = userId;
    notifyListeners();
  }

  double get defaultFitnessLevel {
    return DEFAULT_FITNESS_LEVEL;
  }

  Future<List> register(username, email, password) async {
    try {
      // Makes the http request for the login
      var request = http.MultipartRequest(
          'POST', Uri.parse(Config.baseUrl + '/register'));
      request.fields.addAll({
        'username': username,
        'email': email,
        'password': password,
      });
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print("Signup went correctly");
        var userId = json.decode(await response.stream.bytesToString());
        print(userId);

        if (userId['id'] != -1) {
          this.userId = userId['id'];
          this.username = username;
          return [true, 'Registration was successfull'];
        } else {
          return [false, 'Internal Server Error'];
        }
        // notifyListeners();

      } else {
        print(response.statusCode);
        print(response.reasonPhrase);
        if (response.statusCode == 500) {
          return [false, 'Internal Server Error'];
        }
        return [false, 'Generic Server Error'];
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> getUserInfo() async {
    try {
      // Makes the http request for the login
      String? jwt = await secureStorage.read(key: 'jwt');
      if (jwt != null) {
        print("Getting user info");
        var request = http.MultipartRequest(
            'GET', Uri.parse(Config.baseUrl + '/user/id/' + userId.toString()));
        var headers = {'Authorization': 'Bearer ' + jwt};
        request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();
        print(Config.baseUrl + '/user/id' + userId.toString());

        if (response.statusCode == 200) {
          print("user info get went correctly");
          var userInfo = json.decode(await response.stream.bytesToString());
          print("User info: ");
          print(userInfo);
          age = userInfo['age'];
          sex = userInfo['sex'];
          name = userInfo['name'] ?? '';
          surname = userInfo['surname'] ?? '';
          email = userInfo['email'] ?? '';

          if (userInfo['city'] != null) {
            Map<String, Object> city = await LocationHelper().getPlaceDetails(
                placeId: userInfo['city'], sessionToken: Uuid().v4());

            cityName = city['name'].toString();
            cityId = city['place_id'].toString();
            cityLat = double.parse(city['latitude'].toString());
            cityLong = double.parse(city['longitude'].toString());
          }
          createdAt = DateTime.fromMillisecondsSinceEpoch(
              userInfo['created_at'].toInt() * 1000);
          fitnessLevel = userInfo['fitness_level'];
          height = userInfo['height'];
          username = userInfo['username'];
          notifyListeners();
          return true;
        }
      } else {
        print("Jwt was not found");
        return false;
      }
      return false;
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<bool> updateUser() async {
    try {
      // Makes the http request for the login
      String? jwt = await secureStorage.read(key: 'jwt');
      if (jwt != null) {
        print("Updating user info");
        var request = http.MultipartRequest('POST',
            Uri.parse(config.getBaseUrl() + '/user/' + userId.toString()));
        var headers = {'Authorization': 'Bearer ' + jwt};
        request.headers.addAll(headers);
        request.fields.addAll({
          'email': email!,
          'name': name!,
          'surname': surname!,
          'height': height.toString(),
          'age': age.toString(),
          'sex': sex.toString(),
          'fitness_level': fitnessLevel.toString(),
          'city': cityId!,
        });

        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          print(await response.stream.bytesToString());
          return true;
        } else {
          print(response.reasonPhrase);
          return false;
        }
      } else {
        print("UpdateUser error: Jwt was not found");
        return false;
      }
    } catch (error) {
      print(error);
      rethrow;
    }
  }
}
