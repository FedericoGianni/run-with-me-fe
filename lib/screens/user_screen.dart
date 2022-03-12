// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';
import 'package:runwithme/themes/custom_colors.dart';
import 'package:runwithme/widgets/search_button.dart';
import '../providers/color_scheme.dart';
import 'package:provider/provider.dart';
import '../widgets/gradientAppbar.dart';
import '../providers/settings_manager.dart';
import '../widgets/search_event_bottomsheet.dart';
import '../widgets/login_form.dart';
import '../widgets/search_button.dart';
import '../providers/user.dart';
import '../widgets/loading_progress_indicator_UNUSED.dart';
import '../widgets/user_info_card.dart';

class UserScreen extends StatefulWidget {
  static const routeName = '/user';

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  List<bool> isSelected = [false, false];

  @override
  Widget build(BuildContext context) {
    final colors = Provider.of<CustomColorScheme>(context);
    final settings = Provider.of<UserSettings>(context);
    final user = Provider.of<User>(context);
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    if (colors.currentMode == 'dark') {
      isSelected = [false, true];
    } else if (colors.currentMode == 'light') {
      isSelected = [true, false];
    }
    if (settings.settings.isLoggedIn) {
      print(user.username);
      return Column(
        children: [
          Column(
            children: [
              Row(
                children: [
                  Container(
                    width: screenWidth / 1.2,
                    child: Text(
                      (user.username ?? 'No Name'),
                      style: TextStyle(
                        overflow: TextOverflow.clip,
                        color: colors.primaryTextColor,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    padding: EdgeInsets.only(top: 30, left: 20, bottom: 5),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: colors.background,
                    ),
                    padding: EdgeInsets.only(top: 0),
                    margin: EdgeInsets.only(right: 10, top: 25),
                    // color: colors.onPrimary,
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.settings,
                        size: 22,
                      ),
                      color: colors.primaryTextColor,
                    ),
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
              Row(
                children: [
                  Container(
                    width: screenWidth / 1.2,
                    child: Text(
                      'USER ID: ' + (user.userId.toString()),
                      style: TextStyle(
                        overflow: TextOverflow.clip,
                        color: colors.primaryTextColor,
                        fontSize: 14,
                      ),
                    ),
                    padding: EdgeInsets.only(left: 20, bottom: 20),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),

              // Center(child: Text('User Info Page')),
            ],
          ),
          Container(
            height: 520,
            child: CustomScrollView(
              // This is needed to avoid overflow
              // shrinkWrap: true,
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.only(
                      bottom: 0, top: 0, left: 0, right: 0),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      children: [
                        Container(
                          child: TextButton(
                            child: Text(
                              'Edit',
                              style: TextStyle(
                                overflow: TextOverflow.clip,
                                color: colors.primaryTextColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {},
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          margin: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 30),
                          decoration: BoxDecoration(
                              color: colors.background,
                              border: Border.all(
                                color: colors.primaryTextColor,
                                width: 1,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          height: 40,
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.start,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.only(
                      bottom: 0, top: 20, left: 20, right: 20),
                  sliver: SliverToBoxAdapter(child: UserInfo(user)),
                ),
                SliverPadding(
                  padding: const EdgeInsets.only(
                      bottom: 0, top: 20, left: 20, right: 20),
                  sliver: SliverToBoxAdapter(
                    child: Container(
                      child: ToggleButtons(
                        children: <Widget>[
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
                              settings.setThemeMode(CustomThemeMode.light);
                            } else {
                              settings.setThemeMode(CustomThemeMode.dark);
                            }
                          });
                        },
                        isSelected: isSelected,
                      ),
                      padding: EdgeInsets.all(20),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.only(
                      bottom: 0, top: 20, left: 20, right: 20),
                  sliver: SliverToBoxAdapter(
                      child: Container(
                    child: TextButton(
                        onPressed: () {
                          settings.userLogout();
                        },
                        child: Text(
                          "logout",
                          style: TextStyle(color: colors.primaryColor),
                        )),
                  )),
                ),
              ],
              anchor: 0,
            ),
          )
        ],
      );
    } else {
      return Container(
        width: double.infinity,
        child: const Center(widthFactor: 0.5, child: LoginForm()),
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
      settings.settings.isLoggedIn
          ? Container(
              child: Text(
                'User Profile',
                style: TextStyle(
                    color: colors.titleColor,
                    fontSize: 40,
                    fontWeight: FontWeight.w700),
              ),
              height: 100,
              padding: EdgeInsets.only(top: 25),
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
