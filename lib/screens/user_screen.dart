import 'package:flutter/material.dart';
import 'package:runwithme/themes/custom_colors.dart';

import '../widgets/gradientAppbar.dart';

class UserScreen extends StatelessWidget {
  static const routeName = '/user';
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('User Info Page'));
  }
}

class UserAppbar extends StatelessWidget {
  const UserAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GradientAppBar(100, [
      Container(
        child: Text(
          'User Profile',
          style: TextStyle(
              color: onPrimary, fontSize: 40, fontWeight: FontWeight.w700),
        ),
        height: 100,
        padding: EdgeInsets.only(top: 25),
      )
    ]);
  }
}
