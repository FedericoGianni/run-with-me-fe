import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:runwithme/providers/event.dart';

import '../classes/multi_device_support.dart';
import '../providers/color_scheme.dart';
import '../providers/locationHelper.dart';
import 'custom_sort_by_button.dart';

class SortByRow extends StatelessWidget {
  const SortByRow(
      {required this.onTap,
      required this.eventLists,
      required this.currentSortButton,
      Key? key})
      : super(key: key);

  final Function(SortButton, List<List<Event>>) onTap;
  final List<List<Event>> eventLists;
  final SortButton currentSortButton;

  void _sortEvents(sortBy, locationHelper) {
    for (var i = 0; i < eventLists.length; i++) {
      List<Event> currentEventList = eventLists[i];

      if (sortBy == SortButton.distance) {
        Position userPosition = locationHelper.getLastKnownPosition();

        currentEventList.sort(
          (a, b) => LocationHelper()
              .getDistanceBetween(
                startLatitude: userPosition.latitude,
                startLongitude: userPosition.longitude,
                endLatitude: a.startingPintLat,
                endLongitude: a.startingPintLong,
              )
              .compareTo(
                LocationHelper().getDistanceBetween(
                  startLatitude: userPosition.latitude,
                  startLongitude: userPosition.longitude,
                  endLatitude: b.startingPintLat,
                  endLongitude: b.startingPintLong,
                ),
              ),
        );
      } else if (sortBy == SortButton.difficulty) {
        currentEventList
            .sort((a, b) => a.difficultyLevel.compareTo(b.difficultyLevel));
      } else if (sortBy == SortButton.lenght) {
        currentEventList
            .sort((a, b) => a.averageLength.compareTo(b.averageLength));
      } else if (sortBy == SortButton.duration) {
        currentEventList
            .sort((a, b) => a.averageDuration.compareTo(b.averageDuration));
      } else if (sortBy == SortButton.date) {
        currentEventList.sort((a, b) => a.date.compareTo(b.date));
      }
    }
    onTap(sortBy, eventLists);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Provider.of<CustomColorScheme>(context);
    final locationHelper = Provider.of<LocationHelper>(context, listen: false);

    return Container(
      color: colors.background,
      padding: EdgeInsets.only(top: 15, bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SortByButton(
            title: 'Distance',
            color: colors.secondaryColor,
            id: SortButton.distance,
            activeId: currentSortButton,
            onPressed: () {
              _sortEvents(SortButton.distance, locationHelper);
            },
          ),
          SortByButton(
            title: 'Date',
            color: Color.fromARGB(255, 102, 173, 97),
            id: SortButton.date,
            activeId: currentSortButton,
            onPressed: () {
              _sortEvents(SortButton.date, locationHelper);
            },
          ),
          SortByButton(
            title: 'Difficulty',
            color: Color.fromARGB(255, 80, 159, 120),
            id: SortButton.difficulty,
            activeId: currentSortButton,
            onPressed: () {
              _sortEvents(SortButton.difficulty, locationHelper);
            },
          ),
          SortByButton(
            title: 'Lenght',
            color: Color.fromARGB(255, 59, 146, 143),
            id: SortButton.lenght,
            activeId: currentSortButton,
            onPressed: () {
              _sortEvents(SortButton.lenght, locationHelper);
            },
          ),
          SortByButton(
            title: 'Duration',
            color: colors.primaryColor,
            id: SortButton.duration,
            activeId: currentSortButton,
            onPressed: () {
              _sortEvents(SortButton.duration, locationHelper);
            },
          ),
        ],
      ),
    );
  }
}
