import 'package:flutter/material.dart';

import '../dummy_data/dummy_events.dart';
import '../widgets/event_card_text_only.dart';

class UserScreen extends StatelessWidget {
  static const routeName = '/user';
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('User Info Page'));
  }
}
