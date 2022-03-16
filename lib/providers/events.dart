import 'dart:convert';

import 'package:flutter/material.dart';

import './event.dart';
import '../classes/config.dart';
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
    //TODO
    try {
      //_items = loadedEvents;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<Event> fetchEventById(int eventId) async {
    final Event event = new Event(
        id: -1,
        createdAt: DateTime.now(),
        name: "",
        date: DateTime.now(),
        startingPintLat: 0.0,
        startingPintLong: 0.0,
        difficultyLevel: 0.0,
        averagePaceMin: 0,
        averagePaceSec: 0,
        averageDuration: 0,
        averageLength: 0,
        adminId: 0,
        currentParticipants: 0,
        maxParticipants: 0);

    var request = http.MultipartRequest(
        'GET', Uri.parse(Config.baseUrl + '/event/' + eventId.toString()));

    String? jwt = await secureStorage.read(key: 'jwt');
    if (jwt != null) {
      var headers = {'Authorization': 'Bearer ' + jwt};
      request.headers.addAll(headers);
    }

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      //print(await response.stream.bytesToString());

      // generate an Event from the reply
      final stream = await response.stream.bytesToString().then((value) {
        final event = new Event(
          //id: int.parse(json.decode(value)["id"]),
          id: json.decode(value)["id"],
          name: json.decode(value)["name"],
          adminId: int.parse(json.decode(value)["admin_id"]),
          averageDuration: int.parse(json.decode(value)["avg_duration"]),
          averageLength: int.parse(json.decode(value)["avg_length"]),
          averagePaceMin: int.parse(json.decode(value)["avg_pace_min"]),
          averagePaceSec: int.parse(json.decode(value)["avg_pace_sec"]),
          createdAt: json.decode(value)["created_at"],
          currentParticipants:
              int.parse(json.decode(value)["current_participants"]),
          date: DateTime.parse(json.decode(value)["date"]),
          difficultyLevel: double.parse(json.decode(value)["difficulty_level"]),
          maxParticipants: int.parse(json.decode(value)["max_participants"]),
          startingPintLat:
              double.parse(json.decode(value)["starting_point_lat"]),
          startingPintLong:
              double.parse(json.decode(value)["starting_point_long"]),
        );
      });
      print("event: " + event.toString());
    } else {
      print(response.reasonPhrase);
    }

    return event;
  }

  Future<int> addEvent(Event event) async {
    var request =
        http.MultipartRequest('POST', Uri.parse(Config.baseUrl + '/event/add'));

    String? jwt = await secureStorage.read(key: 'jwt');
    if (jwt != null) {
      var headers = {'Authorization': 'Bearer ' + jwt};
      request.headers.addAll(headers);
    }

    // print("date (timestamp secondi):" +
    //     (DateTime.parse(event.date).millisecondsSinceEpoch / 1000)
    //         .round()
    //         .toString());

    // print('starting_point_long' + event.startingPintLong.toString());
    // print('starting_point_lat' + event.startingPintLat.toString());

    request.fields.addAll({
      'date': (event.date.millisecondsSinceEpoch / 1000).round().toString(),
      'starting_point_long': event.startingPintLong.toStringAsFixed(14),
      'starting_point_lat': event.startingPintLat.toStringAsFixed(14),
      'avg_duration': event.averageDuration.toString(),
      'avg_length': event.averageLength.toString(),
      'max_participants': event.maxParticipants.toString(),
      'name': event.name,
    });

    // print("addEvent in events provider:");
    // print("adminId: " + event.adminId.toString());
    // print("avgDuration: " + event.averageDuration.toString());
    // print("avgLength: " + event.averageLength.toString());
    // print("avgPace: " + event.averagePaceMin.toString());
    // print("createdAt: " + event.createdAt.toString());
    // print("currentParticipants: " + event.currentParticipants.toString());
    // print("date: " + event.date.toString());
    // print("difficultyLevel: " + event.difficultyLevel.toString());
    // print("maxParticipants: " + event.maxParticipants.toString());
    // print("name: " + event.name.toString());
    // print("startingPintLat: " + event.startingPintLat.toString());
    // print("startingPintLong: " + event.startingPintLong.toString());
    // print("id: " + event.id.toString());

    http.StreamedResponse response = await request.send();
    int newEventId = -1;

    if (response.statusCode == 200) {
      newEventId = json.decode(await response.stream.bytesToString())["id"];
    } else {
      print(response.reasonPhrase);
    }

    notifyListeners();

    print("newEventId: " + newEventId.toString());
    return newEventId;

    // final newEvent = Event(
    //   adminId: -1, //json.decode(response.stream.bytesToString())['admin_id'],
    //   averageDuration: event.averageDuration,
    //   averageLength: event.averageLength,
    //   averagePace: event.averagePace,
    //   createdAt: event.createdAt,
    //   currentParticipants: event.currentParticipants,
    //   date: event.date,
    //   difficultyLevel: event.difficultyLevel,
    //   maxParticipants: event.maxParticipants,
    //   name: event.name,
    //   startingPintLat: event.startingPintLat,
    //   startingPintLong: event.startingPintLong,
    //   id: -1, //json.decode(response.body)['id'],
    // );
    // _items.add(newEvent);

    // _items.insert(0, newEvent); // at the start of the list
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
