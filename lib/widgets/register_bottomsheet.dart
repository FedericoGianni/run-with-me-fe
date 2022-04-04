import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:runwithme/widgets/custom_scroll_behavior.dart';
import '../classes/multi_device_support.dart';
import '../providers/settings_manager.dart';
import '../themes/custom_colors.dart';
import '../providers/color_scheme.dart';
import 'package:provider/provider.dart';
import '../themes/custom_theme.dart';
import '../providers/user.dart';
import 'custom_alert_dialog.dart';
import 'custom_loading_circle_icon.dart';
import 'custom_map_place_search.dart';
import 'custom_options_dialog.dart';
import 'custom_slider.dart';

class SubscribeBottomSheet extends StatefulWidget {
  const SubscribeBottomSheet({Key? key}) : super(key: key);

  @override
  State<SubscribeBottomSheet> createState() => SubscribeBottomSheetState();
}

@visibleForTesting
class SubscribeBottomSheetState extends State<SubscribeBottomSheet> {
  final _form = GlobalKey<FormState>();
  int _pageIndex = 0;
  final _emailFocusNode = FocusNode();
  final _pwd1FocusNode = FocusNode();
  final _pwd2FocusNode = FocusNode();
  final _surnameFocusNode = FocusNode();
  final _heightFocusNode = FocusNode();
  final _ageFocusNode = FocusNode();
  final _durationFocusNode = FocusNode();
  final _distanceFocusNode = FocusNode();
  bool _isLoading = false;
  var snackBar;
  var _controller = TextEditingController();

  Icon eyeIcon = const Icon(
    Icons.remove_red_eye,
  );
  static const double padding = 40;
  bool isTextObsured = true;

  int get pageIndex {
    return _pageIndex;
  }

  List _sexCodes = ["Not specified", 'Male', 'Female'];
  List _fitCodes = ['Very unfit', 'Unfit', 'Average', 'Just fit', 'Very fit'];

  final _initValues = {
    'username': '',
    'password': '',
    'email': '',
    'password2': '',
    'name': '',
    'surname': '',
    'height': '',
    'age': '',
    'sex': '-1',
    'city_id': '',
    'city_name': '',
    'frequency': '',
    'duration': '',
    'distance': '',
    'fitness': '-1',
    'fitnessTotalValue': '-1',
  };

  @visibleForTesting
  Map<String, String> get initValues {
    return _initValues;
  }

  @visibleForTesting
  GlobalKey<FormState> get formState {
    return _form;
  }

  void _togglePwdText() {
    setState(() {
      isTextObsured = !isTextObsured;
      if (!isTextObsured) {
        eyeIcon = const Icon(
          Icons.remove_red_eye_outlined,
        );
      } else {
        eyeIcon = const Icon(
          Icons.remove_red_eye,
        );
      }
    });
  }

  void _upPageIndex() {
    print("upPageIndex");
    setState(() {
      final isValid = _form.currentState?.validate();
      if (isValid == null || !isValid) {
        return;
      }
      _form.currentState?.save();
      _pageIndex += 1;
      print(_initValues);
    });
  }

  void _downPageIndex() {
    setState(() {
      _pageIndex = _pageIndex - 1;
    });
  }

  @override
  void dispose() {
    print("DISPOSE");
    _emailFocusNode.dispose();
    _pwd1FocusNode.dispose();
    _pwd2FocusNode.dispose();
    _surnameFocusNode.dispose();
    _ageFocusNode.dispose();
    _heightFocusNode.dispose();
    // _ageFocusNode.dispose();
    // TODO: DISPOSE OF OTHER FOCUS NODES!!!!
    super.dispose();
  }

  Future<void> _showPlacesDialog() async {
    print("hey");
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return CustomMapPlaceSearch();
      },
    ).then((value) {
      _initValues['city_name'] = value['name'].toString();
      _initValues['city_id'] = value['place_id'].toString();
      setState(() {
        //print("bellazio");
        print(_initValues.keys);
      });
    });
  }

  Future<void> _showSexDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return CustomOptionsDialog(
          options: _sexCodes.reversed.toList(),
        );
      },
    ).then((value) {
      if (value != null) {
        setState(() {
          _initValues['sex'] = (_sexCodes.length - 1 - value).toString();
        });
      }
    });
  }

  Future<void> _showFitnessDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return CustomOptionsDialog(
          options: _fitCodes.reversed.toList(),
        );
      },
    ).then((value) {
      if (value != null) {
        setState(() {
          _initValues['fitness'] = (_fitCodes.length - 1 - value).toString();
        });
      }
    });
  }

  Future<void> _saveForm() async {
    // final pageIndex = Provider.of<PageIndex>(context, listen: false);
    final colors = Provider.of<CustomColorScheme>(context, listen: false);
    final double screenWidth = MediaQuery.of(context).size.width;
    var settings = Provider.of<UserSettings>(context, listen: false);
    var multiDeviceSupport = MultiDeviceSupport(context);
    multiDeviceSupport.init();
    final user = Provider.of<User>(context, listen: false);
    settings.setUser(user);
    final isValid = _form.currentState?.validate();

    if (isValid == null || !isValid) {
      print("Returning");
      return;
    }
    setState(() {
      _isLoading = true;
    });
    _form.currentState?.save();
    print("Signing up User");

    List registerResult = await user.register(
        _initValues['username'], _initValues['email'], _initValues['password']);
    if (registerResult[0]) {
      List loginResult = await settings.userLogin(
          _initValues['username'], _initValues['password']);
      if (loginResult[0]) {
        user.age = int.parse(_initValues['age']!);
        user.surname = _initValues['surname'];
        user.name = _initValues['name'];
        user.cityId = _initValues['city_id'];
        user.fitnessLevel = double.parse(_initValues['fitness'] ?? '-1');
        user.height = int.parse(_initValues['height']!);
        user.sex = int.parse(_initValues['sex'] ?? '-1');

        bool updateResult = await user.updateUser();
        if (updateResult) {
          snackBar = SnackBar(
            content: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      registerResult[1],
                      style: TextStyle(
                          color: colors.primaryTextColor,
                          fontSize: multiDeviceSupport.h3,
                          overflow: TextOverflow.fade),
                    ),
                  ),
                ],
              ),
              margin: EdgeInsets.symmetric(
                  horizontal: multiDeviceSupport.columnPadding),
              // width: 20,

              padding: const EdgeInsets.all(10),

              decoration: BoxDecoration(
                  color: colors.background,
                  border: Border.all(
                    color: registerResult[0]
                        ? colors.primaryColor
                        : colors.errorColor,
                    width: 1,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(15))),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
            padding: const EdgeInsets.only(bottom: 40),
          );
          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(snackBar);
          sleep(const Duration(seconds: 1));
          setState(() {
            _isLoading = false;
            Navigator.pop(context);
          });
        }
      }
    } else {
      snackBar = SnackBar(
        content: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                child: Text(
                  "Register did not complete",
                  style: TextStyle(
                      color: colors.primaryTextColor,
                      fontSize: multiDeviceSupport.h3,
                      overflow: TextOverflow.fade),
                ),
              ),
            ],
          ),
          margin: EdgeInsets.symmetric(
              horizontal: multiDeviceSupport.columnPadding),
          // width: 20,

          padding: const EdgeInsets.all(10),

          decoration: BoxDecoration(
              color: colors.background,
              border: Border.all(
                color:
                    registerResult[0] ? colors.primaryColor : colors.errorColor,
                width: 1,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(15))),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        padding: const EdgeInsets.only(bottom: 40),
      );
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(snackBar);
      sleep(const Duration(seconds: 1));
      setState(() {
        _isLoading = false;
        Navigator.pop(context);
      });
      print("Register not completed");
    }
  }

  List<Widget> subscribeFormPage1(BuildContext context) {
    final colors = Provider.of<CustomColorScheme>(context);
    final double screenWidth = MediaQuery.of(context).size.width;
    var multiDeviceSupport = MultiDeviceSupport(context);
    multiDeviceSupport.init();

    return [
      // Padding(
      //   padding: EdgeInsets.only(
      //     left: multiDeviceSupport.columnPadding,
      //     right: multiDeviceSupport.columnPadding,
      //     bottom: 10,
      //   ),
      //   child: Text(
      //     'Username: ',
      //     style: TextStyle(
      //         color: colors.primaryTextColor, fontSize: multiDeviceSupport.h2),
      //   ),
      // ),

      // Username
      Padding(
        padding: EdgeInsets.only(
          left: multiDeviceSupport.columnPadding,
          right: multiDeviceSupport.columnPadding,
          bottom: 10,
        ),
        child: Text(
          'Give yourself a nice username',
          style: TextStyle(
              color: colors.secondaryTextColor,
              fontSize: multiDeviceSupport.h3),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
            left: multiDeviceSupport.columnPadding,
            right: multiDeviceSupport.columnPadding,
            bottom: padding),
        child: TextFormField(
          key: Key('username'),

          // focusNode: _ageFocusNode,
          initialValue: _initValues['username'],
          cursorColor: colors.primaryTextColor,
          style: TextStyle(
            color: colors.primaryTextColor,
            fontSize: multiDeviceSupport.h2,
          ),
          decoration: textFormDecoration('Username', context),
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(_emailFocusNode);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please provide a value.';
            }
            return null;
          },
          onSaved: (value) {
            _initValues['username'] = value!;
          },
        ),
      ),
      // Email
      Padding(
        padding: EdgeInsets.only(
          left: multiDeviceSupport.columnPadding,
          right: multiDeviceSupport.columnPadding,
          bottom: 10,
        ),
        child: Text(
          'Here you should write your email',
          style: TextStyle(
              color: colors.secondaryTextColor,
              fontSize: multiDeviceSupport.h3),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
            left: multiDeviceSupport.columnPadding,
            right: multiDeviceSupport.columnPadding,
            bottom: padding),
        child: TextFormField(
          key: const Key('email'),
          focusNode: _emailFocusNode,
          initialValue: _initValues['email'],
          cursorColor: colors.primaryTextColor,
          style: TextStyle(
            color: colors.primaryTextColor,
            fontSize: multiDeviceSupport.h2,
          ),
          decoration: textFormDecoration('Email', context),
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(_pwd1FocusNode);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please provide a value.';
            } else if (!RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(value)) {
              return ' Please provide a valid email';
            }
            return null;
          },
          onSaved: (value) {
            _initValues['email'] = value!;
          },
        ),
      ),
      // Password
      Padding(
        padding: EdgeInsets.only(
          left: multiDeviceSupport.columnPadding,
          right: multiDeviceSupport.columnPadding,
          bottom: 10,
        ),
        child: Text(
          'Write a strong password',
          style: TextStyle(
              color: colors.secondaryTextColor,
              fontSize: multiDeviceSupport.h3),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
            left: multiDeviceSupport.columnPadding,
            right: multiDeviceSupport.columnPadding),
        child: TextFormField(
          key: const Key('password'),
          focusNode: _pwd1FocusNode,
          initialValue: _initValues['password'],
          obscureText: isTextObsured,
          cursorColor: colors.primaryTextColor,
          style: TextStyle(
            color: colors.primaryTextColor,
            fontSize: multiDeviceSupport.h2,
          ),
          decoration: passwordFormDecoration(
              'Password', eyeIcon, _togglePwdText, context),
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(_pwd2FocusNode);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please provide a value.';
            }
            return null;
          },
          onChanged: (value) {
            setState(() {
              _initValues['password'] = value;
            });
          },
        ),
      ),
      // Password 2
      Padding(
        padding: EdgeInsets.only(
          top: padding,
          left: multiDeviceSupport.columnPadding,
          right: multiDeviceSupport.columnPadding,
          bottom: 10,
        ),
        child: Text(
          'Write it again just to be sure',
          style: TextStyle(
              color: colors.secondaryTextColor,
              fontSize: multiDeviceSupport.h3),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
          left: multiDeviceSupport.columnPadding,
          right: multiDeviceSupport.columnPadding,
          bottom: padding,
        ),
        child: TextFormField(
          key: const Key('password2'),
          focusNode: _pwd2FocusNode,
          initialValue: _initValues['password2'],
          obscureText: isTextObsured,
          cursorColor: colors.primaryTextColor,
          style: TextStyle(
            color: colors.primaryTextColor,
            fontSize: multiDeviceSupport.h2,
          ),
          decoration: passwordFormDecoration(
              'Repeat password', eyeIcon, _togglePwdText, context),
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) {},
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please provide a value.';
            } else if (value != _initValues['password']) {
              print(_initValues);
              return 'Passwords must be identical.';
            }
            return null;
          },
          onChanged: (value) {
            _initValues['password2'] = value;
          },
          // onSaved: (value) {
          //   _initValues['password2'] = value!;
          // },
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
          left: multiDeviceSupport.columnPadding,
          right: multiDeviceSupport.columnPadding,
        ),
        child: Container(
          width: 70,
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                key: const Key("next1"),
                style: TextButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    backgroundColor: colors.primaryColor,
                    primary: colors.onPrimary,
                    textStyle: TextStyle(
                      fontSize: multiDeviceSupport.h2,
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10)),
                onPressed: _upPageIndex,
                child: const Text('Next'),
              ),
            ],
          ),
        ),
      ),
    ];
  }

  List<Widget> subscribeFormPage2(BuildContext context) {
    final colors = Provider.of<CustomColorScheme>(context);
    final double screenWidth = MediaQuery.of(context).size.width;
    var multiDeviceSupport = MultiDeviceSupport(context);
    multiDeviceSupport.init();

    return [
      // Name
      Padding(
        padding: EdgeInsets.only(
            left: multiDeviceSupport.columnPadding,
            right: multiDeviceSupport.columnPadding,
            bottom: 10),
        child: Text(
          "What is your name:",
          style: TextStyle(
              color: colors.secondaryTextColor,
              fontSize: multiDeviceSupport.h3),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
            left: multiDeviceSupport.columnPadding,
            right: multiDeviceSupport.columnPadding,
            bottom: padding),
        child: TextFormField(
          key: const Key('name'),
          autofocus: false,
          initialValue: _initValues['name'],
          cursorColor: colors.primaryTextColor,
          style: TextStyle(
              color: colors.primaryTextColor, fontSize: multiDeviceSupport.h2),
          decoration: textFormDecoration('Name', context),
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(_surnameFocusNode);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please provide a value.';
            }
            return null;
          },
          onSaved: (value) {
            _initValues['name'] = value!;
          },
        ),
      ),
      // Surname
      Padding(
        padding: EdgeInsets.only(
            left: multiDeviceSupport.columnPadding,
            right: multiDeviceSupport.columnPadding,
            bottom: 10),
        child: Text(
          "And your surname:",
          style: TextStyle(
              color: colors.secondaryTextColor,
              fontSize: multiDeviceSupport.h3),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
            left: multiDeviceSupport.columnPadding,
            right: multiDeviceSupport.columnPadding,
            bottom: padding),
        child: TextFormField(
          key: const Key('surname'),
          focusNode: _surnameFocusNode,
          initialValue: _initValues['surname'],
          cursorColor: colors.primaryTextColor,
          style: TextStyle(
              color: colors.primaryTextColor, fontSize: multiDeviceSupport.h2),
          decoration: textFormDecoration('Surname', context),
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(_heightFocusNode);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please provide a value.';
            }
            return null;
          },
          onSaved: (value) {
            _initValues['surname'] = value!;
          },
        ),
      ),
      // Height and age
      Padding(
        padding: EdgeInsets.only(
            left: multiDeviceSupport.columnPadding,
            right: multiDeviceSupport.columnPadding,
            bottom: 10),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            "Your height in cm:",
            style: TextStyle(
                color: colors.secondaryTextColor,
                fontSize: multiDeviceSupport.h3),
          ),
          Text(
            "And your age:",
            style: TextStyle(
                color: colors.secondaryTextColor,
                fontSize: multiDeviceSupport.h3),
          ),
        ]),
      ),
      Padding(
        padding: EdgeInsets.only(
            left: multiDeviceSupport.columnPadding,
            right: multiDeviceSupport.columnPadding,
            bottom: padding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: screenWidth / 3.5,
              child: TextFormField(
                key: const Key('height'),
                focusNode: _heightFocusNode,
                initialValue: _initValues['height'],
                cursorColor: colors.primaryTextColor,
                style: TextStyle(
                    color: colors.primaryTextColor,
                    fontSize: multiDeviceSupport.h2),
                decoration: textFormDecoration('Height', context),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_ageFocusNode);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please provide a value.';
                  } else if (int.tryParse(value) == null) {
                    return 'Please provide a valid height in cm';
                  } else if (int.tryParse(value)! >= 240 ||
                      int.tryParse(value)! <= 0) {
                    return 'Please provide a valid age';
                  }
                  return null;
                },
                onSaved: (value) {
                  _initValues['height'] = value!;
                },
              ),
            ),
            SizedBox(
              width: screenWidth / 3.5,
              child: TextFormField(
                key: const Key('age'),
                focusNode: _ageFocusNode,
                initialValue: _initValues['age'],
                cursorColor: colors.primaryTextColor,
                style: TextStyle(
                    color: colors.primaryTextColor,
                    fontSize: multiDeviceSupport.h2),
                decoration: textFormDecoration('Age', context),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  // FocusScope.of(context).requestFocus(_sexFocusNode);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please provide a value.';
                  } else if (int.tryParse(value) == null) {
                    return 'Please provide a valid age';
                  } else if (int.tryParse(value)! >= 240 ||
                      int.tryParse(value)! <= 0) {
                    return 'Please provide a valid age';
                  }

                  return null;
                },
                onSaved: (value) {
                  _initValues['age'] = value!;
                },
              ),
            ),
          ],
        ),
      ),
      // Sex
      Padding(
        padding: EdgeInsets.only(
            left: multiDeviceSupport.columnPadding,
            right: multiDeviceSupport.columnPadding,
            bottom: 10),
        child: Text(
          "You define yourself as:",
          style: TextStyle(
              color: colors.secondaryTextColor,
              fontSize: multiDeviceSupport.h3),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
            left: multiDeviceSupport.columnPadding,
            right: multiDeviceSupport.columnPadding,
            bottom: padding),
        child: FormField(
          builder: (FormFieldState<int> state) {
            return GestureDetector(
              onTap: _showSexDialog,
              // initialValue: markerPosition.toString(),,
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 2.3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: state.hasError
                          ? BoxDecoration(
                              color: colors.onPrimary,
                              border: Border.all(color: colors.errorColor),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            )
                          : BoxDecoration(
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
                                child: _initValues['sex'] == '-1'
                                    ? Text(
                                        'Sex',
                                        style: TextStyle(
                                            color: colors.secondaryTextColor,
                                            fontSize: multiDeviceSupport.h2),
                                      )
                                    : Text(
                                        _sexCodes[int.parse(
                                            _initValues['sex'] ?? '-1')],
                                        style: TextStyle(
                                            color: colors.primaryTextColor,
                                            fontSize: multiDeviceSupport.h2),
                                      )),
                          ],
                        ),
                      ),
                    ),
                    state.hasError
                        ? Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              state.errorText ?? 'Nope',
                              style: TextStyle(
                                color: colors.errorColor,
                                fontSize: multiDeviceSupport.h3,
                              ),
                            ),
                          )
                        : Container()
                  ],
                ),
              ),
            );
          },
          validator: (value) {
            if (_initValues['sex'] == null ||
                _initValues['sex']!.isEmpty ||
                _initValues['sex'] == '-1') {
              return 'Please provide a value.';
            }
            return null;
          },
        ),
      ),
      // Location
      Padding(
        padding: EdgeInsets.only(
            left: multiDeviceSupport.columnPadding,
            right: multiDeviceSupport.columnPadding,
            bottom: 10),
        child: Text(
          "Your preferred location:",
          style: TextStyle(
              color: colors.secondaryTextColor,
              fontSize: multiDeviceSupport.h3),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
            left: multiDeviceSupport.columnPadding,
            right: multiDeviceSupport.columnPadding,
            bottom: padding),
        child: FormField(
          builder: (FormFieldState<int> state) {
            return GestureDetector(
              onTap: _showPlacesDialog,
              // initialValue: markerPosition.toString(),,
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 2.3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: state.hasError
                          ? BoxDecoration(
                              color: colors.onPrimary,
                              border: Border.all(color: colors.errorColor),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            )
                          : BoxDecoration(
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
                                child: _initValues['city_name'] == ''
                                    ? Text(
                                        'City',
                                        style: TextStyle(
                                            color: colors.secondaryTextColor,
                                            fontSize: multiDeviceSupport.h2),
                                      )
                                    : Text(
                                        _initValues['city_name']
                                            .toString()
                                            .split(',')[0],
                                        style: TextStyle(
                                            color: colors.primaryTextColor,
                                            fontSize: multiDeviceSupport.h2),
                                      )),
                          ],
                        ),
                      ),
                    ),
                    state.hasError
                        ? Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              state.errorText ?? 'Nope',
                              style: TextStyle(
                                color: colors.errorColor,
                                fontSize: multiDeviceSupport.h3,
                              ),
                            ),
                          )
                        : Container()
                  ],
                ),
              ),
            );
          },
          validator: (value) {
            if (_initValues['city_name'] == null ||
                _initValues['city_name']!.isEmpty ||
                _initValues['city_name'] == '') {
              return 'Please provide a value.';
            }
            return null;
          },
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
          left: multiDeviceSupport.columnPadding,
          right: multiDeviceSupport.columnPadding,
        ),
        child: Container(
          width: 70,
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                key: const Key("next2"),
                style: TextButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    backgroundColor: colors.primaryColor,
                    primary: colors.onPrimary,
                    textStyle: TextStyle(fontSize: multiDeviceSupport.h2),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10)),
                onPressed: _upPageIndex,
                child: const Text('Next'),
              ),
            ],
          ),
        ),
      ),
    ];
  }

  List<Widget> subscribeFormPage3(BuildContext context) {
    final colors = Provider.of<CustomColorScheme>(context);
    final double screenWidth = MediaQuery.of(context).size.width;
    var multiDeviceSupport = MultiDeviceSupport(context);
    multiDeviceSupport.init();

    return [
      Padding(
        padding: EdgeInsets.only(
            left: multiDeviceSupport.columnPadding,
            right: multiDeviceSupport.columnPadding,
            bottom: 50),
        child: Text(
          "Now lets get your  fitness level!",
          style: TextStyle(
            color: colors.primaryTextColor,
            fontSize: multiDeviceSupport.h2,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
            left: multiDeviceSupport.columnPadding,
            right: multiDeviceSupport.columnPadding,
            bottom: 10),
        child: Text(
          "How many times a week did you go running in the last six months:",
          style: TextStyle(
              color: colors.secondaryTextColor,
              fontSize: multiDeviceSupport.h3),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
            left: multiDeviceSupport.columnPadding,
            right: multiDeviceSupport.columnPadding,
            bottom: padding),
        child: TextFormField(
          key: Key('frequency'),
          autofocus: false,
          keyboardType: TextInputType.number,
          initialValue: _initValues['frequency'],
          cursorColor: colors.primaryTextColor,
          style: TextStyle(
              color: colors.primaryTextColor, fontSize: multiDeviceSupport.h2),
          decoration: textFormDecoration('Frequency', context),
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(_durationFocusNode);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please provide a value.';
            } else if (int.tryParse(value) == null) {
              return 'Please provide a valid number';
            }
            return null;
          },
          onSaved: (value) {
            _initValues['frequency'] = value!;
          },
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
            left: multiDeviceSupport.columnPadding,
            right: multiDeviceSupport.columnPadding,
            bottom: 10),
        child: Text(
          "And for how many minutes each time:",
          style: TextStyle(
              color: colors.secondaryTextColor,
              fontSize: multiDeviceSupport.h3),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
            left: multiDeviceSupport.columnPadding,
            right: multiDeviceSupport.columnPadding,
            bottom: padding),
        child: TextFormField(
          key: Key('duration'),
          keyboardType: TextInputType.number,
          focusNode: _durationFocusNode,
          initialValue: _initValues['duration'],
          cursorColor: colors.primaryTextColor,
          style: TextStyle(
              color: colors.primaryTextColor, fontSize: multiDeviceSupport.h2),
          decoration: textFormDecoration('Duration', context),
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(_distanceFocusNode);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please provide a value.';
            } else if (int.tryParse(value) == null) {
              return 'Please provide a valid duration in minutes';
            }
            return null;
          },
          onSaved: (value) {
            _initValues['duration'] = value!;
          },
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
            left: multiDeviceSupport.columnPadding,
            right: multiDeviceSupport.columnPadding,
            bottom: 10),
        child: Text(
          "How many kilometers do you go for:",
          style: TextStyle(
              color: colors.secondaryTextColor,
              fontSize: multiDeviceSupport.h3),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
            left: multiDeviceSupport.columnPadding,
            right: multiDeviceSupport.columnPadding,
            bottom: padding),
        child: TextFormField(
          key: Key('distance'),
          focusNode: _distanceFocusNode,
          initialValue: _initValues['distance'],
          cursorColor: colors.primaryTextColor,
          style: TextStyle(
              color: colors.primaryTextColor, fontSize: multiDeviceSupport.h2),
          decoration: textFormDecoration('Distance', context),
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) {},
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please provide a value.';
            } else if (int.tryParse(value) == null) {
              return 'Please provide a valid height in cm';
            }
            return null;
          },
          onSaved: (value) {
            _initValues['distance'] = value!;
          },
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
            left: multiDeviceSupport.columnPadding,
            right: multiDeviceSupport.columnPadding,
            bottom: 10),
        child: Text(
          "How fit do you feel you are:",
          style: TextStyle(
              color: colors.secondaryTextColor,
              fontSize: multiDeviceSupport.h3),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
            left: multiDeviceSupport.columnPadding,
            right: multiDeviceSupport.columnPadding,
            bottom: padding),
        child: FormField(
          builder: (FormFieldState<int> state) {
            return GestureDetector(
              onTap: _showFitnessDialog,
              // initialValue: markerPosition.toString(),,
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 2.3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: state.hasError
                          ? BoxDecoration(
                              color: colors.onPrimary,
                              border: Border.all(color: colors.errorColor),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            )
                          : BoxDecoration(
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
                                child: _initValues['fitness'] == '-1'
                                    ? Text(
                                        'Fitness',
                                        style: TextStyle(
                                            color: colors.secondaryTextColor,
                                            fontSize: multiDeviceSupport.h2),
                                      )
                                    : Text(
                                        _fitCodes[int.parse(
                                            _initValues['fitness'] ?? '-1')],
                                        style: TextStyle(
                                            color: colors.primaryTextColor,
                                            fontSize: multiDeviceSupport.h2),
                                      )),
                          ],
                        ),
                      ),
                    ),
                    state.hasError
                        ? Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              state.errorText ?? 'Nope',
                              style: TextStyle(
                                color: colors.errorColor,
                                fontSize: multiDeviceSupport.h3,
                              ),
                            ),
                          )
                        : Container()
                  ],
                ),
              ),
            );
          },
          validator: (value) {
            print(_initValues['fitness']);
            if (_initValues['fitness'] == null ||
                _initValues['fitness']!.isEmpty ||
                _initValues['fitness'] == '-1') {
              print("hey");
              return 'Please provide a value.';
            }
            return null;
          },
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
          left: multiDeviceSupport.columnPadding,
          right: multiDeviceSupport.columnPadding,
        ),
        child: Container(
          width: 70,
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    backgroundColor: colors.primaryColor,
                    primary: colors.onPrimary,
                    textStyle: TextStyle(fontSize: multiDeviceSupport.h2),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10)),
                onPressed: _saveForm,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final colors = Provider.of<CustomColorScheme>(context, listen: false);
    final double screenWidth = MediaQuery.of(context).size.width;
    var multiDeviceSupport = MultiDeviceSupport(context);
    multiDeviceSupport.init();

    if (!_isLoading) {
      return SizedBox(
        height: MediaQuery.of(context).size.height / 1.1,
        child: Form(
          key: _form,
          child: ScrollConfiguration(
            behavior: CustomScrollBehavior(),
            child: ListView(
              key: Key(_pageIndex.toString()),
              scrollDirection: Axis.vertical,
              children: <Widget>[
                // Title row
                Padding(
                  padding: EdgeInsets.only(top: multiDeviceSupport.paddingTop2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Here pageIndex is used to show or not the back arrow
                      _pageIndex > 0
                          ? IconButton(
                              icon: Icon(
                                Icons.chevron_left,
                                color: colors.secondaryTextColor,
                                size: 30,
                              ),
                              splashRadius: null,
                              onPressed: _downPageIndex,
                            )
                          : IconButton(
                              icon: Icon(
                                Icons.chevron_left,
                                color: Colors.transparent,
                                size: 30,
                              ),
                              splashRadius: 1,
                              onPressed: () {},
                            ),
                      Text(
                        "Subscribe to Run With Me",
                        style: TextStyle(
                            color: colors.primaryTextColor,
                            fontSize: multiDeviceSupport.h1,
                            height: 1.5,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.close_outlined,
                          color: colors.secondaryTextColor,
                          size: 25,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: padding,
                ),

                // Username textbox
                if (_pageIndex == 0) ...subscribeFormPage1(context),
                if (_pageIndex == 1) ...subscribeFormPage2(context),
                if (_pageIndex == 2) ...subscribeFormPage3(context),

                // Date and Time

                const SizedBox(
                  height: padding,
                ),

                const SizedBox(
                  height: padding,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                )
              ],
            ),
          ),
        ),
      );
    } else {
      return const CustomLoadingCircleIcon();
    }
  }
}
