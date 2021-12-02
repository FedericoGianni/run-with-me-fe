// ignore_for_file: unnecessary_const

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
  final _isLoading = false;
  LatLng pos = const LatLng(45.48867812986885, 9.197411131341138);

  DateTime _userSelectedDate = DateTime.now();

  static const double padding = 50;

  final _initValues = {
    'name': '',
    'date': '',
    'price': '',
    'imageUrl': '',
  };

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            splashColor: primaryTextColor,
            textTheme: const TextTheme(
              subtitle1: TextStyle(color: primaryTextColor),
              button: TextStyle(color: primaryTextColor),
            ),
            accentColor: primaryTextColor,
            colorScheme: const ColorScheme.light(
              primary: primaryColor,
              onPrimary: onPrimary,
              onSurface: primaryTextColor,
            ),
            dialogBackgroundColor: onPrimary,
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
      });
    });
  }

  TimeOfDay _time = const TimeOfDay(hour: 7, minute: 15);

  void _selectTime() async {
    TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _time,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            splashColor: primaryTextColor,
            textTheme: const TextTheme(
              subtitle1: TextStyle(color: primaryTextColor),
              button: TextStyle(color: primaryTextColor),
            ),
            accentColor: primaryTextColor,
            colorScheme: const ColorScheme.light(
              primary: primaryColor,
              onPrimary: onPrimary,
              onSurface: primaryTextColor,
            ),
            dialogBackgroundColor: onPrimary,
          ),
          child: child ?? const Text(""),
        );
      },
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
      });
    }
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
    print("\n\nPOS: " + pos.toString());
    return _isLoading
        ? Center(
            child: Builder(builder: (context) {
              return const CircularProgressIndicator();
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
                        children: const [
                          Text(
                            "Write event informations here",
                            style: TextStyle(color: secondaryTextColor),
                          ),
                          Icon(
                            Icons.info_outlined,
                            color: secondaryTextColor,
                          )
                        ],
                      ),
                    ),
                    height: 70,
                  ),
                  // Name
                  TextFormField(
                    initialValue: _initValues['name'],
                    cursorColor: primaryTextColor,
                    style: const TextStyle(color: primaryTextColor),
                    decoration: textFormDecoration('Name'),
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
                      // _editedProduct = Product(
                      //     title: value,
                      //     price: _editedProduct.price,
                      //     description: _editedProduct.description,
                      //     imageUrl: _editedProduct.imageUrl,
                      //     id: _editedProduct.id,
                      //     isFavorite: _editedProduct.isFavorite);
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
                            color: onPrimary,
                            border: Border.all(color: secondaryTextColor),
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
                                    style: const TextStyle(
                                        color: primaryTextColor),
                                  ),
                                ),
                                Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: const Icon(
                                      Icons.calendar_today_outlined,
                                      color: primaryColor,
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
                            color: onPrimary,
                            border: Border.all(color: secondaryTextColor),
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
                                    style: const TextStyle(
                                        color: primaryTextColor),
                                  ),
                                ),
                                Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: const Icon(
                                      Icons.watch_later_outlined,
                                      color: primaryColor,
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
                  // Position
                  // GestureDetector(
                  //   onTap: () async {
                  //     setState(() {
                  //       var markerPosition = Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) => CustomMapsNew()),
                  //       );
                  //     });
                  //   },
                  //   child: Container(
                  //     height: 60,

                  //     width: MediaQuery.of(context).size.width / 1.5,
                  //     padding: const EdgeInsets.only(left: 25),

                  //     decoration: BoxDecoration(
                  //       color: onPrimary,
                  //       border: Border.all(color: secondaryTextColor),
                  //       // set border width
                  //       borderRadius: BorderRadius.all(
                  //         Radius.circular(10.0),
                  //       ), // set rounded corner radius
                  //     ),
                  //     // set rounded corner radius
                  //     child: Row(
                  //       children: [
                  //         const Icon(
                  //           Icons.search,
                  //           color: secondaryTextColor,
                  //         ),
                  //         markerPosition
                  //             ? Text(markerPosition.toString())
                  //             : Text('abbabba'),

                  //         // style: TextStyle(color: secondaryTextColor),
                  //         // )
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  TextFormField(
                    key: Key(pos.toString()), //
                    onTap: () async {
                      var a = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CustomMapsNew(
                                  position: pos,
                                )),
                      );
                      setState(() {
                        if (a != null) {
                          pos = a;
                        }
                      });
                    },
                    initialValue: pos.toString(),
                    readOnly: true,
                    cursorColor: primaryTextColor,
                    style: const TextStyle(color: primaryTextColor),
                    decoration: textFormDecoration('Name'),
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
                      // _editedProduct = Product(
                      //     title: value,
                      //     price: _editedProduct.price,
                      //     description: _editedProduct.description,
                      //     imageUrl: _editedProduct.imageUrl,
                      //     id: _editedProduct.id,
                      //     isFavorite: _editedProduct.isFavorite);
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
                          cursorColor: primaryTextColor,
                          style: const TextStyle(color: primaryTextColor),
                          decoration: textFormDecoration('Distance (km)'),
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
                            // _editedProduct = Product(
                            //     title: value,
                            //     price: _editedProduct.price,
                            //     description: _editedProduct.description,
                            //     imageUrl: _editedProduct.imageUrl,
                            //     id: _editedProduct.id,
                            //     isFavorite: _editedProduct.isFavorite);
                          },
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.3,
                        child: TextFormField(
                          focusNode: _durationFocusNode,
                          keyboardType: TextInputType.number,
                          initialValue: '',
                          cursorColor: primaryTextColor,
                          style: const TextStyle(color: primaryTextColor),
                          decoration: textFormDecoration('Duration (minutes)'),
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
                            // _editedProduct = Product(
                            //     title: value,
                            //     price: _editedProduct.price,
                            //     description: _editedProduct.description,
                            //     imageUrl: _editedProduct.imageUrl,
                            //     id: _editedProduct.id,
                            //     isFavorite: _editedProduct.isFavorite);
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
                          cursorColor: primaryTextColor,
                          style: const TextStyle(color: primaryTextColor),
                          decoration: textFormDecoration('Pace (mins/km)'),
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
                            // _editedProduct = Product(
                            //     title: value,
                            //     price: _editedProduct.price,
                            //     description: _editedProduct.description,
                            //     imageUrl: _editedProduct.imageUrl,
                            //     id: _editedProduct.id,
                            //     isFavorite: _editedProduct.isFavorite);
                          },
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.3,
                        child: TextFormField(
                          // focusNode: _durationFocusNode,
                          keyboardType: TextInputType.number,
                          initialValue: '',
                          cursorColor: primaryTextColor,
                          style: const TextStyle(color: primaryTextColor),
                          decoration: textFormDecoration('Max participants'),
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
                            // _editedProduct = Product(
                            //     title: value,
                            //     price: _editedProduct.price,
                            //     description: _editedProduct.description,
                            //     imageUrl: _editedProduct.imageUrl,
                            //     id: _editedProduct.id,
                            //     isFavorite: _editedProduct.isFavorite);
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
                          backgroundColor: primaryColor,
                          primary: onPrimary,
                          textStyle: const TextStyle(fontSize: 16),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10)),
                      onPressed: () => {},
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
    return GradientAppBar(
        ((MediaQuery.of(context).size.height / 16) + statusBarHeight), [
      Padding(
        padding: EdgeInsets.only(top: statusBarHeight),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(
                Icons.replay_outlined,
                color: onPrimary,
              ),
              onPressed: () => {},
            ),
            const Center(
              heightFactor: 0.5,
              child: const Text(
                'Add new Event',
                style: const TextStyle(
                    color: onPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const Icon(
              Icons.save,
              color: onPrimary,
            ),
          ],
        ),
      ),
    ]);
  }
}
