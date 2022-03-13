import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runwithme/providers/color_scheme.dart';
import 'package:runwithme/providers/settings_manager.dart';

class PermissionMessage extends StatelessWidget {
  const PermissionMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = Provider.of<CustomColorScheme>(context);
    final settings = Provider.of<UserSettings>(context);
    final double screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      height: double.infinity,
      child: Column(
        children: [
          Container(
            color: colors.onPrimary,
            height: 123,
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 50,
              bottom: 20,
            ),
            child: Image.asset(
              "assets/icons/logo_gradient.png",
              width: 130,
            ),
          ),
          Container(
            height: screenHeight - 200,
            padding: EdgeInsets.symmetric(vertical: (screenHeight - 300) / 2),
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
                  padding: const EdgeInsets.all(8.0),
                  child: Text('You need permissions to view booked events'),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
