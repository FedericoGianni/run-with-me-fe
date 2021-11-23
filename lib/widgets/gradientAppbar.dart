import "package:flutter/material.dart";

import '../themes/custom_colors.dart';

class GradientAppBar extends StatelessWidget {
  final String title;
  final double barHeight = 100.0;

  GradientAppBar(this.title);

  @override
  Widget build(BuildContext context) {
    final double statusbarHeight = MediaQuery.of(context).padding.top;
    // const double statusbarHeight = 10;

    return Container(
      padding: EdgeInsets.only(top: statusbarHeight),
      height: statusbarHeight + barHeight,
      child: Center(
        child: Image.asset(
          "assets/icons/logo_white.png",
          width: MediaQuery.of(context).size.width / 3,
        ),
        // child: Text(
        //   title,
        //   style: const TextStyle(
        //       fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold),
        // ),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [secondaryColor, primaryColor],
            begin: const FractionalOffset(0, 0),
            end: const FractionalOffset(0.6, 0.8),
            stops: const [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
    );
  }
}
