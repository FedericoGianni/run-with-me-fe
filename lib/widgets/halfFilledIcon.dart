import 'package:flutter/material.dart';

import '../themes/custom_colors.dart';

class HalfFilledIcon extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  HalfFilledIcon(
      {Key? key, required this.icon, required this.size, required this.color})
      : super(key: key);

  final IconData icon;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (Rect rect) {
        return LinearGradient(
          stops: const [0, 0.5, 0.5],
          colors: [color, color, color.withOpacity(0)],
        ).createShader(rect);
      },
      child: SizedBox(
        width: size,
        height: size,
        child: Icon(icon, size: size, color: secondaryTextColor),
      ),
    );
  }
}
