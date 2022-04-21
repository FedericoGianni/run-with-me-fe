///{@category Widgets}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runwithme/providers/color_scheme.dart';
import 'package:runwithme/providers/settings_manager.dart';

import '../classes/multi_device_support.dart';
import '../providers/page_index.dart';

class PermissionMessage extends StatelessWidget {
  const PermissionMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = Provider.of<CustomColorScheme>(context);
    final settings = Provider.of<UserSettings>(context);
    final double screenHeight = MediaQuery.of(context).size.height;
    final pageIndex = Provider.of<PageIndex>(context, listen: false);
    var multiDeviceSupport = MultiDeviceSupport(context);
    multiDeviceSupport.init();
    return SizedBox(
      //height: double.infinity,
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
                      fontSize: multiDeviceSupport.title,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0, bottom: 30),
                  child: Text(
                    'You need permissions to view this page',
                    style: TextStyle(
                        color: colors.primaryTextColor,
                        fontSize: multiDeviceSupport.h3),
                  ),
                ),
                Container(
                  height: 35 + multiDeviceSupport.tablet * 5,
                  width: 80 + multiDeviceSupport.tablet * 20,
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
                          fontSize: multiDeviceSupport.h3,
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
