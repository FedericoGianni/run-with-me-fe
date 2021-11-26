import 'package:flutter/material.dart';

import 'gradientAppbar.dart';

class DefaultAppbar extends StatelessWidget {
  const DefaultAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GradientAppBar(100, const [SizedBox.shrink()]);
  }
}
