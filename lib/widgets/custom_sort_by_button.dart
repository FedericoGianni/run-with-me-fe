import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/color_scheme.dart';

class SortByButton extends StatelessWidget {
  SortByButton(
      {required this.title,
      required this.color,
      required this.id,
      required this.activeId,
      required this.onPressed,
      Key? key})
      : super(key: key);

  final String title;
  Color color;
  final int id;
  final int activeId;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Provider.of<CustomColorScheme>(context);

    if (id != activeId) {
      color = colors.secondaryTextColor;
    }
    return Container(
      height: 30,
      width: 60,
      padding: EdgeInsets.all(0),
      child: TextButton(
        child: Text(
          title,
          style: TextStyle(
            overflow: TextOverflow.clip,
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(Colors.transparent),
        ),
        onPressed: () {
          onPressed();
        },
      ),
      decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: color,
            width: 1,
          ),
          borderRadius: BorderRadius.all(Radius.circular(15))),
    );
  }
}
