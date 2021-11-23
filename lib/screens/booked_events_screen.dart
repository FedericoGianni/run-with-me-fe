import 'package:flutter/material.dart';

import '../dummy_data/dummy_events.dart';
import '../widgets/event_card_text_only.dart';

class BookedEventsScreen extends StatelessWidget {
  static const routeName = '/booked';
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Booked Events Page'));
  }
}
