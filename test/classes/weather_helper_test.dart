import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:runwithme/classes/weather_helper.dart';
import 'package:weather/weather.dart';
import 'package:weather_icons/weather_icons.dart';

void main() {
  group('[WEATHER HELPER]', () {
    test('if temperature < 10 C (283.15 K) then show ac unit icon', () {
      // if temperature < 10 C (283.15 K) then show ac unit icon

      Temperature temperature = Temperature(280.15);
      expect(WeatherHelper.iconFromTemperature(temperature),
          const Icon(Icons.ac_unit).icon);
    });
    test('if temperature > 10 C (283.15 K) then show sunset icon', () {
      //otherwise show Icon(WeatherIcons.sunset).icon

      Temperature temperature = Temperature(285.15);
      expect(WeatherHelper.iconFromTemperature(temperature),
          const Icon(WeatherIcons.sunset).icon);
    });

    test('translate code into icon test', () {
      //otherwise show Icon(WeatherIcons.sunset).icon

      expect(WeatherHelper.translateCodeIntoIcon(800, Colors.amber).icon,
          WeatherIcons.day_sunny);
      expect(WeatherHelper.translateCodeIntoIcon(200, Colors.amber).icon,
          WeatherIcons.thunderstorm);
      expect(WeatherHelper.translateCodeIntoIcon(300, Colors.amber).icon,
          WeatherIcons.rain_mix);
      expect(WeatherHelper.translateCodeIntoIcon(500, Colors.amber).icon,
          WeatherIcons.rain);
      expect(WeatherHelper.translateCodeIntoIcon(600, Colors.amber).icon,
          WeatherIcons.snow);
      expect(WeatherHelper.translateCodeIntoIcon(700, Colors.amber).icon,
          WeatherIcons.fog);
    });
  });
}
