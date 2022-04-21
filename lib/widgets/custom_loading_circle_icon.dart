///{@category Widgets}

import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:provider/provider.dart';
import '../providers/color_scheme.dart';
import '../themes/custom_colors.dart';

class CustomLoadingCircleIcon extends StatefulWidget {
  const CustomLoadingCircleIcon({Key? key}) : super(key: key);

  @override
  State<CustomLoadingCircleIcon> createState() =>
      _CustomLoadingCircleIconState();
}

/// AnimationControllers can be created with `vsync: this` because of TickerProviderStateMixin.
class _CustomLoadingCircleIconState extends State<CustomLoadingCircleIcon>
    with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Provider.of<CustomColorScheme>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CircularProgressIndicator(
        strokeWidth: 3,
        color: colors.secondaryTextColor,
        value: controller.value,
        semanticsLabel: 'Linear progress indicator',
      ),
    );
  }
}
