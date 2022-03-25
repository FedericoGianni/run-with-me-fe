import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:weather/weather.dart';

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
    /// Removes keyboard
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      _state = AppState.DOWNLOADING;
      print("APPSTATE DOWNLOADING FORECASTS...");
    });

    List<Weather> forecasts = await ws.fiveDayForecastByLocation(lat!, lon!);
    setState(() {
      _data = forecasts;
      _state = AppState.FINISHED_DOWNLOADING;
      print("APPSTATE DOWNLOADED FORECASTS!!!");
    });
  }

  void queryWeather() async {
    /// Removes keyboard
    FocusScope.of(context).requestFocus(FocusNode());

    setState(() {
      _state = AppState.DOWNLOADING;
      print("APPSTATE DOWNLOADING WEATHER...");
    });

    Weather weather = await ws.currentWeatherByLocation(lat!, lon!);
    setState(() {
      _data = [weather];
      _state = AppState.FINISHED_DOWNLOADING;
      print("APPSTATE DOWNLOADED WEATHER!!!");
    });
  }

  Widget contentFinishedDownload() {
    print("CONTENT FINISHED DOWNLOAD");

    // TODO present to the user today weather + forecasts of his location
    String todayTemp = "";
    String location = "";
    String country = "";
    _data.forEach((element) {
      if (element.date?.day == DateTime.now().day) {
        todayTemp = element.temperature.toString();
        location = element.areaName.toString();
        country = element.country.toString();
      }
    });
    return Text(
      "Location: " +
          location +
          ', ' +
          country +
          '\n' +
          "Temperature: " +
          todayTemp +
          "\n",
      style: TextStyle(
          color: Provider.of<CustomColorScheme>(context).primaryTextColor,
          fontSize: 20,
          fontWeight: FontWeight.w900),
    );
  }

  Widget contentDownloading() {
    print("CONTENT DOWNLOADING");
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
    print("CONTENT NOT DOWNLOADED");
    return Text("A");
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
