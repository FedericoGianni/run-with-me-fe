import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../classes/multi_device_support.dart';
import '../providers/color_scheme.dart';

enum SortButton {
  distance,
  date,
  difficulty,
  lenght,
  duration,
  none,
}

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
  final SortButton id;
  final SortButton activeId;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Provider.of<CustomColorScheme>(context);
    var multiDeviceSupport = MultiDeviceSupport(context);
    multiDeviceSupport.init();
    Color backgroundColor;

    if (id != activeId) {
      color = colors.secondaryTextColor;
      backgroundColor = colors.onPrimary;
    } else {
      backgroundColor = colors.onPrimary;
    }
    return Container(
      height: 30 + multiDeviceSupport.tablet * 5,
      width: 60 + multiDeviceSupport.tablet * 30,
      padding: const EdgeInsets.all(0),
      child: TextButton(
        child: Text(
          title,
          style: TextStyle(
            overflow: TextOverflow.clip,
            color: color,
            fontSize: multiDeviceSupport.h5,
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
          color: backgroundColor,
          // border: Border.all(
          //   color: backgroundColor,
          //   width: 1,
          // ),
          borderRadius: const BorderRadius.all(Radius.circular(15))),
    );
  }
}
