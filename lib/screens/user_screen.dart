// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:runwithme/themes/custom_colors.dart';
import 'package:runwithme/widgets/custom_alert_dialog.dart';
import 'package:runwithme/widgets/custom_scroll_behavior.dart';
import 'package:runwithme/widgets/search_button.dart';
import '../classes/multi_device_support.dart';
import '../providers/color_scheme.dart';
import 'package:provider/provider.dart';
import '../widgets/gradientAppbar.dart';
import '../providers/settings_manager.dart';
import '../widgets/search_event_bottomsheet.dart';
import '../widgets/login_form.dart';
import '../widgets/search_button.dart';
import '../providers/user.dart';
import '../widgets/user_info_card.dart';
import 'dart:async';
import 'dart:math';

import 'package:google_api_headers/google_api_headers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';

class UserScreen extends StatefulWidget {
  static const routeName = '/user';

  @override
  State<UserScreen> createState() => UserScreenState();
}

@visibleForTesting
class UserScreenState extends State<UserScreen> {
  List<bool> isSelected = [false, false];

  Future<void> _showMyDialog() async {
    var settings = Provider.of<UserSettings>(context, listen: false);

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: 'Log Out',
          message:
              "Are you sure you would like to log out? \nYou will be missing a lot of cool features",
          onAccept: settings.userLogout,
          onDismiss: () {},
        );
      },
    );
  }

  void refresh() {
    setState(() {
      var settings = Provider.of<UserSettings>(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Provider.of<CustomColorScheme>(context);
    var settings = Provider.of<UserSettings>(context);
    final user = Provider.of<User>(context);
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    var multiDeviceSupport = MultiDeviceSupport(context);
    multiDeviceSupport.init();
    if (colors.currentMode == 'dark') {
      isSelected = [false, true];
    } else if (colors.currentMode == 'light') {
      isSelected = [true, false];
    }
    if (settings.isLoggedIn()) {
      return Column(
        children: [
          Container(
            color: colors.background,
            height: screenHeight - 56 - multiDeviceSupport.tablet * 14,
            child: ScrollConfiguration(
              behavior: CustomScrollBehavior(),
              child: CustomScrollView(
                // This is needed to avoid overflow
                // shrinkWrap: true,
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    collapsedHeight: 140,
                    expandedHeight: 220,
                    toolbarHeight: 10,
                    floating: false,
                    centerTitle: true,
                    //
                    flexibleSpace: FlexibleSpaceBar.createSettings(
                      currentExtent: 100,
                      child: FlexibleSpaceBar(
                        background: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  colors.secondaryColor,
                                  colors.primaryColor
                                ],
                                begin: FractionalOffset(-0.2, 0),
                                end: FractionalOffset(0.9, 0),
                                stops: const [0.0, 1.0],
                                tileMode: TileMode.clamp),
                          ),
                          child: SizedBox(),
                        ),
                        title: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  colors.secondaryColor,
                                  colors.primaryColor
                                ],
                                begin: FractionalOffset(-0.2, 0),
                                end: FractionalOffset(0.9, 0),
                                stops: const [0.0, 1.0],
                                tileMode: TileMode.clamp),
                          ),
                          height: 100,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: screenWidth,
                                    padding: EdgeInsets.only(
                                        top:
                                            25 - 18 * multiDeviceSupport.tablet,
                                        left: 20,
                                        bottom: 5),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: screenWidth / 1.1,
                                              child: Text(
                                                (user.username ?? 'No Name'),
                                                style: TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  color: colors.titleColor,
                                                  fontSize:
                                                      multiDeviceSupport.title,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10, bottom: 10),
                                              child: Text(
                                                'USER ID: ' +
                                                    (user.userId.toString()),
                                                style: TextStyle(
                                                  overflow: TextOverflow.clip,
                                                  color: colors.titleColor,
                                                  fontSize:
                                                      multiDeviceSupport.h3,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: 0,
                                                  left: 20 +
                                                      multiDeviceSupport
                                                              .tablet *
                                                          40),
                                              child: Text(
                                                'Since: ' +
                                                    user.createdAt!
                                                        .toLocal()
                                                        .day
                                                        .toString() +
                                                    '/' +
                                                    user.createdAt!
                                                        .toLocal()
                                                        .month
                                                        .toString() +
                                                    '/' +
                                                    user.createdAt!
                                                        .toLocal()
                                                        .year
                                                        .toString(),
                                                style: TextStyle(
                                                  overflow: TextOverflow.clip,
                                                  color: colors.titleColor,
                                                  fontSize:
                                                      multiDeviceSupport.h3,
                                                ),
                                              ),
                                            )
                                          ],
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.symmetric(
                                  //       horizontal: 20),
                                  //   child: Container(
                                  //     height: 35,
                                  //     // width: 60,
                                  //     child: TextButton(
                                  //       child: Text(
                                  //         'Edit',
                                  //         style: TextStyle(
                                  //           overflow: TextOverflow.clip,
                                  //           color: colors.titleColor,
                                  //           fontSize: multiDeviceSupport.h3,
                                  //           fontWeight: FontWeight.bold,
                                  //         ),
                                  //       ),
                                  //       onPressed: () {
                                  //         print("HEEEEEEEEEEEEEEEE");
                                  //       },
                                  //     ),
                                  //     decoration: BoxDecoration(
                                  //         color: Colors.transparent,
                                  //         border: Border.all(
                                  //           color: colors.titleColor,
                                  //           width: 1,
                                  //         ),
                                  //         borderRadius: BorderRadius.all(
                                  //             Radius.circular(15))),
                                  //   ),
                                  // ),
                                ],
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                              ),
                              // Border line used for separation
                            ],
                          ),
                        ),
                        titlePadding: EdgeInsetsDirectional.zero,
                        centerTitle: false,
                      ),
                    ),
                  ),
                  // User info title
                  SliverPadding(
                    padding: EdgeInsets.only(
                        bottom: 0,
                        top: 40,
                        left: 20 + multiDeviceSupport.tablet * 50,
                        right: 20 + multiDeviceSupport.tablet * 50),
                    sliver: SliverToBoxAdapter(
                        child: Text(
                      'User info',
                      style: TextStyle(
                          color: colors.primaryTextColor,
                          fontSize: multiDeviceSupport.h0),
                    )),
                  ),
                  // Actual list of cards with user infos
                  SliverPadding(
                    padding: EdgeInsets.only(
                        bottom: 0,
                        top: 20,
                        left: 20 + multiDeviceSupport.tablet * 50,
                        right: 20 + multiDeviceSupport.tablet * 50),
                    sliver: SliverToBoxAdapter(child: UserInfo(user)),
                  ),
                  // Grey line
                  SliverPadding(
                    padding: EdgeInsets.only(
                        bottom: 0,
                        top: 40,
                        left: 50 + multiDeviceSupport.tablet * 50,
                        right: 50 + multiDeviceSupport.tablet * 50),
                    sliver: SliverToBoxAdapter(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: colors.onPrimary,
                              width: 3.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // User info title
                  SliverPadding(
                    padding: EdgeInsets.only(
                        bottom: 30,
                        top: 40,
                        left: 20 + multiDeviceSupport.tablet * 50,
                        right: 20 + multiDeviceSupport.tablet * 50),
                    sliver: SliverToBoxAdapter(
                        child: Text(
                      'Settings',
                      style: TextStyle(
                          color: colors.primaryTextColor,
                          fontSize: multiDeviceSupport.h0),
                    )),
                  ),
                  // Actual list of cards with user infos
                  SliverPadding(
                    padding: EdgeInsets.only(
                        bottom: 0,
                        top: 10,
                        left: 20 + multiDeviceSupport.tablet * 50,
                        right: 20 + multiDeviceSupport.tablet * 50),
                    sliver: SliverToBoxAdapter(
                      child: Card(
                        color: colors.onPrimary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 4,
                        margin: EdgeInsets.symmetric(
                            vertical: 0 + multiDeviceSupport.tablet * 10),
                        child: Container(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 0, bottom: 0),
                                    child: SizedBox(
                                      width: 150,
                                      child: Text(
                                        'Theme mode',
                                        style: TextStyle(
                                            color: colors.primaryTextColor,
                                            fontSize: multiDeviceSupport.h2,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 40,
                                    child: ToggleButtons(
                                      borderRadius: BorderRadius.circular(15),
                                      borderColor: colors.background,
                                      selectedColor: colors.primaryColor,
                                      disabledColor: colors.errorColor,
                                      color: colors.secondaryTextColor,
                                      selectedBorderColor: colors.background,
                                      // fillColor: colors.background,
                                      highlightColor: colors.onPrimary,
                                      splashColor: colors.background,
                                      children: const <Widget>[
                                        Icon(Icons.light_mode),
                                        Icon(Icons.dark_mode),
                                      ],
                                      onPressed: (int index) {
                                        setState(() {
                                          for (int buttonIndex = 0;
                                              buttonIndex < isSelected.length;
                                              buttonIndex++) {
                                            if (buttonIndex == index) {
                                              isSelected[buttonIndex] =
                                                  !isSelected[buttonIndex];
                                            } else {
                                              isSelected[buttonIndex] = false;
                                            }
                                          }
                                          if (index == 0) {
                                            settings.setThemeMode(
                                                CustomThemeMode.light);
                                          } else {
                                            settings.setThemeMode(
                                                CustomThemeMode.dark);
                                          }
                                        });
                                      },
                                      isSelected: isSelected,
                                    ),
                                    padding: const EdgeInsets.all(0),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.only(
                        bottom: 0,
                        top: 10,
                        left: 20 + multiDeviceSupport.tablet * 50,
                        right: 20 + multiDeviceSupport.tablet * 50),
                    sliver: SliverToBoxAdapter(
                      child: Card(
                        color: colors.onPrimary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 4,
                        margin: EdgeInsets.symmetric(
                            vertical: 10 + multiDeviceSupport.tablet * 10),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 5, bottom: 5, left: 10),
                              child: TextButton(
                                child: Text(
                                  'Logout',
                                  style: TextStyle(
                                    overflow: TextOverflow.clip,
                                    color: colors.primaryColor,
                                    fontSize: multiDeviceSupport.h2,
                                  ),
                                ),
                                onPressed: _showMyDialog,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.only(
                        bottom: 40,
                        top: 0,
                        left: 20 + multiDeviceSupport.tablet * 50,
                        right: 20 + multiDeviceSupport.tablet * 50),
                    sliver: SliverToBoxAdapter(
                      child: Card(
                        color: colors.onPrimary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 4,
                        margin: EdgeInsets.symmetric(
                            vertical: 10 + multiDeviceSupport.tablet * 10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15, bottom: 15, left: 20),
                                  child: Text(
                                    'About',
                                    style: TextStyle(
                                      overflow: TextOverflow.clip,
                                      color: colors.primaryTextColor,
                                      fontSize: multiDeviceSupport.h2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5, bottom: 15, left: 20),
                                  child: Text(
                                    'Version:',
                                    style: TextStyle(
                                      overflow: TextOverflow.clip,
                                      color: colors.secondaryTextColor,
                                      fontSize: multiDeviceSupport.h2,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5, bottom: 15, right: 20),
                                  child: Text(
                                    '1.014.001',
                                    style: TextStyle(
                                      overflow: TextOverflow.clip,
                                      color: colors.secondaryTextColor,
                                      fontSize: multiDeviceSupport.h2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5, bottom: 5, left: 20),
                                  child: Text(
                                    'Developed by:',
                                    style: TextStyle(
                                      overflow: TextOverflow.clip,
                                      color: colors.secondaryTextColor,
                                      fontSize: multiDeviceSupport.h2,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5, bottom: 5, right: 20),
                                  child: Text(
                                    'Federico Deicas',
                                    style: TextStyle(
                                      overflow: TextOverflow.clip,
                                      color: colors.secondaryTextColor,
                                      fontSize: multiDeviceSupport.h2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 0, bottom: 15, left: 20),
                                  child: Text(
                                    'and',
                                    style: TextStyle(
                                      overflow: TextOverflow.clip,
                                      color: colors.secondaryTextColor,
                                      fontSize: multiDeviceSupport.h2,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 0, bottom: 15, right: 20),
                                  child: Text(
                                    'Daniele De Vincenti',
                                    style: TextStyle(
                                      overflow: TextOverflow.clip,
                                      color: colors.secondaryTextColor,
                                      fontSize: multiDeviceSupport.h2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
                anchor: 0,
              ),
            ),
          )
        ],
      );
    } else {
      return Container(
        width: double.infinity,
        child: const Center(
          widthFactor: 0.5,
          child: LoginForm(),
        ),
      );
    }
  }
}

class UserAppbar extends StatelessWidget {
  const UserAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = Provider.of<CustomColorScheme>(context);
    final settings = Provider.of<UserSettings>(context);

    return GradientAppBar(100, [
      settings.isLoggedIn()
          ? Container(
              child: Text(
                'User Profile',
                style: TextStyle(
                    color: colors.titleColor,
                    fontSize: 40,
                    fontWeight: FontWeight.w700),
              ),
              height: 100,
              padding: const EdgeInsets.only(top: 25),
            )
          : Container(
              height: 100,
              child: Center(
                child: Image.asset(
                  "assets/icons/logo_white.png",
                  width: 130,
                ),
              ),
            ),
    ]);
  }
}
