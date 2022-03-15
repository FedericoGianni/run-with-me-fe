import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:runwithme/widgets/custom_scroll_behavior.dart';
import '../providers/settings_manager.dart';
import '../themes/custom_colors.dart';
import '../providers/color_scheme.dart';
import 'package:provider/provider.dart';
import '../themes/custom_theme.dart';
import '../providers/user.dart';
import 'custom_alert_dialog.dart';
import 'custom_loading_icon.dart';
import 'custom_map_place_search.dart';
import 'custom_sex_dialog.dart';

class SubscribeBottomSheet extends StatefulWidget {
  const SubscribeBottomSheet({Key? key}) : super(key: key);

  @override
  State<SubscribeBottomSheet> createState() => _SubscribeBottomSheetState();
}

class _SubscribeBottomSheetState extends State<SubscribeBottomSheet> {
  final _form = GlobalKey<FormState>();
  int _pageIndex = 0;
  final _emailFocusNode = FocusNode();
  final _pwd1FocusNode = FocusNode();
  final _pwd2FocusNode = FocusNode();
  final _surnameFocusNode = FocusNode();
  final _heightFocusNode = FocusNode();
  final _ageFocusNode = FocusNode();
  final _sexFocusNode = FocusNode();
  bool _isLoading = false;
  var snackBar;
  var _controller = TextEditingController();

  Icon eyeIcon = const Icon(
    Icons.remove_red_eye,
  );
  static const double padding = 50;
  bool isTextObsured = true;

  var _sexCodes = {'Male': 1, 'Female': 2, "Don't know": 0};

  var _initValues = {
    'username': '',
    'password': '',
    'email': '',
    'password2': '',
    'name': '',
    'surname': '',
    'height': '',
    'age': '',
    'sex': '',
    'city': '',
  };

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
    super.dispose();
  }

  Future<void> _showMapDialog() async {
    print("hey");
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return CustomMapPlaceSearch();
      },
    ).then((value) {
      _initValues['city'] = value['description'];
      setState(() {
        print("bellazio");
        print(_initValues.keys);
      });
    });
  }

  Future<void> _showSexDialog() async {
    print("hey");
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return CustomSexDialog();
      },
    ).then((value) {
      _initValues['sex'] = value;
      setState(() {
        print("bellazio");
        print(_initValues.keys);
      });
    });
  }

  Future<void> _saveForm() async {
    // final pageIndex = Provider.of<PageIndex>(context, listen: false);
    final colors = Provider.of<CustomColorScheme>(context, listen: false);
    final double screenWidth = MediaQuery.of(context).size.width;
    var settings = Provider.of<UserSettings>(context, listen: false);

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

    List registerResult = await user.register(_initValues['username'], _initValues['email'], _initValues['password']);
    if (registerResult[0]) {
      List loginResult = await settings.userLogin(_initValues['username'], _initValues['password']);
      if (loginResult[0]) {
        user.age = int.parse(_initValues['age']!);
        user.surname = _initValues['surname'];
        user.name = _initValues['name'];
        user.city = _initValues['city'];
        user.fitnessLevel = 99;
        // user.fitnessLevel = double.parse(_initValues['fitnessLevel']!);
        user.height = int.parse(_initValues['height']!);
        user.sex = _sexCodes[_initValues['sex']!];

        bool updateResult = await user.updateUser();
        if (updateResult){
        snackBar = SnackBar(
        content: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(5),
                child: Text(
                  registerResult[1],
                  style: TextStyle(
                      color: colors.primaryTextColor,
                      fontSize: 14,
                      overflow: TextOverflow.fade),
                ),
              ),
            ],
          ),
          margin: EdgeInsets.symmetric(horizontal: screenWidth / 7),
          // width: 20,

          padding: EdgeInsets.all(10),

          decoration: BoxDecoration(
              color: colors.background,
              border: Border.all(
                color: registerResult[0] ? colors.primaryColor:colors.errorColor,
                width: 1,
              ),
              borderRadius: BorderRadius.all(Radius.circular(15))),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
        padding: EdgeInsets.only(bottom: 40),
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
      print("Register not completed");
    }
  }

  List<Widget> subscribeFormPage1(BuildContext context) {
    final colors = Provider.of<CustomColorScheme>(context);
    final double screenWidth = MediaQuery.of(context).size.width;

    return [
      Padding(
        padding: EdgeInsets.only(
            top: 10,
            left: screenWidth / 7,
            right: screenWidth / 7,
            bottom: padding),
        child: TextFormField(
          key: Key('username'),

          // focusNode: _ageFocusNode,
          initialValue: _initValues['username'],
          cursorColor: colors.primaryTextColor,
          style: TextStyle(color: colors.primaryTextColor),
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
      Padding(
        padding: EdgeInsets.only(
            top: 10,
            left: screenWidth / 7,
            right: screenWidth / 7,
            bottom: padding),
        child: TextFormField(
          key: Key('email'),
          focusNode: _emailFocusNode,
          initialValue: _initValues['email'],
          cursorColor: colors.primaryTextColor,
          style: TextStyle(color: colors.primaryTextColor),
          decoration: textFormDecoration('Email', context),
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(_pwd1FocusNode);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please provide a value.';
            }
            return null;
          },
          onSaved: (value) {
            _initValues['email'] = value!;
          },
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
            top: 10, left: screenWidth / 7, right: screenWidth / 7),
        child: TextFormField(
          key: Key('password'),
          focusNode: _pwd1FocusNode,
          initialValue: _initValues['password'],
          obscureText: isTextObsured,
          cursorColor: colors.primaryTextColor,
          style: TextStyle(color: colors.primaryTextColor),
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
      const SizedBox(
        height: padding,
      ),
      Padding(
        padding: EdgeInsets.only(
          top: 10,
          left: screenWidth / 7,
          right: screenWidth / 7,
          bottom: padding,
        ),
        child: TextFormField(
          key: Key('password2'),
          focusNode: _pwd2FocusNode,
          initialValue: _initValues['password2'],
          obscureText: isTextObsured,
          cursorColor: colors.primaryTextColor,
          style: TextStyle(color: colors.primaryTextColor),
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
          top: 10,
          left: screenWidth / 7,
          right: screenWidth / 7,
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
                    textStyle: const TextStyle(fontSize: 16),
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
    print(_initValues);
    return [
      Padding(padding: EdgeInsets.only(
            left: screenWidth / 7,
            right: screenWidth / 7,
            bottom: 10),
            child: Text("What is your name:", style: TextStyle(color: colors.primaryTextColor, fontSize: 16, fontWeight: FontWeight.bold,),),),
      Padding(
        padding: EdgeInsets.only(
            top: 10,
            left: screenWidth / 7,
            right: screenWidth / 7,
            bottom: padding),
        child: TextFormField(
          key: Key('name'),
          autofocus: false,
          initialValue: _initValues['name'],
          cursorColor: colors.primaryTextColor,
          style: TextStyle(color: colors.primaryTextColor),
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
      Padding(padding: EdgeInsets.only(
            left: screenWidth / 7,
            right: screenWidth / 7,
            bottom: 10),
            child: Text("And your surname:", style: TextStyle(color: colors.primaryTextColor, fontSize: 16, fontWeight: FontWeight.bold,),),),
      Padding(
        padding: EdgeInsets.only(
            top: 10,
            left: screenWidth / 7,
            right: screenWidth / 7,
            bottom: padding),
        child: TextFormField(
          key: Key('surname'),
          focusNode: _surnameFocusNode,
          initialValue: _initValues['surname'],
          cursorColor: colors.primaryTextColor,
          style: TextStyle(color: colors.primaryTextColor),
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
      Padding(padding: EdgeInsets.only(
            left: screenWidth / 7,
            right: screenWidth / 7,
            bottom: 10),
            child: Text("Your height:", style: TextStyle(color: colors.primaryTextColor, fontSize: 16, fontWeight: FontWeight.bold,),),),
      Padding(
        padding: EdgeInsets.only(
            left: screenWidth / 7,
            right: screenWidth / 7,
            bottom: padding),
        child: TextFormField(
          key: Key('height'),
          focusNode: _heightFocusNode,
          initialValue: _initValues['height'],
          cursorColor: colors.primaryTextColor,
          style: TextStyle(color: colors.primaryTextColor),
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
            }
            return null;
          },
          onSaved: (value) {
            _initValues['height'] = value!;
          },
        ),
      ),Padding(padding: EdgeInsets.only(
            left: screenWidth / 7,
            right: screenWidth / 7,
            bottom: 10),
            child: Text("How old are you:", style: TextStyle(color: colors.primaryTextColor, fontSize: 16, fontWeight: FontWeight.bold,),),),
      Padding(
        padding: EdgeInsets.only(
            left: screenWidth / 7,
            right: screenWidth / 7,
            bottom: padding),
        child: TextFormField(
          key: Key('age'),
          focusNode: _ageFocusNode,
          initialValue: _initValues['age'],
          cursorColor: colors.primaryTextColor,
          style: TextStyle(color: colors.primaryTextColor),
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
            }
            return null;
          },
          onSaved: (value) {
            _initValues['age'] = value!;
          },
        ),
      ),
      Padding(padding: EdgeInsets.only(
            left: screenWidth / 7,
            right: screenWidth / 7,
            bottom: 10),
            child: Text("You define yourself as:", style: TextStyle(color: colors.primaryTextColor, fontSize: 16, fontWeight: FontWeight.bold,),),),
      Padding(
        padding: EdgeInsets.only(
            top: 10,
            left: screenWidth / 7,
            right: screenWidth / 7,
            bottom: padding),
        child: GestureDetector(
          onTap: _showSexDialog,
          // initialValue: markerPosition.toString(),,
          child: Container(
            width: MediaQuery.of(context).size.width / 2.3,
            decoration: BoxDecoration(
              color: colors.onPrimary,
              border: Border.all(color: colors.onPrimary),
              borderRadius: const BorderRadius.all(
                const Radius.circular(10.0),
              ),
            ),
            height: 60,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  Expanded(
                      child: _initValues['sex'] == ''
                          ? Text(
                              'Sex',
                              style: TextStyle(
                                  color: colors.secondaryTextColor,
                                  fontSize: 16),
                            )
                          : Text(
                              _initValues['sex']!,
                              style: TextStyle(
                                  color: colors.primaryTextColor, fontSize: 16),
                            )),
                ],
              ),
            ),
          ),
        ),
      ),
      Padding(padding: EdgeInsets.only(
            left: screenWidth / 7,
            right: screenWidth / 7,
            bottom: 10),
            child: Text("Your preferred location:", style: TextStyle(color: colors.primaryTextColor, fontSize: 16, fontWeight: FontWeight.bold,),),),
      Padding(
        padding: EdgeInsets.only(
            top: 10,
            left: screenWidth / 7,
            right: screenWidth / 7,
            bottom: padding),
        child: GestureDetector(
          onTap: _showMapDialog,
          // initialValue: markerPosition.toString(),,
          child: Container(
            width: MediaQuery.of(context).size.width / 2.3,
            decoration: BoxDecoration(
              color: colors.onPrimary,
              border: Border.all(color: colors.onPrimary),
              borderRadius: const BorderRadius.all(
                const Radius.circular(10.0),
              ),
            ),
            height: 60,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  Expanded(
                      child: _initValues['city'] == ''
                          ? Text(
                              'City',
                              style: TextStyle(
                                  color: colors.secondaryTextColor,
                                  fontSize: 16),
                            )
                          : Text(
                              _initValues['city'].toString().split(',')[0],
                              style: TextStyle(
                                  color: colors.primaryTextColor, fontSize: 16),
                            )),
                ],
              ),
            ),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
          top: 10,
          left: screenWidth / 7,
          right: screenWidth / 7,
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
                    textStyle: const TextStyle(fontSize: 16),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10)),
                onPressed: _saveForm,
                child: const Text('Next'),
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
    if (!_isLoading) {
      return SizedBox(
        height: MediaQuery.of(context).size.height / 1.1,
        child: Form(
          key: _form,
          child: ScrollConfiguration(
            behavior: CustomScrollBehavior(),
            child: ListView(
              scrollDirection: Axis.vertical,
              children: <Widget>[
                // Title row
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
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
                            fontSize: 18,
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
      return const CustomLoadingIcon();
    }
  }
}
