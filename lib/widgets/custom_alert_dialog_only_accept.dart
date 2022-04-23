import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runwithme/providers/color_scheme.dart';
import 'package:runwithme/providers/settings_manager.dart';

import '../classes/multi_device_support.dart';

class CustomAlertDialogAcceptOnly extends StatelessWidget {
  const CustomAlertDialogAcceptOnly(
      {required this.title,
      required this.message,
      required this.onAccept,
      Key? key})
      : super(key: key);

  final String title;
  final String message;
  final Function() onAccept;

  @override
  Widget build(BuildContext context) {
    final colors = Provider.of<CustomColorScheme>(context);
    final settings = Provider.of<UserSettings>(context);
    var multiDeviceSupport = MultiDeviceSupport(context);
    multiDeviceSupport.init();
    return AlertDialog(
      backgroundColor: colors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text(
        title,
        style: TextStyle(
          color: colors.primaryTextColor,
          fontSize: multiDeviceSupport.h0,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
              message,
              style: TextStyle(
                color: colors.secondaryTextColor,
                fontSize: multiDeviceSupport.h2,
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            'Ok',
            style: TextStyle(
              color: colors.primaryColor,
              fontSize: multiDeviceSupport.h2,
            ),
          ),
          onPressed: () {
            onAccept();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
