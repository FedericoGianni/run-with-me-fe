import 'package:flutter/material.dart';

import '../dummy_data/dummy_events.dart';
import '../widgets/event_card_text_only.dart';

class EventsScreen extends StatelessWidget {
  static const routeName = '/events';
  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: const EdgeInsets.all(25),
      // children: dummy
      //     .map(
      //       (eventData) => EventItem(eventData, 1, dummy.length.toDouble()),
      //     )
      //     .toList(),
      children: [
        ...List.generate(dummy.length, (index) {
          return EventItem(dummy[index], index, dummy.length.toDouble());
        })
      ],
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 3 / 2.5,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
    );
  }
}
