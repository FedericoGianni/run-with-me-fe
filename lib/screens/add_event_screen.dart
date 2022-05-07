// ignore_for_file: unnecessary_const

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:runwithme/providers/locationHelper.dart';
import 'package:runwithme/widgets/custom_map_search.dart';
import 'package:runwithme/widgets/custom_maps_new.dart';
import 'package:runwithme/widgets/search_event_bottomsheet.dart';

import '../classes/multi_device_support.dart';
import '../providers/settings_manager.dart';
import '../widgets/custom_scroll_behavior.dart';
import '../widgets/permissions_message.dart';
import '../widgets/search_button.dart';

import '../widgets/event_card_text_only.dart';
import '../themes/custom_colors.dart';
import '../themes/custom_theme.dart';
import '../widgets/gradientAppbar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../providers/page_index.dart';

import 'package:provider/provider.dart';
import '../widgets/custom_loading_circle_icon.dart';
import '../providers/color_scheme.dart';
import '../providers/event.dart';
import '../providers/events.dart';
import '../providers/user.dart';
import 'event_details_screen.dart';

class AddEventScreen extends StatefulWidget {
  static const routeName = '/add_event';
  bool _isSearching = false;

  @override
  State<AddEventScreen> createState() => AddEventScreenState();
}

@visibleForTesting
class AddEventScreenState extends State<AddEventScreen> {
  final _form = GlobalKey<FormState>();
  final _participantsFocusNode = FocusNode();
  final _distanceFocusNode = FocusNode();
  final _durationFocusNode = FocusNode();
  bool _isLoading = false;

  // LatLng defaultUserPos = const LatLng(44.48867812986885, 6.197411131341138);
  LatLng markerPosition = const LatLng(0, 0);

  DateTime _userSelectedDate = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();

  static const double padding = 30;

  var _editedEvent = Event(
    adminId: 0,
    averageDuration: 0,
    averageLength: 0,
    averagePaceMin: 0,
    averagePaceSec: 0,
    createdAt: DateTime.now(),
    currentParticipants: 0,
    date: DateTime.now(),
    difficultyLevel: 0,
    maxParticipants: 0,
    name: '',
    startingPintLat: 0,
    startingPintLong: 0,
    id: null,
  );

  Event get editedEvent {
    return _editedEvent;
  }

  Future<Position> _getLocation() async {
    final locationHelper = Provider.of<LocationHelper>(context, listen: false);

    Position currentLocation = locationHelper.getLastKnownPositionAndUpdate();
    _isLoading = false;
    return Position(
        longitude: currentLocation.longitude,
        latitude: currentLocation.latitude,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0);
  }

  void _presentDatePicker() {
    final colors = Provider.of<CustomColorScheme>(context, listen: false);
    showDatePicker(
      context: context,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            splashColor: colors.primaryTextColor,
            textTheme: TextTheme(
              subtitle1: TextStyle(color: colors.primaryTextColor),
              button: TextStyle(color: colors.primaryTextColor),
            ),
            accentColor: colors.primaryTextColor,
            colorScheme: ColorScheme.light(
              primary: colors.primaryColor,
              onPrimary: colors.onPrimary,
              onSurface: colors.primaryTextColor,
            ),
            dialogBackgroundColor: colors.onPrimary,
          ),
          child: child ?? const Text(""),
        );
      },
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 50)),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _userSelectedDate = pickedDate;
        _editedEvent = Event(
          adminId: _editedEvent.adminId,
          averageDuration: _editedEvent.averageDuration,
          averageLength: _editedEvent.averageLength,
          averagePaceMin: _editedEvent.averagePaceMin,
          averagePaceSec: _editedEvent.averagePaceSec,
          createdAt: _editedEvent.createdAt,
          currentParticipants: _editedEvent.currentParticipants,
          date: DateTime(pickedDate.year, pickedDate.month, pickedDate.day,
              _time.hour, _time.minute),
          difficultyLevel: _editedEvent.difficultyLevel,
          id: _editedEvent.id,
          maxParticipants: _editedEvent.maxParticipants,
          name: _editedEvent.name,
          startingPintLat: _editedEvent.startingPintLat,
          startingPintLong: _editedEvent.startingPintLong,
        );
      });
    });
  }

  void _selectTime() async {
    final colors = Provider.of<CustomColorScheme>(context, listen: false);

    TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _time,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            splashColor: colors.primaryTextColor,
            textTheme: TextTheme(
              subtitle1: TextStyle(color: colors.primaryTextColor),
              button: TextStyle(color: colors.primaryTextColor),
            ),
            colorScheme: ColorScheme.fromSeed(
                seedColor: colors.primaryColor,
                background: colors.background,
                surface: colors.background,
                onBackground: colors.tertiaryTextColor,
                onPrimary: colors.onPrimary,
                primary: colors.primaryColor,
                onSurface: colors.primaryTextColor),
            // dialogBackgroundColor: colors.background,
          ),
          child: child ?? const Text(""),
        );
      },
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
        _editedEvent = Event(
          adminId: _editedEvent.adminId,
          averageDuration: _editedEvent.averageDuration,
          averageLength: _editedEvent.averageLength,
          averagePaceMin: _editedEvent.averagePaceMin,
          averagePaceSec: _editedEvent.averagePaceSec,
          createdAt: _editedEvent.createdAt,
          currentParticipants: _editedEvent.currentParticipants,
          date: DateTime(_editedEvent.date.year, _editedEvent.date.month,
              _editedEvent.date.day, newTime.hour, newTime.minute),
          difficultyLevel: _editedEvent.difficultyLevel,
          id: _editedEvent.id,
          maxParticipants: _editedEvent.maxParticipants,
          name: _editedEvent.name,
          startingPintLat: _editedEvent.startingPintLat,
          startingPintLong: _editedEvent.startingPintLong,
        );
      });
    }
  }

  void cleanForm() {
    setState(() {});
  }

  Future<void> _saveForm() async {
    final pageIndex = Provider.of<PageIndex>(context, listen: false);
    final events = Provider.of<Events>(context, listen: false);

    final isValid = _form.currentState?.validate();
    if (isValid == null || !isValid) {
      return;
    }
    _form.currentState?.save();
    setState(() {
      _isLoading = true;
    });

    //editedEvent.id è null finchè il backend non gli ritorna un id
    if (_editedEvent.id != null) {
      // await Provider.of<Events>(context, listen: false)
      //     .updateProduct(_editedEvent.id, _editedEvent);
      // print("Here I should edit the Event");
    } else {
      try {
        // print("test markerposition: " + markerPosition.toString());

        // print("_editedEvent.adminId: " + _editedEvent.adminId.toString());
        // print("_editedEvent.avgDuration: " +
        //     _editedEvent.averageDuration.toString());
        // print(
        //     "_editedEvent.avgLength: " + _editedEvent.averageLength.toString());
        // print(
        //     "_editedEvent.avgPace: " + _editedEvent.averagePaceMin.toString());
        // print("_editedEvent.date: " + _editedEvent.date.toString());
        // print("_editedEvent.id: " + _editedEvent.id.toString());
        // print("_editedEvent.maxParticipants: " +
        //     _editedEvent.maxParticipants.toString());
        // print("_editedEvent.name: " + _editedEvent.name.toString());
        // print("_editedEvent.strartingPointLat: " +
        //     _editedEvent.startingPintLat.toString());
        // print("_editedEvent.startingPointLong: " +
        //     _editedEvent.startingPintLong.toString());

        // add event and return id of the newly generated event
        int newEventId = await Provider.of<Events>(context, listen: false)
            .addEvent(_editedEvent);

        // open new event detail screen
        Navigator.of(context).pushNamed(
          EventDetailsScreen.routeName,
          arguments: await events.fetchEventById(newEventId, true),
        );
      } catch (error) {
        print(error);
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('An error occurred!'),
            content: const Text('Something went wrong.'),
            actions: <Widget>[
              FlatButton(
                child: const Text('Okay'),
                onPressed: () {
                  // Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
      // finally {
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.of(context).pop();

      // }
    }
    setState(() {
      _isLoading = false;
    });
    pageIndex.setPage(0);
  }

  @visibleForTesting
  void saveForm() {
    _saveForm();
  }

  @override
  void dispose() {
    _participantsFocusNode.dispose();
    _distanceFocusNode.dispose();
    _durationFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Provider.of<CustomColorScheme>(context);
    final locationHelper = Provider.of<LocationHelper>(context, listen: false);
    final double screenWidth = MediaQuery.of(context).size.width;
    final settings = Provider.of<UserSettings>(context, listen: false);
    var multiDeviceSupport = MultiDeviceSupport(context);
    multiDeviceSupport.init();
    if (settings.isLoggedIn()) {
      return _isLoading
          ? Center(
              child: Builder(builder: (context) {
                return const CustomLoadingCircleIcon();
              }),
            )
          : Form(
              key: _form,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 20 + multiDeviceSupport.tablet * 50,
                  right: 20 + multiDeviceSupport.tablet * 50,
                ),
                child: ScrollConfiguration(
                  behavior: CustomScrollBehavior(),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // scrollDirection: Axis.vertical,
                      // shrinkWrap: true,
                      // cacheExtent: 2000,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                          ),
                          child: Container(
                            padding: const EdgeInsets.only(bottom: 20),
                            height: 30,
                          ),
                        ),
                        // Name
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 0,
                          ),
                          child: Text(
                            'Name: ',
                            style: TextStyle(
                                color: colors.primaryTextColor,
                                fontSize: multiDeviceSupport.h2),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 5,
                          ),
                          child: Text(
                            'Give your new event a nice name',
                            style: TextStyle(
                                color: colors.secondaryTextColor,
                                fontSize: multiDeviceSupport.h4),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                          ),
                          child: TextFormField(
                            key: const Key("name"),
                            initialValue: '',
                            cursorColor: colors.primaryTextColor,
                            style: TextStyle(color: colors.primaryTextColor),
                            decoration: textFormDecoration('Name', context),
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please provide a value.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              if (value != null) {
                                _editedEvent = Event(
                                  adminId: _editedEvent.adminId,
                                  averageDuration: _editedEvent.averageDuration,
                                  averageLength: _editedEvent.averageLength,
                                  averagePaceMin: _editedEvent.averagePaceMin,
                                  averagePaceSec: _editedEvent.averagePaceSec,
                                  createdAt: _editedEvent.createdAt,
                                  currentParticipants:
                                      _editedEvent.currentParticipants,
                                  date: _editedEvent.date,
                                  difficultyLevel: _editedEvent.difficultyLevel,
                                  id: _editedEvent.id,
                                  maxParticipants: _editedEvent.maxParticipants,
                                  //change the event name with the name selected by the user
                                  name: value.toString(),
                                  startingPintLat: _editedEvent.startingPintLat,
                                  startingPintLong:
                                      _editedEvent.startingPintLong,
                                );
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                          height: padding,
                        ),
                        // Date and Time
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 0,
                          ),
                          child: Text(
                            'Date and Time: ',
                            style: TextStyle(
                                color: colors.primaryTextColor,
                                fontSize: multiDeviceSupport.h2),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 5,
                          ),
                          child: Text(
                            'Set the starting time of your event',
                            style: TextStyle(
                                color: colors.secondaryTextColor,
                                fontSize: multiDeviceSupport.h4),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: _presentDatePicker,
                                child: Container(
                                  width: MediaQuery.of(context).size.width /
                                      (2.5 + multiDeviceSupport.tablet * 0.3),
                                  decoration: BoxDecoration(
                                    color: colors.onPrimary,
                                    border: Border.all(color: colors.onPrimary),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                  ),
                                  height: 60,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            _userSelectedDate == null
                                                ? 'No Date Chosen!'
                                                : DateFormat.yMMMd()
                                                    .format(_userSelectedDate),
                                            style: TextStyle(
                                                color:
                                                    colors.secondaryTextColor,
                                                fontSize:
                                                    multiDeviceSupport.h4),
                                          ),
                                        ),
                                        Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Icon(
                                              Icons.calendar_today_outlined,
                                              color: colors.secondaryTextColor,
                                            ))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: _selectTime,
                                child: Container(
                                  width: MediaQuery.of(context).size.width /
                                      (2.5 + multiDeviceSupport.tablet * 0.3),
                                  decoration: BoxDecoration(
                                    color: colors.onPrimary,
                                    border: Border.all(color: colors.onPrimary),
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(10.0),
                                    ),
                                  ),
                                  height: 60,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            _userSelectedDate == null
                                                ? 'No Date Chosen!'
                                                : _time.format(context),
                                            style: TextStyle(
                                                color:
                                                    colors.secondaryTextColor,
                                                fontSize:
                                                    multiDeviceSupport.h4),
                                          ),
                                        ),
                                        Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Icon(
                                              Icons.watch_later_outlined,
                                              color: colors.secondaryTextColor,
                                            ))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: padding,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 0,
                          ),
                          child: Text(
                            'Location: ',
                            style: TextStyle(
                                color: colors.primaryTextColor,
                                fontSize: multiDeviceSupport.h2),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 5,
                          ),
                          child: Text(
                            'Set the starting location of your event',
                            style: TextStyle(
                                color: colors.secondaryTextColor,
                                fontSize: multiDeviceSupport.h4),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              _getLocation().then((value) async {
                                var a = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CustomMapsNew(
                                      markerPosition: markerPosition,
                                      centerPosition: markerPosition ==
                                              LatLng(0, 0)
                                          ? LatLng(
                                              value.latitude, value.longitude)
                                          : markerPosition,
                                    ),
                                  ),
                                );
                                setState(() {
                                  if (a != null) {
                                    markerPosition = a;
                                    _editedEvent = Event(
                                      adminId: _editedEvent.adminId,
                                      averageDuration:
                                          _editedEvent.averageDuration,
                                      averageLength: _editedEvent.averageLength,
                                      averagePaceMin:
                                          _editedEvent.averagePaceMin,
                                      averagePaceSec:
                                          _editedEvent.averagePaceSec,
                                      createdAt: _editedEvent.createdAt,
                                      currentParticipants:
                                          _editedEvent.currentParticipants,
                                      date: _editedEvent.date,
                                      difficultyLevel:
                                          _editedEvent.difficultyLevel,
                                      id: _editedEvent.id,
                                      maxParticipants:
                                          _editedEvent.maxParticipants,
                                      name: _editedEvent.name,
                                      startingPintLat: markerPosition.latitude,
                                      startingPintLong:
                                          markerPosition.longitude,
                                    );
                                  }
                                });
                              });
                            },
                            // initialValue: markerPosition.toString(),,
                            child: Container(
                              // width: MediaQuery.of(context).size.width /
                              //     (2.5 + multiDeviceSupport.tablet * 0.3),
                              decoration: BoxDecoration(
                                color: colors.onPrimary,
                                border: Border.all(color: colors.onPrimary),
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(10.0),
                                ),
                              ),
                              height: 60,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: markerPosition == LatLng(0, 0)
                                            ? Text(
                                                'Search Location',
                                                style: TextStyle(
                                                    color: colors
                                                        .secondaryTextColor,
                                                    fontSize:
                                                        multiDeviceSupport.h2),
                                              )
                                            : Text(
                                                'Location Selected',
                                                style: TextStyle(
                                                    color: colors.primaryColor),
                                              )),
                                    Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: IconButton(
                                            onPressed: () {
                                              Position position = locationHelper
                                                  .getLastKnownPositionAndUpdate();
                                              if (mounted) {
                                                setState(() {
                                                  markerPosition = LatLng(
                                                      position.latitude,
                                                      position.longitude);
                                                  _editedEvent = Event(
                                                    adminId:
                                                        _editedEvent.adminId,
                                                    averageDuration:
                                                        _editedEvent
                                                            .averageDuration,
                                                    averageLength: _editedEvent
                                                        .averageLength,
                                                    averagePaceMin: _editedEvent
                                                        .averagePaceMin,
                                                    averagePaceSec: _editedEvent
                                                        .averagePaceSec,
                                                    createdAt:
                                                        _editedEvent.createdAt,
                                                    currentParticipants:
                                                        _editedEvent
                                                            .currentParticipants,
                                                    date: _editedEvent.date,
                                                    difficultyLevel:
                                                        _editedEvent
                                                            .difficultyLevel,
                                                    id: _editedEvent.id,
                                                    maxParticipants:
                                                        _editedEvent
                                                            .maxParticipants,
                                                    name: _editedEvent.name,
                                                    startingPintLat:
                                                        markerPosition.latitude,
                                                    startingPintLong:
                                                        markerPosition
                                                            .longitude,
                                                  );
                                                });
                                              } else {}
                                            },
                                            icon: !widget._isSearching
                                                ? Icon(
                                                    Icons.location_on_outlined,
                                                    color: colors
                                                        .secondaryTextColor,
                                                  )
                                                : const CustomLoadingCircleIcon())),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: padding,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 0,
                          ),
                          child: Text(
                            'Length and duration: ',
                            style: TextStyle(
                                color: colors.primaryTextColor,
                                fontSize: multiDeviceSupport.h2),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 5,
                          ),
                          child: Text(
                            'Set how long the run is going to be and the time it will take',
                            style: TextStyle(
                                color: colors.secondaryTextColor,
                                fontSize: multiDeviceSupport.h4),
                          ),
                        ),
                        // Distance and Duration
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width /
                                    (2.5 + multiDeviceSupport.tablet * 0.3),
                                child: TextFormField(
                                  key: const Key("distance"),
                                  keyboardType: TextInputType.number,
                                  initialValue: '',
                                  cursorColor: colors.primaryTextColor,
                                  style:
                                      TextStyle(color: colors.primaryTextColor),
                                  decoration: textFormDecoration(
                                      'Distance (km)', context),
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context)
                                        .requestFocus(_durationFocusNode);
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please provide a value.';
                                    } else if (int.parse(value) > 200) {
                                      return 'Distance should be less than 200km.';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    if (value != null) {
                                      _editedEvent = Event(
                                        adminId: _editedEvent.adminId,
                                        averageDuration:
                                            _editedEvent.averageDuration,
                                        averageLength: int.parse(value),
                                        averagePaceMin:
                                            _editedEvent.averagePaceMin,
                                        averagePaceSec:
                                            _editedEvent.averagePaceSec,
                                        createdAt: _editedEvent.createdAt,
                                        currentParticipants:
                                            _editedEvent.currentParticipants,
                                        date: _editedEvent.date,
                                        difficultyLevel:
                                            _editedEvent.difficultyLevel,
                                        id: _editedEvent.id,
                                        maxParticipants:
                                            _editedEvent.maxParticipants,
                                        name: _editedEvent.name,
                                        startingPintLat:
                                            _editedEvent.startingPintLat,
                                        startingPintLong:
                                            _editedEvent.startingPintLong,
                                      );
                                    }
                                  },
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width /
                                    (2.5 + multiDeviceSupport.tablet * 0.3),
                                child: TextFormField(
                                  key: const Key("duration"),
                                  focusNode: _durationFocusNode,
                                  keyboardType: TextInputType.number,
                                  initialValue: '',
                                  cursorColor: colors.primaryTextColor,
                                  style:
                                      TextStyle(color: colors.primaryTextColor),
                                  decoration: textFormDecoration(
                                      'Duration (minutes)', context),
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context)
                                        .requestFocus(_participantsFocusNode);
                                  },
                                  validator: (value) {
                                    if (value?.length == 0) {
                                      return 'Please provide a value.';
                                    } else if (int.parse(value!) > 200) {
                                      return 'Duration should be less than 200 minutes.';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    if (value != null) {
                                      _editedEvent = Event(
                                        adminId: _editedEvent.adminId,
                                        averageDuration: int.parse(value),
                                        averageLength:
                                            _editedEvent.averageLength,
                                        averagePaceMin:
                                            _editedEvent.averagePaceMin,
                                        averagePaceSec:
                                            _editedEvent.averagePaceSec,
                                        createdAt: _editedEvent.createdAt,
                                        currentParticipants:
                                            _editedEvent.currentParticipants,
                                        date: _editedEvent.date,
                                        difficultyLevel:
                                            _editedEvent.difficultyLevel,
                                        id: _editedEvent.id,
                                        maxParticipants:
                                            _editedEvent.maxParticipants,
                                        name: _editedEvent.name,
                                        startingPintLat:
                                            _editedEvent.startingPintLat,
                                        startingPintLong:
                                            _editedEvent.startingPintLong,
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: padding,
                        ),
                        // PACE per ora non lo mettiamo, se non viene specificato il backend lo calcola automaticamente da distanza e km
                        // oppure posso fare il calcolo in addEvent dentro la classe event in provider se non gli arriva pace
                        // Padding(
                        //   padding: const EdgeInsets.only(
                        //     top: 10,
                        //     left: 20.0,
                        //     right: 20,
                        //   ),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       SizedBox(
                        //         width: MediaQuery.of(context).size.width / 2.3,
                        //         child: TextFormField(
                        //           keyboardType: TextInputType.number,
                        //           initialValue: '',
                        //           cursorColor: colors.primaryTextColor,
                        //           style: TextStyle(color: colors.primaryTextColor),
                        //           decoration:
                        //               textFormDecoration('Pace (mins/km)', context),
                        //           textInputAction: TextInputAction.next,
                        //           onFieldSubmitted: (_) {
                        //             FocusScope.of(context)
                        //                 .requestFocus(_durationFocusNode);
                        //           },
                        //           validator: (value) {
                        //             if (value?.length == 0) {
                        //               return 'Please provide a value.';
                        //             }
                        //             return null;
                        //           },
                        //           onSaved: (value) {
                        //             if (value != null) {
                        //               _editedEvent = Event(
                        //                 adminId: _editedEvent.adminId,
                        //                 averageDuration: _editedEvent.averageDuration,
                        //                 averageLength: _editedEvent.averageLength,
                        //                 averagePace: _editedEvent.averagePace,
                        //                 createdAt: _editedEvent.createdAt,
                        //                 currentParticipants:
                        //                     _editedEvent.currentParticipants,
                        //                 date: _editedEvent.date,
                        //                 difficultyLevel: _editedEvent.difficultyLevel,
                        //                 id: _editedEvent.id,
                        //                 maxParticipants: _editedEvent.maxParticipants,
                        //                 name: _editedEvent.name,
                        //                 startingPintLat: _editedEvent.startingPintLat,
                        //                 startingPintLong: _editedEvent.startingPintLong,
                        //               );
                        //             }
                        //           },
                        //         ),
                        //       ),

                        Padding(
                          padding: const EdgeInsets.only(
                            top: 5,
                          ),
                          child: Text(
                            'Participants: ',
                            style: TextStyle(
                                color: colors.primaryTextColor,
                                fontSize: multiDeviceSupport.h2),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 5,
                          ),
                          child: Text(
                            'Depending on the location, set the maximum number of participants',
                            style: TextStyle(
                                color: colors.secondaryTextColor,
                                fontSize: multiDeviceSupport.h4),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width /
                                    (2.5 + multiDeviceSupport.tablet * 0.3),
                                child: TextFormField(
                                  // focusNode: _durationFocusNode,
                                  keyboardType: TextInputType.number,
                                  initialValue: '',
                                  cursorColor: colors.primaryTextColor,
                                  style:
                                      TextStyle(color: colors.primaryTextColor),
                                  decoration: textFormDecoration(
                                      'Max participants', context),
                                  textInputAction: TextInputAction.next,

                                  validator: (value) {
                                    if (value?.length == 0) {
                                      return 'Please provide a value.';
                                    } else if (int.tryParse(value!)! > 200) {
                                      return 'Max participants allowed is 200';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    if (value != null) {
                                      _editedEvent = Event(
                                        adminId: _editedEvent.adminId,
                                        averageDuration:
                                            _editedEvent.averageDuration,
                                        averageLength:
                                            _editedEvent.averageLength,
                                        averagePaceMin:
                                            _editedEvent.averagePaceMin,
                                        averagePaceSec:
                                            _editedEvent.averagePaceSec,
                                        createdAt: _editedEvent.createdAt,
                                        currentParticipants:
                                            _editedEvent.currentParticipants,
                                        date: _editedEvent.date,
                                        difficultyLevel:
                                            _editedEvent.difficultyLevel,
                                        id: _editedEvent.id,
                                        maxParticipants: int.parse(value),
                                        name: _editedEvent.name,
                                        startingPintLat:
                                            _editedEvent.startingPintLat,
                                        startingPintLong:
                                            _editedEvent.startingPintLong,
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: padding,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                          ),
                          child: Container(
                            // width: 70,
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  backgroundColor: colors.primaryColor,
                                  primary: colors.onPrimary,
                                  textStyle: TextStyle(
                                      fontSize: multiDeviceSupport.h2),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 10)),
                              onPressed: _saveForm,
                              child: const Text('Create'),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: padding,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
    } else {
      return const PermissionMessage();
    }
  }
}

class AddEventAppbar extends StatelessWidget {
  const AddEventAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    final colors = Provider.of<CustomColorScheme>(context);
    PageIndex index = Provider.of<PageIndex>(context);
    var multiDeviceSupport = MultiDeviceSupport(context);
    multiDeviceSupport.init();
    // print(statusBarHeight);
    return GradientAppBar(
        // ((MediaQuery.of(context).size.height / 14) + statusBarHeight), [
        (75 + statusBarHeight + multiDeviceSupport.tablet * 50),
        [
          Padding(
            padding: EdgeInsets.only(
                top: statusBarHeight + multiDeviceSupport.tablet * 25),
            child: Center(
              child: Text(
                'Add new Event',
                style: TextStyle(
                    color: colors.titleColor,
                    fontSize: multiDeviceSupport.title,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ]);
  }
}
