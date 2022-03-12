import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:intl/intl.dart';
import '../themes/custom_colors.dart';
import '../providers/event.dart';
import 'rating.dart';
import '../screens/event_details_screen.dart';
import '../providers/color_scheme.dart';
import 'package:provider/provider.dart';
import '../providers/user.dart';

// ignore: camel_case_types
class UserInfo extends StatelessWidget {
  final User user;

  const UserInfo(this.user);

  @override
  Widget build(BuildContext context) {
    final colors = Provider.of<CustomColorScheme>(context);

    // name = name.replaceRange(5, name.length, '...');
    return Card(
      color: colors.onPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      margin: const EdgeInsets.all(0),
      child: Container(
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'User info',
                  style: TextStyle(
                    fontSize: 20,
                    color: colors.primaryTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  UserInfoFilling('Name', user.name ?? ''),
                  UserInfoFilling('Surname', user.surname ?? ''),
                  UserInfoFilling('Height', user.height.toString()),
                  UserInfoFilling(
                      'Fitness Level', user.fitnessLevel.toString()),
                ],
              ),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
    );
  }
}

class UserInfoFilling extends StatelessWidget {
  final String title;
  final String description;

  const UserInfoFilling(this.title, this.description);

  @override
  Widget build(BuildContext context) {
    final colors = Provider.of<CustomColorScheme>(context);
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                title,
                style: TextStyle(color: colors.primaryTextColor, fontSize: 18),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 5, bottom: 10),
              child: Text(
                description,
                style:
                    TextStyle(color: colors.secondaryTextColor, fontSize: 18),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
