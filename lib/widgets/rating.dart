import 'package:flutter/material.dart';

import '../providers/color_scheme.dart';
import 'package:provider/provider.dart';
import 'halfFilledIcon.dart';
import '../themes/custom_colors.dart';

class Rating extends StatelessWidget {
  const Rating(
      {Key? key, required this.value, required this.size, required this.color})
      : super(key: key);
  final double value;
  final double size;
  final Color color;

  List _addScore() {
    return List.generate(value.toInt(), (index) {
      // return HalfFilledIcon(icon: Icons.circle, size: size, color: color);
      return Icon(
        Icons.circle,
        size: size,
        color: color,
      );
    });
  }

  List _addEmpty(colors) {
    return List.generate(5 - value.ceil(), (index) {
      // return HalfFilledIcon(icon: Icons.circle, size: size, color: color);
      return Icon(
        Icons.circle,
        size: size,
        color: colors.tertiaryTextColor,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Provider.of<CustomColorScheme>(context);

    return Container(
      child: Row(
        children: [
          ..._addScore(),
          value % 1 != 0.0
              ? HalfFilledIcon(icon: Icons.circle, size: size, color: color)
              : const SizedBox.shrink(),
          ..._addEmpty(colors)
        ],
      ),
    );
  }
}
