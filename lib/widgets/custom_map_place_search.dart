import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runwithme/providers/color_scheme.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'custom_scroll_behavior.dart';

class CustomMapPlaceSearch extends StatefulWidget {
  const CustomMapPlaceSearch({Key? key}) : super(key: key);

  @override
  State<CustomMapPlaceSearch> createState() => _CustomMapPlaceSearchState();
}

class _CustomMapPlaceSearchState extends State<CustomMapPlaceSearch> {
  var _controller = TextEditingController();
  var uuid = Uuid();
  String _sessionToken = Uuid().v4();
  List<dynamic> _placeList = [];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      _onChanged();
    });
  }

  _onChanged() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }
    getSuggestion(_controller.text);
  }

  void getSuggestion(String input) async {
    String kPLACES_API_KEY = "************REMOVED************";
    String type = '(regions)';
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';

    String url =
        '$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken';
    print(url);
    final request = Uri.parse(url);
    var response = await http.get(request);
    if (response.statusCode == 200) {
      print("heiii");
      if (mounted) {
        setState(() {
          _placeList = json.decode(response.body)['predictions'];
        });
      }
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Provider.of<CustomColorScheme>(context);
    final double screenWidth = MediaQuery.of(context).size.width;

    return AlertDialog(
      backgroundColor: colors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      content: SizedBox(
        height: 350,
        child: Column(
          children: [
            Align(
              child: TextField(
                autofocus: true,
                controller: _controller,
                style: TextStyle(color: colors.primaryTextColor),
                decoration: InputDecoration(
                  hintText: "Search",
                  hintStyle: TextStyle(color: colors.secondaryTextColor),
                  fillColor: colors.errorColor,
                  focusColor: colors.primaryTextColor,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  iconColor: colors.secondaryTextColor,
                  prefixIconColor: colors.secondaryTextColor,
                  prefixIcon: Icon(Icons.map),
                  suffixIcon: IconButton(
                    onPressed: () {
                      _controller.clear();
                    },
                    icon: Icon(Icons.cancel),
                  ),
                ),
              ),
            ),
            Container(
              height: 300,
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
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _placeList.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  onTap: () {
                                    // print(_placeList[index]);
                                    Navigator.of(context)
                                        .pop(_placeList[index]);
                                  },
                                  title: Text(
                                    _placeList[index]["description"],
                                    style: TextStyle(
                                        color: colors.primaryTextColor),
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
