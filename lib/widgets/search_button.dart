import 'package:flutter/material.dart';
import '../themes/custom_colors.dart';
import 'search_event_bottomsheet.dart';
import '../providers/color_scheme.dart';
import 'package:provider/provider.dart';

class SearchButton extends StatelessWidget {
  final Icon icon;
  final Text text;
  const SearchButton(this.icon, this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = Provider.of<CustomColorScheme>(context);

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
                borderRadius: const BorderRadius.vertical(
                    top: const Radius.circular(15))),
            context: context,
            builder: (_) {
              return const SearchEventBottomSheet();
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
          color: colors.onPrimary,
          // set border width
          borderRadius: BorderRadius.all(
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
