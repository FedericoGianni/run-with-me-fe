import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:runwithme/providers/locationHelper.dart';
import 'package:runwithme/widgets/custom_slider.dart';
import '../themes/custom_colors.dart';
import '../providers/color_scheme.dart';
import 'package:provider/provider.dart';

import 'custom_loading_circle_icon.dart';
import 'custom_map_place_search.dart';
import 'custom_scroll_behavior.dart';

class SearchEventBottomSheet extends StatefulWidget {
  SearchEventBottomSheet({
    required this.formValues,
    required this.onFormAccept,
    Key? key,
  }) : super(key: key);

  Map<String, dynamic> formValues;
  late final Function(Map<String, dynamic>) onFormAccept;
  bool searching = false;

  @override
  State<SearchEventBottomSheet> createState() => _SearchEventBottomSheetState();
}

class _SearchEventBottomSheetState extends State<SearchEventBottomSheet> {
  // double _currentSliderValue = 0;
  final _form = GlobalKey<FormState>();

  void _clearForm() {
    setState(() {
      // _currentSliderValue = 0;
      widget.formValues = {
        'show_full': false,
        'slider_value': 0.0,
        'city_name': '',
        'city_lat': '',
        'city_long': ''
      };
    });
  }

  void acceptAndClose() {
    final isValid = _form.currentState?.validate();
    if (isValid == null || !isValid) {
      return;
    }
    // widget.formValues['show_full'] = _isSwitched.toString();
    // widget.formValues['distance'] = ((_currentSliderValue + 1) * 5).toString();
    print(widget.formValues);
    print("Accepting and closing bottomsheet");
    widget.onFormAccept(widget.formValues);
    Navigator.pop(context);
  }

  void validate() {}

  Future<void> _showMapDialog() async {
    print("hey");
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return CustomMapPlaceSearch();
      },
    ).then((value) {
      widget.formValues['city_name'] = value['name'].toString();
      widget.formValues['city_lat'] = value['location']['lat'];
      widget.formValues['city_long'] = value['location']['lng'];
      setState(() {
        print("bellazio");
        print(widget.formValues.keys);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Provider.of<CustomColorScheme>(context);
    final locationHelper = Provider.of<LocationHelper>(context, listen: false);

    final double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      // color: colors.onPrimary,
      height: MediaQuery.of(context).size.height / 1.5,

      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: ScrollConfiguration(
        behavior: CustomScrollBehavior(),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.chevron_left_outlined,
                      size: 30,
                      color: colors.primaryTextColor,
                    ),
                  ),
                  Text(
                    'Search for an event',
                    style: TextStyle(
                      color: colors.primaryTextColor,
                      fontSize: 20,
                    ),
                  ),
                  IconButton(
                    onPressed: acceptAndClose,
                    icon: Icon(
                      Icons.check,
                      size: 30,
                      color: colors.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: screenWidth / 7, right: screenWidth / 7, bottom: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Show events that are full:',
                    style:
                        TextStyle(color: colors.primaryTextColor, fontSize: 16),
                  ),
                  Switch(
                    value: widget.formValues['show_full'],
                    onChanged: (value) {
                      setState(() {
                        widget.formValues['show_full'] = value;
                      });
                    },
                    activeTrackColor: colors.primaryColorLight,
                    activeColor: colors.primaryColor,
                    inactiveThumbColor: colors.secondaryTextColor,
                    inactiveTrackColor: colors.onPrimary,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: screenWidth / 7,
                right: screenWidth / 7,
                bottom: 15,
              ),
              child: Text(
                'Location: ',
                style: TextStyle(color: colors.primaryTextColor, fontSize: 16),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: screenWidth / 7, right: screenWidth / 7, bottom: 40),
              child: Form(
                key: _form,
                child: FormField(
                  builder: (FormFieldState<int> state) {
                    return GestureDetector(
                      onTap: _showMapDialog,
                      // initialValue: markerPosition.toString(),,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 2.3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: state.hasError
                                  ? BoxDecoration(
                                      color: colors.onPrimary,
                                      border:
                                          Border.all(color: colors.errorColor),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(10.0),
                                      ),
                                    )
                                  : BoxDecoration(
                                      color: colors.onPrimary,
                                      border:
                                          Border.all(color: colors.onPrimary),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(10.0),
                                      ),
                                    ),
                              height: 60,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      widget.formValues['city_name'] == ''
                                          ? Text(
                                              'Location',
                                              style: TextStyle(
                                                  color:
                                                      colors.secondaryTextColor,
                                                  fontSize: 16),
                                            )
                                          : Text(
                                              widget.formValues['city_name']
                                                  .toString()
                                                  .split(',')[0],
                                              style: TextStyle(
                                                  color:
                                                      colors.primaryTextColor,
                                                  fontSize: 16),
                                            ),
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              widget.searching = true;
                                            });
                                            Position position = locationHelper
                                                .getLastKnownPositionAndUpdate();
                                            if (mounted) {
                                              setState(() {
                                                widget.formValues['city_name'] =
                                                    'Current location';
                                                widget.formValues['city_lat'] =
                                                    position.latitude;
                                                widget.formValues['city_long'] =
                                                    position.longitude;
                                                widget.searching = false;
                                              });
                                            } else {
                                              print(
                                                  "Search bottomSheet unmounted");
                                            }
                                          },
                                          icon: !widget.searching
                                              ? Icon(
                                                  Icons.location_on_outlined,
                                                  color:
                                                      colors.secondaryTextColor,
                                                )
                                              : CustomLoadingCircleIcon())
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            state.hasError
                                ? Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      state.errorText ?? 'Nope',
                                      style: TextStyle(
                                        color: colors.errorColor,
                                        fontSize: 12.2,
                                      ),
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                      ),
                    );
                  },
                  validator: (value) {
                    if (widget.formValues['city_name'] == '') {
                      return 'Please provide a value.';
                    }
                    return null;
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: screenWidth / 7,
                right: screenWidth / 7,
              ),
              child: Text(
                'Distance: 0km - ' +
                    ((widget.formValues['slider_value'] + 1) * 5)
                        .toString()
                        .split('.')[0] +
                    'km',
                style: TextStyle(color: colors.primaryTextColor, fontSize: 16),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 5,
                left: screenWidth / 7,
                right: screenWidth / 7,
              ),
              child: Text(
                'Maximum search distance in km',
                style:
                    TextStyle(color: colors.secondaryTextColor, fontSize: 12),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(
                  left: screenWidth / 8,
                  right: screenWidth / 8,
                  top: 10,
                ),
                child: Column(
                  children: [
                    customSlider(
                      sliderValue: widget.formValues['slider_value'],
                      onSliderMove: (value) {
                        setState(() {
                          widget.formValues['slider_value'] = value;
                        });
                      },
                    ),
                  ],
                )),
            Padding(
              padding: EdgeInsets.only(
                left: screenWidth / 10,
                right: screenWidth / 11,
                bottom: 40,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  index = (index + 1) * 5;
                  return Text(
                    "$index",
                    style: TextStyle(color: colors.secondaryTextColor),
                  );
                }),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: screenWidth / 7, right: screenWidth / 7, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    child: Text(
                      'Reset',
                      style: TextStyle(
                          color: colors.secondaryTextColor, fontSize: 14),
                    ),
                    onPressed: _clearForm,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
