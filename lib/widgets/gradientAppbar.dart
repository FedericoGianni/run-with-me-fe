import "package:flutter/material.dart";

import '../themes/custom_colors.dart';

class GradientAppBar extends StatelessWidget {
  final List<Widget> children;
  final double barHeight;
  double start;
  double end;

  GradientAppBar(this.barHeight, this.children,
      {this.start = 0.0, this.end = 0.0});

  @override
  Widget build(BuildContext context) {
    final double statusbarHeight = MediaQuery.of(context).padding.top;
    // const double statusbarHeight = 10;

    return Container(
      padding: EdgeInsets.only(top: statusbarHeight),
      height: statusbarHeight + barHeight,
      width: double.infinity,
      child: Center(
        child: Column(
          children: [...children],
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
            begin: FractionalOffset(start, 0),
            end: FractionalOffset(0.6, end),
            stops: const [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
    );
  }
}
