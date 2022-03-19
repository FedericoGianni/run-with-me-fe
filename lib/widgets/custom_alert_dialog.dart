import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runwithme/providers/color_scheme.dart';
import 'package:runwithme/providers/settings_manager.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog(
      {required this.title,
      required this.message,
      required this.onDismiss,
      required this.onAccept,
      Key? key})
      : super(key: key);

  final String title;
  final String message;
  final Function() onDismiss;
  final Function() onAccept;

  @override
  Widget build(BuildContext context) {
    final colors = Provider.of<CustomColorScheme>(context);
    final settings = Provider.of<UserSettings>(context);

    return AlertDialog(
      backgroundColor: colors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text(
        title,
        style: TextStyle(
          color: colors.primaryTextColor,
          fontSize: 20,
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
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            'No',
            style: TextStyle(
              color: colors.primaryTextColor,
              fontSize: 16,
            ),
          ),
          onPressed: () {
            onDismiss();
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(
            'Yes',
            style: TextStyle(
              color: colors.primaryColor,
              fontSize: 16,
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
