import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/color_scheme.dart';

class CustomSnackbarProvider extends StatelessWidget {
  const CustomSnackbarProvider({
    Key? key,
    required this.ctx,
    required this.message,
  }) : super(key: key);

  final String message;
  final ctx;

  SnackBar provide() {
    final double screenWidth = MediaQuery.of(ctx).size.width;
    final colors = Provider.of<CustomColorScheme>(ctx, listen: false);
    SnackBar snackbar = SnackBar(
      content: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              child: Text(
                message,
                style: TextStyle(
                    color: colors.primaryTextColor,
                    fontSize: 14,
                    overflow: TextOverflow.fade),
              ),
            ),
          ],
        ),
        margin: EdgeInsets.symmetric(horizontal: screenWidth / 7),
        // width: 20,

        padding: const EdgeInsets.all(10),

        decoration: BoxDecoration(
            color: colors.background,
            border: Border.all(
              color: colors.errorColor,
              width: 1,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(15))),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      behavior: SnackBarBehavior.fixed,
      duration: const Duration(seconds: 1),
      padding: const EdgeInsets.only(bottom: 40),
    );

    return snackbar;
  }

  //Don't ducking ask me why but it just works so at this point I'm going with this.
  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
