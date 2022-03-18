import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/color_scheme.dart';

class customSlider extends StatefulWidget {
  customSlider(
      {required this.sliderValue, required this.onSliderMove, Key? key})
      : super(key: key);

  double sliderValue;
  late final Function(double) onSliderMove;

  @override
  State<customSlider> createState() => _customSliderState();
}

class _customSliderState extends State<customSlider> {
  @override
  Widget build(BuildContext context) {
    final colors = Provider.of<CustomColorScheme>(context);
    return SliderTheme(
      data: SliderThemeData(
          // activeTrackColor: colors.secondaryColor,
          // activeTickMarkColor: colors.secondaryColor,
          // overlayColor: colors.secondaryColor,
          // valueIndicatorColor: colors.onPrimary,
          showValueIndicator: ShowValueIndicator.never,
          valueIndicatorTextStyle: TextStyle(color: colors.primaryTextColor),
          // thumbColor: colors.background,
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10)),
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
