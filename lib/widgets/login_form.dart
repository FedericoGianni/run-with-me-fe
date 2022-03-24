// import 'dart:html';

// ignore_for_file: unnecessary_const

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:runwithme/providers/settings_manager.dart';
import 'package:runwithme/widgets/custom_snackbar.dart';
import 'package:runwithme/widgets/splash.dart';
import '../classes/multi_device_support.dart';
import '../providers/user.dart';
import '../themes/custom_colors.dart';
import '../providers/color_scheme.dart';
import 'package:provider/provider.dart';
import '../themes/custom_theme.dart';
import 'custom_loading_animation.dart';
import 'subscribe_bottomsheet.dart';
import 'custom_loading_circle_icon.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _form = GlobalKey<FormState>();
  final _pwdFocusNode = FocusNode();
  Icon eyeIcon = const Icon(
    Icons.remove_red_eye,
  );
  bool _isLoading = false;
  static const double padding = 50;
  bool isTextObsured = true;
  var _initValues = {
    'username': '',
    'password': '',
  };

  void _togglePwdText() {
    setState(() {
      isTextObsured = !isTextObsured;
      if (!isTextObsured) {
        eyeIcon = Icon(
          Icons.remove_red_eye_outlined,
        );
      } else {
        eyeIcon = Icon(
          Icons.remove_red_eye,
        );
      }
    });
  }
  // TODO: this should be uncommented to avoid memory leaks
  // @override
  // void dispose() {
  //   print('hey DISPOSING');
  //   _pwdFocusNode.dispose();
  //   super.dispose();
  // }

  Future<void> _saveForm() async {
    // final pageIndex = Provider.of<PageIndex>(context, listen: false);
    final colors = Provider.of<CustomColorScheme>(context, listen: false);
    final double screenWidth = MediaQuery.of(context).size.width;
    var _snackBarText = '';
    final user = Provider.of<User>(context, listen: false);
    final settings = Provider.of<UserSettings>(context, listen: false);

    final isValid = _form.currentState?.validate();
    if (isValid == null || !isValid) {
      return;
    }
    _form.currentState?.save();
    print("Logging in");
    setState(() {
      _isLoading = true;
    });

    print("isLoading is true");
    settings.setUser(user);
    List loginResult = await settings.userLogin(
        _initValues['username'], _initValues['password']);

    await Future.delayed(Duration(seconds: 1));
    if (!loginResult[0]) {
      print('rip');
      CustomSnackbarProvider snackbarProvider = CustomSnackbarProvider(
          ctx: context, message: loginResult[1].toString());
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(snackbarProvider.provide());
      print("isLoading is false1");
      setState(() {
        _isLoading = false;
      });
    } else {
      _isLoading = false;
      print("isLoading is false2");
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Provider.of<CustomColorScheme>(context, listen: false);
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    var settings = Provider.of<UserSettings>(context);
    var multiDeviceSupport = MultiDeviceSupport(context);
    multiDeviceSupport.init();

    // This snackbar is used for the popup message in case of wrong credentials
    print(settings.isLoggedIn().toString());
    if (!_isLoading) {
      return Form(
        key: _form,
        child: ListView(
          children: <Widget>[
            Center(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: screenHeight / 6),
                    child: Text(
                      "Log in to Run With Me",
                      style: TextStyle(
                          color: colors.primaryTextColor,
                          fontSize: multiDeviceSupport.h1,
                          height: 1.5,
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: screenHeight / 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Not yet registered?",
                          style: TextStyle(
                              color: colors.primaryTextColor,
                              fontSize: multiDeviceSupport.h2,
                              height: 1.5,
                              fontWeight: FontWeight.normal),
                          textAlign: TextAlign.center,
                        ),
                        TextButton(
                          onPressed: () {
                            showModalBottomSheet(
                                enableDrag: false,
                                isScrollControlled: true,
                                backgroundColor: colors.background,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: const BorderRadius.vertical(
                                        top: const Radius.circular(15))),
                                context: context,
                                builder: (_) {
                                  return const SubscribeBottomSheet();
                                });
                          },
                          child: Text(
                            'Subscribe',
                            style: TextStyle(
                                color: colors.primaryColor,
                                fontSize: multiDeviceSupport.h2,
                                height: 1.5,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: padding,
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: 10, left: screenWidth / 7, right: screenWidth / 7),
              child: TextFormField(
                // autofocus: true,
                initialValue: _initValues['username'],
                cursorColor: colors.primaryTextColor,
                style: TextStyle(
                    color: colors.primaryTextColor,
                    fontSize: multiDeviceSupport.h3),
                decoration: textFormDecoration('Username', context),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_pwdFocusNode);
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
            const SizedBox(
              height: padding,
            ),
            // Date and Time
            Padding(
              padding: EdgeInsets.only(
                  top: 10, left: screenWidth / 7, right: screenWidth / 7),
              child: TextFormField(
                focusNode: _pwdFocusNode,
                initialValue: _initValues['password'],
                obscureText: isTextObsured,
                cursorColor: colors.primaryTextColor,
                style: TextStyle(
                    color: colors.primaryTextColor,
                    fontSize: multiDeviceSupport.h3),
                decoration: passwordFormDecoration(
                    'Password', eyeIcon, _togglePwdText, context),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {},
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please provide a value.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _initValues['password'] = value!;
                },
              ),
            ),
            const SizedBox(
              height: padding,
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: 10, left: screenWidth / 7, right: screenWidth / 7),
              child: Container(
                width: 70,
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                          primary: colors.secondaryTextColor,
                          textStyle: TextStyle(
                            fontSize: multiDeviceSupport.h3,
                            fontWeight: FontWeight.bold,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10)),
                      onPressed: () {},
                      child: const Text('Forgot password?'),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          backgroundColor: colors.primaryColor,
                          primary: colors.onPrimary,
                          textStyle: TextStyle(fontSize: multiDeviceSupport.h3),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10)),
                      onPressed: _saveForm,
                      child: const Text('Log in'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: padding,
            ),
          ],
        ),
      );
    } else {
      return const CustomLoadingAnimation();
    }
  }
}
