// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';
import '../classes/multi_device_support.dart';
import '../themes/custom_colors.dart';
import 'search_event_bottomsheet.dart';
import '../providers/color_scheme.dart';
import 'package:provider/provider.dart';

class SearchButton extends StatelessWidget {
  const SearchButton(this.icon, this.text,
      {required this.formValues, required this.onSubmitting, Key? key})
      : super(key: key);
  final Icon icon;
  final Text text;
  final Function(Map<String, dynamic>) onSubmitting;
  final Map<String, dynamic> formValues;

  @override
  Widget build(BuildContext context) {
    final colors = Provider.of<CustomColorScheme>(context);
    final double screenWidth = MediaQuery.of(context).size.width;

    var multiDeviceSupport = MultiDeviceSupport(context);
    multiDeviceSupport.init();

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            isScrollControlled: true,
            backgroundColor: colors.errorColor,
            shape: const RoundedRectangleBorder(
                borderRadius: const BorderRadius.vertical(
                    top: const Radius.circular(15))),
            context: context,
            constraints: BoxConstraints(
              maxWidth: multiDeviceSupport.isLandscape == 1
                  ? screenWidth / 1.2
                  : double.infinity,
            ),
            builder: (_) {
              return SearchEventBottomSheet(
                formValues: formValues,
                onFormAccept: (value) {
                  onSubmitting(value);
                },
              );
            });
      },
      child: Container(
        margin: const EdgeInsets.only(
          // left: MediaQuery.of(context).size.width / 10,
          // right: MediaQuery.of(context).size.width / 10,
          top: 45,
        ),
        height: 45,
        width: MediaQuery.of(context).size.width / 1.5,
        padding: const EdgeInsets.only(left: 25),
        decoration: BoxDecoration(
          color: colors.background,
          // set border width
          borderRadius: const BorderRadius.all(
            Radius.circular(10.0),
          ), // set rounded corner radius
        ),
        // set rounded corner radius
        child: Row(
          children: [
            icon,
            text,
          ],
        ),
      ),
    );
  }
}
