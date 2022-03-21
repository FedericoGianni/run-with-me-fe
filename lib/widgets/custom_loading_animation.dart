import 'package:flutter/material.dart';
import '../themes/custom_colors.dart';

class CustomLoadingAnimation extends StatefulWidget {
  const CustomLoadingAnimation({Key? key}) : super(key: key);

  @override
  _CustomLoadingAnimationState createState() => _CustomLoadingAnimationState();
}

class _CustomLoadingAnimationState extends State<CustomLoadingAnimation>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 800),
    lowerBound: 0.8,
    upperBound: 1,
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOut,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              "assets/icons/logo_gradient.png",
              width: 180,
            ),
          ),
        ),
      ),
    );
  }
}
