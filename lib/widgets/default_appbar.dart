import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'gradientAppbar.dart';

class DefaultAppbar extends StatelessWidget {
  const DefaultAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent));
    return GradientAppBar(
        75 + MediaQuery.of(context).padding.top, const [SizedBox.shrink()]);
  }
}
