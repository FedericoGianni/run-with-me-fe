import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import '../classes/file_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'settings_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../classes/config.dart';

class User with ChangeNotifier {
  final secureStorage = const FlutterSecureStorage();

  int? userId;
  String? username;
  String? name;
  String? surname;
  DateTime? createdAt;
  int? height;
  int? age;
  int? sex;
  double? fitnessLevel;
  String? city;

  // User(
  //     {required this.userId,
  //     required this.username,
  //     required this.name,
  //     required this.surname,
  //     required this.createdAt,
  //     required this.height,
  //     required this.age,
  //     required this.fitnessLevel,
  //     required this.city});

  void setId(userId) {
    this.userId = userId;
    notifyListeners();
  }

  Future<List> register(username, password) async {
    try {
      // Makes the http request for the login
      var request = http.MultipartRequest(
          'POST', Uri.parse(Config.baseUrl + '/register'));
      request.fields.addAll({
        'username': username,
        'password': password,
      });
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print("Signup went correctly");
        var userId = json.decode(await response.stream.bytesToString());
        print(userId);
        UserSettings().userLogin(username, password);
        this.userId = userId;
        this.username = username;
        // notifyListeners();

        return [true, ''];
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

  Future<void> getUserInfo() async {
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
          print(userInfo);
          age = userInfo['age'];
          sex = userInfo['sex'];
          name = userInfo['name'];
          surname = userInfo['surname'];
          city = userInfo['city'];
          createdAt = DateTime.fromMillisecondsSinceEpoch(
              12321232 * 1000); // userInfo['created_at']
          fitnessLevel = userInfo['fitness_level'];
          height = userInfo['height'];
          username = userInfo['username'];
          notifyListeners();
        }
      } else {
        print("Jwt was not found");
      }
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<void> updateUser() async {
    try {
      // Makes the http request for the login
      String? jwt = await secureStorage.read(key: 'jwt');
      if (jwt != null) {
        print("Updating user info");
        var request = http.MultipartRequest(
            'POST', Uri.parse('https://runwithme.msuki.tk//user/1'));
        var headers = {'Authorization': 'Bearer ' + jwt};
        request.headers.addAll(headers);
        request.fields.addAll({
          'email': 'updated@mail.com',
          'name': 'updatedPippo',
          'surname': 'topolina',
          'height': '170',
          'age': '33',
          'sex': '1',
          'fitness_level': '50',
          'city': 'Milano'
        });

        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          print(await response.stream.bytesToString());
        } else {
          print(response.reasonPhrase);
        }
      } else {
        print("Jwt was not found");
      }
    } catch (error) {
      print(error);
      rethrow;
    }
  }
}
