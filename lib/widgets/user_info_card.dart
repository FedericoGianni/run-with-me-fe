import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:runwithme/providers/locationHelper.dart';
import 'package:uuid/uuid.dart';
// import 'package:intl/intl.dart';
import '../classes/multi_device_support.dart';
import '../themes/custom_colors.dart';
import '../providers/event.dart';
import 'rating.dart';
import '../screens/event_details_screen.dart';
import '../providers/color_scheme.dart';
import 'package:provider/provider.dart';
import '../providers/user.dart';

var sexDict = {0: 'Not known', 1: 'Male', 2: 'Female', 9: 'Not applicable'};

// ignore: camel_case_types
class UserInfo extends StatelessWidget {
  final User user;

  const UserInfo(this.user);

  @override
  Widget build(BuildContext context) {
    final colors = Provider.of<CustomColorScheme>(context);
    var multiDeviceSupport = MultiDeviceSupport(context);
    multiDeviceSupport.init();
    // name = name.replaceRange(5, name.length, '...');
    return Column(
      children: [
        Card(
          color: colors.onPrimary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 4,
          margin: EdgeInsets.symmetric(
              vertical: 10 + multiDeviceSupport.tablet * 10),
          child: Container(
            child: Column(
              children: [
                UserInfoFilling('Name', user.name ?? ''),
                UserInfoFilling('Surname', user.surname ?? ''),
                UserInfoFilling('Email', user.email ?? ''),
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
        ),
        Card(
          color: colors.onPrimary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 4,
          margin: EdgeInsets.symmetric(
              vertical: 10 + multiDeviceSupport.tablet * 10),
          child: Container(
            child: Column(
              children: [
                UserInfoFilling('Height', user.height.toString()),
                UserInfoFilling('Age', user.age.toString()),
                UserInfoFilling('Sex', sexDict[user.sex] ?? 'N/A'),
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
        ),
        Card(
          color: colors.onPrimary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 4,
          margin: EdgeInsets.symmetric(
              vertical: 10 + multiDeviceSupport.tablet * 10),
          child: Container(
            child: Column(
              children: [
                UserInfoFilling('Fitness Level', user.fitnessLevel.toString()),
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
        ),
        Card(
          color: colors.onPrimary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 4,
          margin: EdgeInsets.symmetric(
              vertical: 10 + multiDeviceSupport.tablet * 10),
          child: Container(
            child: Column(
              children: [
                UserInfoFilling(
                  'Default location',
                  user.cityName ?? '',
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
        ),
      ],
    );
  }
}

class UserInfoFilling extends StatelessWidget {
  final String title;
  final String description;

  const UserInfoFilling(this.title, this.description);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    var multiDeviceSupport = MultiDeviceSupport(context);
    multiDeviceSupport.init();

    final colors = Provider.of<CustomColorScheme>(context);
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                title,
                style: TextStyle(
                    color: colors.primaryTextColor,
                    fontSize: multiDeviceSupport.h1),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: 5, bottom: 10 + multiDeviceSupport.tablet * 5),
              child: SizedBox(
                width: screenWidth / 1.5,
                child: Text(
                  description,
                  style: TextStyle(
                      color: colors.secondaryTextColor,
                      fontSize: multiDeviceSupport.h2,
                      overflow: TextOverflow.ellipsis),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
