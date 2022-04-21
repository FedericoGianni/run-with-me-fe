///{@category Widgets}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../classes/multi_device_support.dart';
import '../providers/color_scheme.dart';

class CustomSlider extends StatefulWidget {
  CustomSlider(
      {required this.sliderValue, required this.onSliderMove, Key? key})
      : super(key: key);

  double sliderValue;
  late final Function(double) onSliderMove;

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  @override
  Widget build(BuildContext context) {
    final colors = Provider.of<CustomColorScheme>(context);
    var multiDeviceSupport = MultiDeviceSupport(context);
    multiDeviceSupport.init();
    return SliderTheme(
      data: SliderThemeData(
          // activeTrackColor: colors.secondaryColor,
          // activeTickMarkColor: colors.secondaryColor,
          // overlayColor: colors.secondaryColor,
          // valueIndicatorColor: colors.onPrimary,
          showValueIndicator: ShowValueIndicator.never,
          valueIndicatorTextStyle: TextStyle(color: colors.primaryTextColor),
          // thumbColor: colors.background,
          thumbShape: RoundSliderThumbShape(
              enabledThumbRadius: 10 + multiDeviceSupport.tablet * 3)),
      child: Slider(
        value: widget.sliderValue,
        max: 5,
        divisions: 5,
        activeColor: colors.primaryColorLight,
        thumbColor: colors.primaryColor,
        inactiveColor: colors.secondaryTextColor,
        label: widget.sliderValue.round().toString(),
        onChanged: (double value) {
          setState(() {
            widget.sliderValue = value;
            widget.onSliderMove(value);
          });
        },
      ),
    );
  }
}
