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
  List<Weather> _data = [];
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
      _data = forecasts;
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
      _data = [weather];
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

  IconData? iconFromTemperature(Temperature temperature) {
    double tempInCelsius = temperature.celsius ?? 0.0;

    // TODO add more cases
    if (tempInCelsius < 10) {
      return Icon(Icons.ac_unit).icon;
    } else {
      return Icon(WeatherIcons.sunset).icon;
    }
  }

  Icon translateCodeIntoIcon(int? weatherCode) {
    int firstWeatherCodeDigit = firstDigit(weatherCode ?? 0);
    final colors = Provider.of<CustomColorScheme>(context);

    // Group 2xx: Thunderstorm
    // Group 3xx: Drizzle
    // Group 5xx: Rain
    // Group 6xx: Snow
    // Group 7xx: Atmosphere
    // Group 800: Clear
    // Group 80x: Clouds

    switch (firstWeatherCodeDigit) {
      case 2:
        return Icon(
          WeatherIcons.thunderstorm,
          color: colors.primaryColor,
        );
        break;

      case 3:
        // TODO CHECK THIS ICON
        return Icon(
          WeatherIcons.rain_mix,
          color: colors.primaryColor,
        );
        break;

      case 5:
        return Icon(
          WeatherIcons.rain,
          color: colors.primaryColor,
        );
        break;

      case 6:
        return Icon(
          WeatherIcons.snow,
          color: colors.primaryColor,
        );
        break;

      case 7:
        return Icon(
          WeatherIcons.fog,
          color: colors.primaryColor,
        );
        break;

      case 8:
        return Icon(
          WeatherIcons.cloud,
          color: colors.primaryColor,
        );
        break;

      default:
        return new Icon(
          WeatherIcons.sunset,
          color: colors.primaryColor,
        );
    }
  }

  CustomWeatherElement() {
    String temp;
    String location;
    String country;
    String weatherDesc;
    Icon weatherIcon;
  }

  Widget forecastWeather() {
    final colors = Provider.of<CustomColorScheme>(context);
    return Text("Forecast weatehr");
  }

  Widget weather() {
    final colors = Provider.of<CustomColorScheme>(context);

    Temperature todayTemp = Temperature(0);
    String location = "";
    String country = "";
    String todayWeather = "";
    Icon todayWeatherIcon = Icon(WeatherIcons.sandstorm);

    Temperature tomorrowTemp = Temperature(0);
    String tomorrowWeather = "";
    Icon tomorrowWeatherIcon = Icon(WeatherIcons.sandstorm);

    Temperature dayAfterTomorrowTemp = Temperature(0);
    String dayAfterTomorrowWeather = "";
    Icon dayAfterTomorrowWeatherIcon = Icon(WeatherIcons.sandstorm);

    for (var element in _data) {
      // today weather data
      if (element.date?.day == DateTime.now().day) {
        todayTemp = element.temperature ?? Temperature(0);
        location = element.areaName.toString();
        country = element.country.toString();
        todayWeatherIcon = translateCodeIntoIcon(element.weatherConditionCode);
        todayWeather = element.weatherDescription.toString();
      }

      // tomorrow weather data
      if (DateHelper.calculateDifference(element.date) == 1) {
        tomorrowTemp = element.temperature ?? Temperature(0);
        tomorrowWeather = element.weatherDescription.toString();
        tomorrowWeatherIcon =
            translateCodeIntoIcon(element.weatherConditionCode);
      }

      // 2 days
      if (DateHelper.calculateDifference(element.date) == 2) {
        dayAfterTomorrowTemp = element.temperature ?? Temperature(0);
        dayAfterTomorrowWeather = element.weatherDescription.toString();
        dayAfterTomorrowWeatherIcon =
            translateCodeIntoIcon(element.weatherConditionCode);
      }
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        children: [
          Icon(
            Icons.calendar_month,
            color: colors.primaryColor,
          ),
          Text(
            DateHelper.formatDateTime(DateTime.now()),
            style: TextStyle(
                color: colors.primaryTextColor,
                fontSize: 20,
                fontWeight: FontWeight.w900),
          ),
        ],
      ),
      Row(
        children: [
          Icon(Icons.location_on, color: colors.primaryColor),
          Text(
            location + ', ' + country,
            style: TextStyle(
                color: colors.primaryTextColor,
                fontSize: 20,
                fontWeight: FontWeight.w900),
          ),
        ],
      ),
      Row(
        children: [
          Icon(iconFromTemperature(todayTemp), color: colors.primaryColor),
          Text(
            "Temperature: " + todayTemp.celsius!.toStringAsFixed(1) + " °C",
            style: TextStyle(
                color: colors.primaryTextColor,
                fontSize: 20,
                fontWeight: FontWeight.w900),
          ),
        ],
      ),
      Row(
        children: [
          todayWeatherIcon,
          Text(
            "Today's Weather: " + todayWeather,
            style: TextStyle(
                color: colors.primaryTextColor,
                fontSize: 20,
                fontWeight: FontWeight.w900),
          ),
        ],
      ),
      Row(
        children: [
          tomorrowWeatherIcon,
          Text(
            "Tomorrow: " + tomorrowWeather,
            style: TextStyle(
                color: colors.primaryTextColor,
                fontSize: 20,
                fontWeight: FontWeight.w900),
          ),
        ],
      ),
      Row(
        children: [
          dayAfterTomorrowWeatherIcon,
          Text(
            DateHelper.dayOfWeekAfterTomorrow() +
                ": " +
                dayAfterTomorrowWeather,
            style: TextStyle(
                color: colors.primaryTextColor,
                fontSize: 20,
                fontWeight: FontWeight.w900),
          ),
        ],
      ),
    ]);

    // IconButton(
    //   icon: const Icon(
    //     Icons.location_on,
    //     size: 30,
    //   ),
    //   color: colors.secondaryTextColor,
    //   onPressed: () {},
    //   padding: EdgeInsets.zero,
    //   constraints: const BoxConstraints(),
    //   splashRadius: 10,
    // );
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
