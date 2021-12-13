import "package:flutter/material.dart";
import '../providers/color_scheme.dart';
import 'package:provider/provider.dart';
// import '../themes/custom_colors.dart';

class GradientAppBar extends StatelessWidget {
  final List<Widget> children;
  final double barHeight;

  GradientAppBar(this.barHeight, this.children);

  @override
  Widget build(BuildContext context) {
    final double statusbarHeight = MediaQuery.of(context).padding.top;
    // const double statusbarHeight = 10;
    final colors = Provider.of<CustomColorScheme>(context);

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
            colors: [colors.secondaryColor, colors.primaryColor],
            begin: FractionalOffset(-0.2, 0),
            end: FractionalOffset(0.9, 0),
            stops: const [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
    );
  }
}
