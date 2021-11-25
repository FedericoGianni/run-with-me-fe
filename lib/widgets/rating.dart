import 'package:flutter/material.dart';

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

  List _addEmpty() {
    return List.generate(5 - value.ceil(), (index) {
      // return HalfFilledIcon(icon: Icons.circle, size: size, color: color);
      return Icon(
        Icons.circle,
        size: size,
        color: tertiaryTextColor,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 5, top: 2),
      child: Row(
        children: [
          ..._addScore(),
          value % 1 != 0.0
              ? HalfFilledIcon(icon: Icons.circle, size: size, color: color)
              : const SizedBox.shrink(),
          ..._addEmpty()
        ],
      ),
    );
  }
}
