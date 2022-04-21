///{@category Widgets}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/color_scheme.dart';
import '../providers/settings_manager.dart';
import 'gradient_appbar.dart';

class DefaultAppbar extends StatelessWidget {
  const DefaultAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      child: Container(
        height: 130,
        padding: EdgeInsets.only(
          top: 10 + MediaQuery.of(context).padding.top,
          bottom: 10,
        ),
        child: Image.asset(
          "assets/icons/logo_gradient.png",
          width: 130,
        ),
      ),
    );
  }
}
