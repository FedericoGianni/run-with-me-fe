import 'dart:convert';

import 'package:flutter/material.dart';

import './event.dart';
import '../dummy_data/dummy_events.dart';
import 'package:http/http.dart' as http;

class Events with ChangeNotifier {
  List<Event> _items = [];

  List<Event> get items {
    return [..._items];
  }

  Event findById(int id) {
    return _items.firstWhere((event) => event.id == id);
  }

  Future<void> fetchAndSetEvents() async {
    final url = Uri.https(
        'https://runwithme-c6e23-default-rtdb.europe-west1.firebasedatabase.app/',
        '/events.json');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<Event> loadedEvents = [];
      extractedData.forEach((eventId, eventData) {
        loadedEvents.add(Event(
          id: int.parse(eventId),
          adminId: eventData['adminId'],
          averageDuration: eventData['averageDuration'],
          averageLength: eventData['averageLength'],
          averagePace: eventData['averagePace'],
          createdAt: eventData['createdAt'],
          currentParticipants: eventData['currentParticipants'],
          date: eventData['date'],
          difficultyLevel: eventData['difficultyLevel'],
          maxParticipants: eventData['maxParticipants'],
          name: eventData['name'],
          startingPintLat: eventData['startingPintLat'],
          startingPintLong: eventData['startingPintLong'],
        ));
      });
      _items = loadedEvents;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addEvent(Event event) async {
    final url = Uri.https(
        'runwithme-c6e23-default-rtdb.europe-west1.firebasedatabase.app',
        '/events.json');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'adminId': event.adminId,
          'averageDuration': event.averageDuration,
          'averageLength': event.averageLength,
          'averagePace': event.averagePace,
          'createdAt': event.createdAt,
          'currentParticipants': event.currentParticipants,
          'date': event.date,
          'difficultyLevel': event.difficultyLevel,
          'maxParticipants': event.maxParticipants,
          'name': event.name,
          'startingPintLat': event.startingPintLat,
          'startingPintLong': event.startingPintLong,
        }),
      );
      final newEvent = Event(
        adminId: event.adminId,
        averageDuration: event.averageDuration,
        averageLength: event.averageLength,
        averagePace: event.averagePace,
        createdAt: event.createdAt,
        currentParticipants: event.currentParticipants,
        date: event.date,
        difficultyLevel: event.difficultyLevel,
        maxParticipants: event.maxParticipants,
        name: event.name,
        startingPintLat: event.startingPintLat,
        startingPintLong: event.startingPintLong,
        id: json.decode(response.body)['id'],
      );
      _items.add(newEvent);
      // _items.insert(0, newEvent); // at the start of the list
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  // Future<void> updateEvent(String id, Event newEvent) async {
  //   final eventIndex = _items.indexWhere((event) => event.id == id);
  //   if (eventIndex >= 0) {
  //     final url = Uri.https(
  //         'https://runwithme-c6e23-default-rtdb.europe-west1.firebasedatabase.app/',
  //         '/Events/$id.json');
  //     await http.patch(url,
  //         body: json.encode({
  //           'title': newEvent.title,
  //           'description': newEvent.description,
  //           'imageUrl': newEvent.imageUrl,
  //           'price': newEvent.price
  //         }));
  //     _items[eventIndex] = newEvent;
  //     notifyListeners();
  //   } else {
  //     print('...');
  //   }
  // }

  // Future<void> deleteEvent(String id) async {
  //   final url = Uri.https(
  //       'https://runwithme-c6e23-default-rtdb.europe-west1.firebasedatabase.app/',
  //       '/Events/$id.json');
  //   final existingEventIndex = _items.indexWhere((event) => event.id == id);
  //   var existingEvent = _items[existingEventIndex];
  //   _items.removeAt(existingEventIndex);
  //   notifyListeners();
  //   final response = await http.delete(url);
  //   if (response.statusCode >= 400) {
  //     _items.insert(existingEventIndex, existingEvent);
  //     notifyListeners();
  //     throw HttpException('Could not delete Event.');
  //   }
  //   existingEvent = null;
  // }
}
