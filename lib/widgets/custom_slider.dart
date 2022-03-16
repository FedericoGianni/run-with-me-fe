import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/color_scheme.dart';

class FitnessSlider extends StatefulWidget {
  const FitnessSlider({Key? key}) : super(key: key);

  @override
  State<FitnessSlider> createState() => _FitnessSliderState();
}

class _FitnessSliderState extends State<FitnessSlider> {
  double _currentSliderValue = 2;

  @override
  Widget build(BuildContext context) {
    final colors = Provider.of<CustomColorScheme>(context);
    return Slider(
      value: _currentSliderValue,
      max: 5,
      divisions: 5,
      activeColor: colors.primaryColor,
      thumbColor: colors.primaryColor,
      inactiveColor: colors.secondaryTextColor,
      label: _currentSliderValue.round().toString(),
      onChanged: (double value) {
        setState(() {
          _currentSliderValue = value;
        });
      },
    );
  }
}
