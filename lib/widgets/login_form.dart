// import 'dart:html';

// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:runwithme/providers/settings_manager.dart';
import '../themes/custom_colors.dart';
import '../providers/color_scheme.dart';
import 'package:provider/provider.dart';
import '../themes/custom_theme.dart';
import '../widgets/subscribe_bottomsheet.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _form = GlobalKey<FormState>();
  final _pwdFocusNode = FocusNode();
  bool renderErrorPopup = false;
  Icon eyeIcon = const Icon(
    Icons.remove_red_eye,
  );
  static const double padding = 50;
  bool isTextObsured = true;
  var _initValues = {
    'username': '',
    'password': '',
  };
  var snackBar;
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
    final settings = Provider.of<UserSettings>(context, listen: false);

    final isValid = _form.currentState?.validate();
    if (isValid == null || !isValid) {
      return;
    }
    _form.currentState?.save();
    print("Logging in");
    setState(() {
      settings
          .userLogin(_initValues['username'], _initValues['password'])
          .then((value) {
        if (!value) {
          print('rip');
          renderErrorPopup = true;
          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(snackBar);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Provider.of<CustomColorScheme>(context, listen: false);
    final double screenWidth = MediaQuery.of(context).size.width;

    // This snackbar is used for the popup message in case of wrong credentials
    snackBar = SnackBar(
      content: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(5),
              child: Text(
                'Incorrect username of password!',
                style: TextStyle(color: colors.primaryTextColor, fontSize: 14),
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
              color: colors.errorColor,
              width: 1,
            ),
            borderRadius: BorderRadius.all(Radius.circular(15))),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      behavior: SnackBarBehavior.fixed,
      duration: Duration(seconds: 1),
      padding: EdgeInsets.only(bottom: 40),
    );
    return Form(
      key: _form,
      child: ListView(
        children: <Widget>[
          Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    "Log in to Run With Me",
                    style: TextStyle(
                        color: colors.primaryTextColor,
                        fontSize: 18,
                        height: 1.5,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Not yet registered?",
                        style: TextStyle(
                            color: colors.primaryTextColor,
                            fontSize: 16,
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
                              fontSize: 16,
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
              style: TextStyle(color: colors.primaryTextColor),
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
              style: TextStyle(color: colors.primaryTextColor),
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
                        textStyle: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
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
                        textStyle: const TextStyle(fontSize: 16),
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
  }
}
