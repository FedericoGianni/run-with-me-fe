import 'package:mockito/mockito.dart';
import 'package:runwithme/providers/event.dart';
import 'package:runwithme/providers/events.dart';
import 'package:runwithme/models/dummy_events.dart';
import 'package:runwithme/providers/settings_manager.dart';
import 'package:runwithme/providers/user.dart';

class MockUserSettingsProvider extends Mock implements UserSettings {
  @override
  Settings settings = Settings();

  @override
  bool isLoggedIn() {
    return settings.isLoggedIn;
  }

  @override
  void setisLoggedIn(bool set) {
    settings.isLoggedIn = set;
  }

  @override
  Future<bool> loadSettings() async {
    return false;
  }
}
