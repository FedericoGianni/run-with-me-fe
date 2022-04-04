import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import 'package:weather_icons/weather_icons.dart';

class WeatherHelper {
  static int firstDigit(int number) {
    return int.parse(number.toString().substring(0, 1));
  }

  static int first2Digit(int number) {
    return int.parse(number.toString().substring(0, 2));
  }

  static IconData? iconFromTemperature(Temperature temperature) {
    double tempInCelsius = temperature.celsius ?? 0.0;

    // TODO add more cases
    if (tempInCelsius < 10) {
      return const Icon(Icons.ac_unit).icon;
    } else {
      return const Icon(WeatherIcons.sunset).icon;
    }
  }

  static Icon translateCodeIntoIcon(int? weatherCode, Color color) {
    int firstWeatherCodeDigit = firstDigit(weatherCode ?? 0);
    //int first2Digits = first2Digit(weatherCode ?? 0);

    // Group 2xx: Thunderstorm
    // Group 3xx: Drizzle
    // Group 5xx: Rain
    // Group 6xx: Snow
    // Group 7xx: Atmosphere
    // Group 800: Clear
    // Group 80x: Clouds

    if (weatherCode == 800) {
      return Icon(
        WeatherIcons.day_sunny,
        color: color,
      );
    }

    switch (firstWeatherCodeDigit) {
      case 2:
        return Icon(
          WeatherIcons.thunderstorm,
          color: color,
        );
        break;

      case 3:
        // TODO CHECK THIS ICON
        return Icon(
          WeatherIcons.rain_mix,
          color: color,
        );
        break;

      case 5:
        return Icon(
          WeatherIcons.rain,
          color: color,
        );
        break;

      case 6:
        return Icon(
          WeatherIcons.snow,
          color: color,
        );
        break;

      case 7:
        return Icon(
          WeatherIcons.fog,
          color: color,
        );
        break;

      case 8:
        return Icon(
          WeatherIcons.cloud,
          color: color,
        );
        break;

      default:
        return Icon(
          WeatherIcons.sunset,
          color: color,
        );
    }
  }
}
