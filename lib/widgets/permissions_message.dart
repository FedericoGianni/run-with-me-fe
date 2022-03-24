import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runwithme/providers/color_scheme.dart';
import 'package:runwithme/providers/settings_manager.dart';

import '../providers/page_index.dart';

class PermissionMessage extends StatelessWidget {
  const PermissionMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = Provider.of<CustomColorScheme>(context);
    final settings = Provider.of<UserSettings>(context);
    final double screenHeight = MediaQuery.of(context).size.height;
    final pageIndex = Provider.of<PageIndex>(context, listen: false);
    return SizedBox(
      height: double.infinity,
      child: Column(
        children: [
          Center(
            heightFactor: 4.5,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Ohoh",
                    style: TextStyle(
                      color: colors.primaryColor,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0, bottom: 30),
                  child: Text(
                    'You need permissions to view this page',
                    style:
                        TextStyle(color: colors.primaryTextColor, fontSize: 14),
                  ),
                ),
                Container(
                  height: 35,
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: colors.secondaryColor,
                  ),
                  child: TextButton(
                    onPressed: () => {pageIndex.setPage(Screens.USER.index)},
                    child: Text(
                      ' Login ',
                      style: TextStyle(
                          color: colors.primaryTextColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
