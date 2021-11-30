import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../themes/custom_colors.dart';

class SearchEventBottomSheet extends StatelessWidget {
  const SearchEventBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: onPrimary,
      height: MediaQuery.of(context).size.height,
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.only(top: 10),
            sliver: SliverAppBar(
              backgroundColor: onPrimary,
              iconTheme: const IconThemeData(color: secondaryTextColor),
              elevation: 2,
              stretch: false,
              toolbarHeight: MediaQuery.of(context).padding.top + 100,
              shadowColor: Colors.black,
              expandedHeight: 140,
              primary: true,
              systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent),
              title: const Text(
                "Search",
                style: TextStyle(color: secondaryTextColor),
              ),
              titleSpacing: 10,
            ),
          )
        ],
      ),
    );
  }
}
