import 'package:flutter/material.dart';

Future<void> customAlertDialog(
    context, Text title, List<Widget> bodyList, colors) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: colors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: title,
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              ...bodyList,
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Approve',
              style: TextStyle(fontSize: 14),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
