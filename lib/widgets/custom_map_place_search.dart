import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runwithme/providers/color_scheme.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../classes/multi_device_support.dart';
import '../providers/locationHelper.dart';
import 'custom_scroll_behavior.dart';

class CustomMapPlaceSearch extends StatefulWidget {
  const CustomMapPlaceSearch({Key? key}) : super(key: key);

  @override
  State<CustomMapPlaceSearch> createState() => _CustomMapPlaceSearchState();
}

class _CustomMapPlaceSearchState extends State<CustomMapPlaceSearch> {
  var _controller = TextEditingController();
  var uuid = Uuid();
  late Map<String, Object> _place;
  String kPLACES_API_KEY = "************REMOVED************";

  String _sessionToken = Uuid().v4();
  List<dynamic> _placeList = [];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      _onChanged();
    });
  }

  _onChanged() async {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }

    LocationHelper()
        .getSuggestion(input: _controller.text, sessionToken: _sessionToken)
        .then((value) {
      if (mounted) {
        setState(() {
          _placeList = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Provider.of<CustomColorScheme>(context);
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final locationHelper = Provider.of<LocationHelper>(context, listen: false);
    var multiDeviceSupport = MultiDeviceSupport(context);
    multiDeviceSupport.init();
    return AlertDialog(
      backgroundColor: colors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      content: SizedBox(
        height: 350 + multiDeviceSupport.tablet * 100,
        width: 500,
        child: Column(
          children: [
            Align(
              child: TextField(
                autofocus: true,
                controller: _controller,
                style: TextStyle(
                    color: colors.primaryTextColor,
                    fontSize: multiDeviceSupport.h2),
                decoration: InputDecoration(
                  hintText: "Search",
                  hintStyle: TextStyle(
                      color: colors.secondaryTextColor,
                      fontSize: multiDeviceSupport.h2),
                  fillColor: colors.errorColor,
                  focusColor: colors.primaryTextColor,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  iconColor: colors.secondaryTextColor,
                  prefixIconColor: colors.secondaryTextColor,
                  prefixIcon: const Icon(Icons.map),
                  suffixIcon: IconButton(
                    onPressed: () {
                      _controller.clear();
                    },
                    icon: const Icon(Icons.cancel),
                  ),
                ),
              ),
            ),
            Container(
              height: 300 + multiDeviceSupport.tablet * 100,
              width: screenWidth,
              child: ScrollConfiguration(
                behavior: CustomScrollBehavior(),
                child: CustomScrollView(
                  // This is needed to avoid overflow
                  // shrinkWrap: true,
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.only(
                          bottom: 0, top: 0, left: 0, right: 0),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _placeList.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  onTap: () async {
                                    _place =
                                        await locationHelper.getPlaceDetails(
                                            placeId: _placeList[index]
                                                ['place_id'],
                                            sessionToken: _sessionToken);
                                    Navigator.of(context).pop(_place);
                                  },
                                  title: Text(
                                    _placeList[index]["description"],
                                    style: TextStyle(
                                        color: colors.primaryTextColor,
                                        fontSize: multiDeviceSupport.h2),
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
