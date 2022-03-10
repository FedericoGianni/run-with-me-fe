import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../themes/custom_colors.dart';
import '../providers/color_scheme.dart';
import 'package:provider/provider.dart';
import '../themes/custom_theme.dart';

class SubscribeBottomSheet extends StatefulWidget {
  const SubscribeBottomSheet({Key? key}) : super(key: key);

  @override
  State<SubscribeBottomSheet> createState() => _SubscribeBottomSheetState();
}

class _SubscribeBottomSheetState extends State<SubscribeBottomSheet> {
  final _form = GlobalKey<FormState>();
  final _pwd3FocusNode = FocusNode();
  final _pwd2FocusNode = FocusNode();
  Icon eyeIcon = const Icon(
    Icons.remove_red_eye,
  );
  static const double padding = 50;
  bool isTextObsured = false;
  final _initValues = {
    'email': '',
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

  @override
  void dispose() {
    print("DISPOSE");
    _pwd3FocusNode.dispose();
    _pwd2FocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    // final pageIndex = Provider.of<PageIndex>(context, listen: false);

    final isValid = _form.currentState?.validate();
    if (isValid == null || !isValid) {
      return;
    }
    _form.currentState?.save();
    print("Logging in");
    setState(() {
      // _isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Provider.of<CustomColorScheme>(context, listen: false);
    final double screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      height: MediaQuery.of(context).size.height / 1.1,
      child: Form(
        key: _form,
        child: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.close_outlined,
                    color: colors.background,
                    size: 25,
                  ),
                  splashRadius: null,
                  onPressed: () {},
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    "Subscribe to Run With Me",
                    style: TextStyle(
                        color: colors.primaryTextColor,
                        fontSize: 18,
                        height: 1.5,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
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
            const SizedBox(
              height: padding,
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: 10, left: screenWidth / 7, right: screenWidth / 7),
              child: TextFormField(
                autofocus: true,
                initialValue: _initValues['email'],
                cursorColor: colors.primaryTextColor,
                style: TextStyle(color: colors.primaryTextColor),
                decoration: textFormDecoration('Email', context),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_pwd3FocusNode);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please provide a value.';
                  }
                  return null;
                },
                onSaved: (value) {},
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
                focusNode: _pwd3FocusNode,
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
                onSaved: (value) {},
              ),
            ),

            const SizedBox(
              height: padding,
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: 10, left: screenWidth / 7, right: screenWidth / 7),
              child: TextFormField(
                focusNode: _pwd2FocusNode,
                initialValue: _initValues['password'],
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
                  }
                  return null;
                },
                onSaved: (value) {},
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
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
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
                      onPressed: () {},
                      child: const Text('Next'),
                    ),
                  ],
                ),
              ),
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
    );
  }
}
