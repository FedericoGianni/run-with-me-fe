import 'dart:convert';

import 'package:flutter/material.dart';

import './event.dart';
import '../classes/config.dart';
import '../dummy_data/dummy_events.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Events with ChangeNotifier {
  List<Event> _items = [];
  final secureStorage = const FlutterSecureStorage();

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
    var request =
        http.MultipartRequest('POST', Uri.parse(Config.baseUrl + '/event/add'));

    String? jwt = await secureStorage.read(key: 'jwt');
    if (jwt != null) {
      var headers = {'Authorization': 'Bearer ' + jwt};
      request.headers.addAll(headers);
    }

    print("date (timestamp secondi):" +
        (DateTime.parse(event.date).millisecondsSinceEpoch / 1000)
            .round()
            .toString());

    print('starting_point_long' + event.startingPintLong.toString());
    print('starting_point_lat' + event.startingPintLat.toString());

    request.fields.addAll({
      'date': (DateTime.parse(event.date).millisecondsSinceEpoch / 1000)
          .round()
          .toString(),
      'starting_point_long': event.startingPintLong.toStringAsFixed(14),
      'starting_point_lat': event.startingPintLat.toStringAsFixed(14),
      'avg_duration': event.averageDuration.toString(),
      'avg_length': event.averageLength.toString(),
      'max_participants': event.maxParticipants.toString(),
      'name': event.name,
    });

    print("addEvent in events provider:");
    print("adminId: " + event.adminId.toString());
    print("avgDuration: " + event.averageDuration.toString());
    print("avgLength: " + event.averageLength.toString());
    print("avgPace: " + event.averagePace.toString());
    print("createdAt: " + event.createdAt.toString());
    print("currentParticipants: " + event.currentParticipants.toString());
    print("date: " + event.date.toString());
    print("difficultyLevel: " + event.difficultyLevel.toString());
    print("maxParticipants: " + event.maxParticipants.toString());
    print("name: " + event.name.toString());
    print("startingPintLat: " + event.startingPintLat.toString());
    print("startingPintLong: " + event.startingPintLong.toString());
    print("id: " + event.id.toString());

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
    // final url = Uri.https(Config.baseUrl, '/event/add');

    final newEvent = Event(
      adminId: -1, //json.decode(response.stream.bytesToString())['admin_id'],
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
      id: -1, //json.decode(response.body)['id'],
    );
    _items.add(newEvent);

    // _items.insert(0, newEvent); // at the start of the list
    notifyListeners();
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
