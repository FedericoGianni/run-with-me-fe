import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mockito/mockito.dart';
import 'package:runwithme/classes/config.dart';
import 'package:runwithme/providers/user.dart';

class MockUser extends Mock implements User {
  @override
  final secureStorage = const FlutterSecureStorage();

  @override
  int? userId = 0;
  @override
  String? username = "test";
  @override
  String? name = "test";
  @override
  String? surname = "test";
  @override
  String? email = "test@test.com";
  @override
  DateTime? createdAt = DateTime.now();
  @override
  int? height = 180;
  @override
  int? age = 30;
  @override
  int? sex = 1;

  // initialize to a default value to let suggestedEvent request works also if user is not registered/logged in
  @override
  double? fitnessLevel = DEFAULT_FITNESS_LEVEL;

  @override
  String? cityName = "MILANO";
  @override
  String? cityId = "3";
  @override
  double? cityLat = 0.0;
  @override
  double? cityLong = 0.0;

  @override
  Config config = Config();

  @override
  void setId(userId) {
    return;
  }

  @override
  Future<bool> getUserInfo() async {
    return true;
  }

  @override
  Future<List> register(username, email, password) async {
    List<String> result = [];
    return result;
  }
}
