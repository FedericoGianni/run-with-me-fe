import 'dart:convert';

import 'package:flutter/material.dart';

import './event.dart';
import '../dummy_data/dummy_events.dart';

class Events with ChangeNotifier {
  final List<Event> _items = [...dummy];

  List<Event> get items {
    return [..._items];
  }

  Event findById(int id) {
    return _items.firstWhere((event) => event.id == id);
  }

  Future<void> addEvent(Event event) async {
    // final newEvent = Event(id: -1, createdAt: null
    // );
    // _items.add(newEvent);
    // notifyListeners();
  }
}
