// ignore_for_file: unnecessary_const

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:runwithme/widgets/custom_map_search.dart';
import 'package:runwithme/widgets/custom_maps_new.dart';
import 'package:runwithme/widgets/search_event_bottomsheet.dart';

import '../widgets/search_button.dart';
import '../dummy_data/dummy_events.dart';
import '../widgets/event_card_text_only.dart';
import '../themes/custom_colors.dart';
import '../themes/custom_theme.dart';
import '../widgets/gradientAppbar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../providers/color_scheme.dart';
import '../providers/event.dart';
import '../providers/events.dart';
import 'package:provider/provider.dart';
import '../providers/page_index.dart';
import '../widgets/custom_loading_icon.dart';

class AddEventScreen extends StatefulWidget {
  static const routeName = '/add_event';

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _form = GlobalKey<FormState>();
  final _nameFocusNode = FocusNode();
  final _distanceFocusNode = FocusNode();
  final _durationFocusNode = FocusNode();
  var _isLoading = false;

  LatLng defaultUserPos = const LatLng(44.48867812986885, 6.197411131341138);
  LatLng markerPosition = const LatLng(0, 0);

  DateTime _userSelectedDate = DateTime.now();

  static const double padding = 50;
  var _editedEvent = Event(
    adminId: 0,
    averageDuration: 0,
    averageLength: 0,
    averagePace: 0,
    createdAt: DateTime.now().toString(),
    currentParticipants: 0,
    date: DateTime.now().toString(),
    difficultyLevel: 0,
    maxParticipants: 0,
    name: '',
    startingPintLat: 0,
    startingPintLong: 0,
    id: null,
  );
  final _initValues = {
    'name': '',
    'date': '',
    'price': '',
    'imageUrl': '',
  };

  Future<Position> _getLocation() async {
    var currentLocation;
    LocationPermission permission = await Geolocator.checkPermission();
    print('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA     ' +
        permission.toString());
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }
    // sleep(const Duration(seconds: 2));
    try {
      currentLocation = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      _isLoading = false;
      return Position(
          longitude: defaultUserPos.longitude,
          latitude: defaultUserPos.latitude,
          timestamp: DateTime(2021),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0);
    }
    _isLoading = false;
    return currentLocation;
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
          averagePace: _editedEvent.averagePace,
          createdAt: _editedEvent.createdAt,
          currentParticipants: _editedEvent.currentParticipants,
          date: pickedDate.toString(),
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

  TimeOfDay _time = const TimeOfDay(hour: 7, minute: 15);

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
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
        // _editedEvent = Event(
        //   adminId: _editedEvent.adminId,
        //   averageDuration: _editedEvent.averageDuration,
        //   averageLength: _editedEvent.averageLength,
        //   averagePace: _editedEvent.averagePace,
        //   createdAt: _editedEvent.createdAt,
        //   currentParticipants: _editedEvent.currentParticipants,
        //   date: _editedEvent.date,
        //   difficultyLevel: _editedEvent.difficultyLevel,
        //   id: _editedEvent.id,
        //   maxParticipants: _editedEvent.maxParticipants,
        //   name: _editedEvent.name,
        //   startingPintLat: _editedEvent.startingPintLat,
        //   startingPintLong: _editedEvent.startingPintLong,
        // );
      });
    }
  }

  Future<void> _saveForm() async {
    final pageIndex = Provider.of<PageIndex>(context, listen: false);

    final isValid = _form.currentState?.validate();
    if (isValid == null || !isValid) {
      return;
    }
    _form.currentState?.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedEvent.id != null) {
      // await Provider.of<Events>(context, listen: false)
      //     .updateProduct(_editedEvent.id, _editedEvent);
      print("Here I should edit the Event");
    } else {
      try {
        await Provider.of<Events>(context, listen: false)
            .addEvent(_editedEvent);
      } catch (error) {
        print(error);
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
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

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _distanceFocusNode.dispose();
    _durationFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Provider.of<CustomColorScheme>(context);

    return _isLoading
        ? Center(
            child: Builder(builder: (context) {
              return const CustomLoadingIcon();
            }),
          )
        : Padding(
            padding: const EdgeInsets.only(
              top: 10,
              left: 20.0,
              right: 20,
            ),
            child: Form(
              key: _form,
              child: ListView(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Write event informations here",
                            style: TextStyle(color: colors.primaryTextColor),
                          ),
                          Icon(
                            Icons.info_outlined,
                            color: colors.secondaryTextColor,
                          )
                        ],
                      ),
                    ),
                    height: 70,
                  ),
                  // Name
                  TextFormField(
                    initialValue: _initValues['name'],
                    cursorColor: colors.primaryTextColor,
                    style: TextStyle(color: colors.primaryTextColor),
                    decoration: textFormDecoration('Name', context),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_nameFocusNode);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please provide a value.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _editedEvent = Event(
                        adminId: _editedEvent.adminId,
                        averageDuration: _editedEvent.averageDuration,
                        averageLength: _editedEvent.averageLength,
                        averagePace: _editedEvent.averagePace,
                        createdAt: _editedEvent.createdAt,
                        currentParticipants: _editedEvent.currentParticipants,
                        date: _editedEvent.date,
                        difficultyLevel: _editedEvent.difficultyLevel,
                        id: _editedEvent.id,
                        maxParticipants: _editedEvent.maxParticipants,
                        name: _editedEvent.name,
                        startingPintLat: _editedEvent.startingPintLat,
                        startingPintLong: _editedEvent.startingPintLong,
                      );
                    },
                  ),
                  const SizedBox(
                    height: padding,
                  ),
                  // Date and Time
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: _presentDatePicker,
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2.3,
                          decoration: BoxDecoration(
                            color: colors.onPrimary,
                            border:
                                Border.all(color: colors.secondaryTextColor),
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
                                        color: colors.primaryTextColor),
                                  ),
                                ),
                                Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Icon(
                                      Icons.calendar_today_outlined,
                                      color: colors.primaryColor,
                                    ))
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: _selectTime,
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2.3,
                          decoration: BoxDecoration(
                            color: colors.onPrimary,
                            border:
                                Border.all(color: colors.secondaryTextColor),
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
                                        color: colors.primaryTextColor),
                                  ),
                                ),
                                Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Icon(
                                      Icons.watch_later_outlined,
                                      color: colors.primaryColor,
                                    ))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: padding,
                  ),

                  TextFormField(
                    key: Key(markerPosition.toString()), //
                    onTap: () {
                      _isLoading = true;
                      _getLocation().then((value) async {
                        var a = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CustomMapsNew(
                                    markerPosition: markerPosition,
                                    centerPosition:
                                        markerPosition == LatLng(0, 0)
                                            ? LatLng(
                                                value.latitude, value.longitude)
                                            : markerPosition,
                                  )),
                        );
                        setState(() {
                          if (a != null) {
                            markerPosition = a;
                          }
                        });
                      });
                    },
                    // initialValue: markerPosition.toString(),

                    readOnly: true,
                    cursorColor: colors.primaryTextColor,
                    style: TextStyle(color: colors.primaryTextColor),
                    decoration: textFormDecoration('Position', context),
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_nameFocusNode);
                    },
                    validator: (value) {
                      if (markerPosition == LatLng(0, 0)) {
                        return 'Please provide a value.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _editedEvent = Event(
                        adminId: _editedEvent.adminId,
                        averageDuration: _editedEvent.averageDuration,
                        averageLength: _editedEvent.averageLength,
                        averagePace: _editedEvent.averagePace,
                        createdAt: _editedEvent.createdAt,
                        currentParticipants: _editedEvent.currentParticipants,
                        date: _editedEvent.date,
                        difficultyLevel: _editedEvent.difficultyLevel,
                        id: _editedEvent.id,
                        maxParticipants: _editedEvent.maxParticipants,
                        name: _editedEvent.name,
                        startingPintLat: markerPosition.latitude,
                        startingPintLong: markerPosition.longitude,
                      );
                    },
                  ),
                  const SizedBox(
                    height: padding,
                  ),
                  // Distance and Duration
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 2.3,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          initialValue: '',
                          cursorColor: colors.primaryTextColor,
                          style: TextStyle(color: colors.primaryTextColor),
                          decoration:
                              textFormDecoration('Distance (km)', context),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_durationFocusNode);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please provide a value.';
                            } else if (int.parse(value) > 100) {
                              return 'Distance should be less than 100km.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            if (value != null) {
                              _editedEvent = Event(
                                adminId: _editedEvent.adminId,
                                averageDuration: _editedEvent.averageDuration,
                                averageLength: int.parse(value),
                                averagePace: _editedEvent.averagePace,
                                createdAt: _editedEvent.createdAt,
                                currentParticipants:
                                    _editedEvent.currentParticipants,
                                date: _editedEvent.date,
                                difficultyLevel: _editedEvent.difficultyLevel,
                                id: _editedEvent.id,
                                maxParticipants: _editedEvent.maxParticipants,
                                name: _editedEvent.name,
                                startingPintLat: _editedEvent.startingPintLat,
                                startingPintLong: _editedEvent.startingPintLong,
                              );
                            }
                          },
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.3,
                        child: TextFormField(
                          focusNode: _durationFocusNode,
                          keyboardType: TextInputType.number,
                          initialValue: '',
                          cursorColor: colors.primaryTextColor,
                          style: TextStyle(color: colors.primaryTextColor),
                          decoration:
                              textFormDecoration('Duration (minutes)', context),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_nameFocusNode);
                          },
                          validator: (value) {
                            if (value?.length == 0) {
                              return 'Please provide a value.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            if (value != null) {
                              _editedEvent = Event(
                                adminId: _editedEvent.adminId,
                                averageDuration: int.parse(value),
                                averageLength: _editedEvent.averageLength,
                                averagePace: _editedEvent.averagePace,
                                createdAt: _editedEvent.createdAt,
                                currentParticipants:
                                    _editedEvent.currentParticipants,
                                date: _editedEvent.date,
                                difficultyLevel: _editedEvent.difficultyLevel,
                                id: _editedEvent.id,
                                maxParticipants: _editedEvent.maxParticipants,
                                name: _editedEvent.name,
                                startingPintLat: _editedEvent.startingPintLat,
                                startingPintLong: _editedEvent.startingPintLong,
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: padding,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.3,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          initialValue: '',
                          cursorColor: colors.primaryTextColor,
                          style: TextStyle(color: colors.primaryTextColor),
                          decoration:
                              textFormDecoration('Pace (mins/km)', context),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_durationFocusNode);
                          },
                          validator: (value) {
                            if (value?.length == 0) {
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
                                averagePace: _editedEvent.averagePace,
                                createdAt: _editedEvent.createdAt,
                                currentParticipants:
                                    _editedEvent.currentParticipants,
                                date: _editedEvent.date,
                                difficultyLevel: _editedEvent.difficultyLevel,
                                id: _editedEvent.id,
                                maxParticipants: _editedEvent.maxParticipants,
                                name: _editedEvent.name,
                                startingPintLat: _editedEvent.startingPintLat,
                                startingPintLong: _editedEvent.startingPintLong,
                              );
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.3,
                        child: TextFormField(
                          // focusNode: _durationFocusNode,
                          keyboardType: TextInputType.number,
                          initialValue: '',
                          cursorColor: colors.primaryTextColor,
                          style: TextStyle(color: colors.primaryTextColor),
                          decoration:
                              textFormDecoration('Max participants', context),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_nameFocusNode);
                          },
                          validator: (value) {
                            if (value?.length == 0) {
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
                                averagePace: _editedEvent.averagePace,
                                createdAt: _editedEvent.createdAt,
                                currentParticipants:
                                    _editedEvent.currentParticipants,
                                date: _editedEvent.date,
                                difficultyLevel: _editedEvent.difficultyLevel,
                                id: _editedEvent.id,
                                maxParticipants: _editedEvent.maxParticipants,
                                name: _editedEvent.name,
                                startingPintLat: _editedEvent.startingPintLat,
                                startingPintLong: _editedEvent.startingPintLong,
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: padding,
                  ),
                  Container(
                    width: 70,
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: colors.primaryColor,
                          primary: colors.onPrimary,
                          textStyle: const TextStyle(fontSize: 16),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10)),
                      onPressed: _saveForm,
                      child: const Text('Create'),
                    ),
                  ),
                  const SizedBox(
                    height: padding,
                  ),
                ],
              ),
            ),
          );
  }
}

class AddEventAppbar extends StatelessWidget {
  const AddEventAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    final colors = Provider.of<CustomColorScheme>(context);

    return GradientAppBar(
        ((MediaQuery.of(context).size.height / 16) + statusBarHeight), [
      Padding(
        padding: EdgeInsets.only(top: statusBarHeight),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(
                Icons.replay_outlined,
                color: colors.onPrimary,
              ),
              onPressed: () => {},
            ),
            Center(
              heightFactor: 0.5,
              child: Text(
                'Add new Event',
                style: TextStyle(
                    color: colors.onPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Icon(
              Icons.save,
              color: colors.onPrimary,
            ),
          ],
        ),
      ),
    ]);
  }
}
