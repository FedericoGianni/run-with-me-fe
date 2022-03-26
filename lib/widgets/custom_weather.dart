import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:weather/weather.dart';
import 'package:weather_icons/weather_icons.dart';

import '../classes/date_helper.dart';
import '../providers/color_scheme.dart';
import '../providers/locationHelper.dart';

enum AppState { NOT_DOWNLOADED, DOWNLOADING, FINISHED_DOWNLOADING }

class WeatherWidget extends StatefulWidget {
  @override
  _WeatherWidgetState createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  String key = '************REMOVED************';
  late WeatherFactory ws;
  List<Weather> _todayData = [];
  List<Weather> _forecastData = [];
  AppState _state = AppState.NOT_DOWNLOADED;
  double? lat, lon;

  @override
  void initState() {
    super.initState();
    ws = new WeatherFactory(key);
  }

  @override
  void didChangeDependencies() {
    _coordinateInputs();
    queryWeather();
    queryForecast();
    super.didChangeDependencies();
  }

  void queryForecast() async {
    /// Removes keyboard user input not used anymore
    //FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      _state = AppState.DOWNLOADING;
      //print("APPSTATE DOWNLOADING FORECASTS...");
    });

    List<Weather> forecasts = await ws.fiveDayForecastByLocation(lat!, lon!);
    setState(() {
      _forecastData = forecasts;
      _state = AppState.FINISHED_DOWNLOADING;
      //print("APPSTATE DOWNLOADED FORECASTS!!!");
    });
  }

  void queryWeather() async {
    /// Removes keyboard
    //FocusScope.of(context).requestFocus(FocusNode());

    setState(() {
      _state = AppState.DOWNLOADING;
      //print("APPSTATE DOWNLOADING WEATHER...");
    });

    Weather weather = await ws.currentWeatherByLocation(lat!, lon!);
    setState(() {
      _todayData = [weather];
      _state = AppState.FINISHED_DOWNLOADING;
      //print("APPSTATE DOWNLOADED WEATHER!!!");
    });
  }

  Widget contentFinishedDownload() {
    //print("CONTENT FINISHED DOWNLOAD");

    // TODO return also forecasts weather
    return weather();
  }

  int firstDigit(int number) {
    return int.parse(number.toString().substring(0, 1));
  }

  int first2Digit(int number) {
    return int.parse(number.toString().substring(0, 2));
  }

  IconData? iconFromTemperature(Temperature temperature) {
    double tempInCelsius = temperature.celsius ?? 0.0;

    // TODO add more cases
    if (tempInCelsius < 10) {
      return Icon(Icons.ac_unit).icon;
    } else {
      return Icon(WeatherIcons.sunset).icon;
    }
  }

  Icon translateCodeIntoIcon(int? weatherCode, Color color) {
    int firstWeatherCodeDigit = firstDigit(weatherCode ?? 0);
    //int first2Digits = first2Digit(weatherCode ?? 0);

    // Group 2xx: Thunderstorm
    // Group 3xx: Drizzle
    // Group 5xx: Rain
    // Group 6xx: Snow
    // Group 7xx: Atmosphere
    // Group 800: Clear
    // Group 80x: Clouds

    // TODO refactorare sto schifo
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
        return new Icon(
          WeatherIcons.sunset,
          color: color,
        );
    }
  }

  Widget forecastWeather() {
    final colors = Provider.of<CustomColorScheme>(context);
    return Text("Forecast weatehr");
  }

  Widget renderWeather(Weather? weather, int dayIndex) {
    final colors = Provider.of<CustomColorScheme>(context);
    String? desc = weather?.weatherDescription;
    String day;
    String todayOrTomorrow = "";

    if (dayIndex == 0) {
      todayOrTomorrow = "Today";
    } else if (dayIndex == 1) {
      todayOrTomorrow = "Tomorrow";
    }

    day = DateHelper.dayOfWeekAfterXdays(dayIndex);

    if (weather == null) {
      return Row();
    }

    return Row(
      children: [
        translateCodeIntoIcon(
            weather.weatherConditionCode,
            todayOrTomorrow.isEmpty
                ? colors.primaryColor
                : colors.secondaryColor),
        Padding(
          padding: const EdgeInsets.all(8.0),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 4.0),
          child: Text(
            todayOrTomorrow,
            style: TextStyle(
                color: colors.tertiaryTextColor,
                fontSize: 14,
                fontWeight: FontWeight.w900),
          ),
        ),
        Text(
          day + " ",
          style: TextStyle(
              color: colors.primaryTextColor,
              fontSize: 18,
              fontWeight: FontWeight.w900),
        ),
        Text(
          desc!,
          style: TextStyle(
              color: todayOrTomorrow.isEmpty
                  ? colors.primaryColor
                  : colors.secondaryColor,
              fontSize: 18,
              fontWeight: FontWeight.w900),
        ),
      ],
    );
  }

  Widget weather() {
    final colors = Provider.of<CustomColorScheme>(context);

    // forecast data are already sorted
    // sort data by date
    //_data.sort((a, b) => a.date!.compareTo(b.date!));
    //_data = _data.sublist(0, 5);

    String location = "";
    String country = "";
    String desc = "";

    // to avoid bad state error
    if (_todayData.isNotEmpty) {
      location = _todayData.first.areaName.toString();
      country = _todayData.first.country.toString();

      desc = _todayData.first.weatherDescription ?? "";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(Icons.location_on, color: colors.secondaryColor),
              Padding(
                padding: const EdgeInsets.all(8.0),
              ),
              Text(
                location + ', ' + country,
                style: TextStyle(
                    color: colors.primaryTextColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w900),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: renderWeather(_todayData.first, 0),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: renderWeather(
              _forecastData.isNotEmpty ? _forecastData[0] : null, 1),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: renderWeather(
              _forecastData.isNotEmpty ? _forecastData[1] : null, 2),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: renderWeather(
              _forecastData.isNotEmpty ? _forecastData[2] : null, 3),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: renderWeather(
              _forecastData.isNotEmpty ? _forecastData[3] : null, 4),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: renderWeather(
              _forecastData.isNotEmpty ? _forecastData[4] : null, 5),
        ),
      ],
    );
  }

  Widget contentDownloading() {
    //print("CONTENT DOWNLOADING");
    return Container(
      // margin: EdgeInsets.symmetric(
      //     horizontal: MediaQuery.of(context).size.width / 5),
      child: Column(children: [
        Text(
          'Fetching Weather...',
          style: TextStyle(
              color: Provider.of<CustomColorScheme>(context).primaryTextColor,
              fontSize: 20,
              fontWeight: FontWeight.w900),
        ),
        Container(
            margin: EdgeInsets.only(top: 50),
            child: Center(child: CircularProgressIndicator(strokeWidth: 5)))
      ]),
    );
  }

  Widget contentNotDownloaded() {
    queryForecast();
    queryWeather();
    //print("CONTENT NOT DOWNLOADED");
    return Text(
      "CONTENT NOT DOWNLOADED",
      style: TextStyle(
          color: Provider.of<CustomColorScheme>(context).primaryTextColor,
          fontSize: 20,
          fontWeight: FontWeight.w900),
    );
  }

  Widget _resultView() => _state == AppState.FINISHED_DOWNLOADING
      ? contentFinishedDownload()
      : _state == AppState.DOWNLOADING
          ? contentDownloading()
          : contentNotDownloaded();

  void _coordinateInputs() {
    Position userPosition =
        Provider.of<LocationHelper>(context).getLastKnownPosition();

    setState(() {
      lat = userPosition.latitude;
      lon = userPosition.longitude;
    });
  }

  @override
  Widget build(BuildContext context) {
    _coordinateInputs();
    return Column(
      children: <Widget>[_resultView()],
    );
  }
}
