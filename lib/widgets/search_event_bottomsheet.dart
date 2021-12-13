import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../themes/custom_colors.dart';
import '../providers/color_scheme.dart';
import 'package:provider/provider.dart';

class SearchEventBottomSheet extends StatelessWidget {
  const SearchEventBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = Provider.of<CustomColorScheme>(context);

    return Container(
      color: colors.onPrimary,
      height: MediaQuery.of(context).size.height,
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.only(top: 10),
            sliver: SliverAppBar(
              backgroundColor: colors.onPrimary,
              iconTheme: IconThemeData(color: colors.secondaryTextColor),
              elevation: 2,
              stretch: false,
              toolbarHeight: MediaQuery.of(context).padding.top + 100,
              shadowColor: Colors.black,
              expandedHeight: 140,
              primary: true,
              systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent),
              title: Text(
                "Search",
                style: TextStyle(color: colors.secondaryTextColor),
              ),
              titleSpacing: 10,
            ),
          )
        ],
      ),
    );
  }
}
