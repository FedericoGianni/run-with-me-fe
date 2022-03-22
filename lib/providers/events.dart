import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';

import './event.dart';
import '../classes/config.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Events with ChangeNotifier {
  List<Event> _suggestedEvents = [];
  List<Event> _recentEvents = [];
  List<Event> _bookedEvents = [];
  List<Event> _resultEvents = [];

  // save the last used parameters for fetchAndSetSuggestedEvents in case of refresh
  double _lastSuggestedLat = 0.0;
  double _lastSuggestedLong = 0.0;
  int _lastSuggestedMaxDistKm = 0;

  // save the last used parameters for fetchAndSetSuggestedEvents in case of refresh
  double _lastResultLat = 0.0;
  double _lastResultLong = 0.0;
  int _lastResultMaxDistKm = 0;

  final secureStorage = const FlutterSecureStorage();

  double get lastSuggestedLat {
    return _lastSuggestedLat;
  }

  double get lastSuggestedLong {
    return _lastSuggestedLong;
  }

  int get lastSuggestedMaxDistKm {
    return _lastSuggestedMaxDistKm;
  }

  double get lastResultLat {
    return _lastResultLat;
  }

  double get lastResultLong {
    return _lastResultLong;
  }

  int get lastResultMaxDistKm {
    return _lastResultMaxDistKm;
  }

  List<Event> get suggestedEvents {
    return [..._suggestedEvents];
  }

  List<Event> get recentEvents {
    return [..._recentEvents];
  }

  List<Event> get bookedEvents {
    return [..._bookedEvents];
  }

  List<Event> get resultEvents {
    return [..._resultEvents];
  }

  Event findById(int id) {
    return _suggestedEvents.firstWhere((event) => event.id == id);
  }

  // add an event to the recently viewed event list
  // only keep 10 events, if limit is exceeded replace the oldest
  void addRecentEvent(Event event) {
    //only add event if not already present in recently viewed list
    if (!_recentEvents.contains(event)) {
      if (_recentEvents.length < 10) {
        _recentEvents.add(event);
      } else {
        //TODO not sure about this logic
        _recentEvents.removeAt(0);
        // shift all remaining events to the left of 1
        _recentEvents = _recentEvents.sublist(1, 9);
        // add new event
        _recentEvents.add(event);
      }
      notifyListeners();
    }
  }

  Future<void> fetchAndSetSuggestedEvents(
      double lat, double long, int max_dist_km) async {
    // 1. save parameters used in case of refresh
    _lastSuggestedLat = lat;
    _lastSuggestedLong = long;
    _lastSuggestedMaxDistKm = max_dist_km;

    // 2. actual call
    fetchAndSetEvents(lat, long, max_dist_km, _suggestedEvents, true);
  }

  Future<void> fetchAndSetResultEvents(
      double lat, double long, int max_dist_km) async {
    // 1. save parameters used in case of refresh
    _lastResultLat = lat;
    _lastResultLong = long;
    _lastResultMaxDistKm = max_dist_km;

    // 2. actual call
    await fetchAndSetEvents(lat, long, max_dist_km, _resultEvents, true);
  }

  Future<void> fetchAndSetEvents(double lat, double long, int max_dist_km,
      List<Event> events, bool auth) async {
    try {
      var request = http.MultipartRequest(
          'GET',
          Uri.parse(Config.baseUrl +
              '/events/auth' +
              '?lat=' +
              lat.toString() +
              '&long=' +
              long.toString() +
              '&max_dist_km=' +
              max_dist_km.toString()));

      String? jwt = await secureStorage.read(key: 'jwt');
      if (jwt != null) {
        var headers = {'Authorization': 'Bearer ' + jwt};
        request.headers.addAll(headers);
      }

      print("fetchAndSetEvents calling API...");
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        // generate an Event from the reply

        final stream = await response.stream.bytesToString();
        // empty old list
        events.clear();

        // receive a json-array
        List<dynamic> list = json.decode(stream);
        // for each element of the json array, re-encode as single json object and use eventFromJson function to generate single event to be added to the suggestedEvents list
        for (int i = 0; i < list.length; i++) {
          //print("received json [{$i}]: " + list[i].toString());
          //print("re-encoding single json: " + json.encode(list[i]));

          events.add(eventFromJson(json.encode(list[i]), true));
          //print("suggestedEvents.length: " +  _suggestedEvents.length.toString());
        }
      } else {
        print(response.reasonPhrase);
      }

      //_items = loadedEvents;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> addBookingToEvent(int eventId, int userId) async {
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(Config.baseUrl +
            '/booking/add' +
            '?event_id=' +
            eventId.toString() +
            '&user_id=' +
            userId.toString()));

    String? jwt = await secureStorage.read(key: 'jwt');
    if (jwt != null) {
      var headers = {'Authorization': 'Bearer ' + jwt};
      request.headers.addAll(headers);
    }

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      return true;
    } else {
      print(response.reasonPhrase);
      return false;
    }
  }

  Future<bool> delBookingFromEvent(int eventId, int userId) async {
    var request =
        http.MultipartRequest('DELETE', Uri.parse(Config.baseUrl + '/booking'));

    String? jwt = await secureStorage.read(key: 'jwt');
    if (jwt != null) {
      var headers = {'Authorization': 'Bearer ' + jwt};
      request.headers.addAll(headers);
    }

    request.fields
        .addAll({'user_id': userId.toString(), 'event_id': eventId.toString()});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      return true;
    } else {
      print(response.reasonPhrase);
      return false;
    }
  }

  Future<List<Event>> fetchAndSetBookedEvents(int userId) async {
    List<Event> _events = [];

    try {
      var request = http.MultipartRequest('GET',
          Uri.parse(Config.baseUrl + '/events/user/' + userId.toString()));
      String? jwt = await secureStorage.read(key: 'jwt');
      if (jwt != null) {
        var headers = {'Authorization': 'Bearer ' + jwt};
        request.headers.addAll(headers);
      }

      print("fetchAndSetBookedEvents calling API...");
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        // generate an Event from the reply

        final stream = await response.stream.bytesToString().then((value) {
          // empty old list
          _bookedEvents.clear();

          // receive a json-array
          List<dynamic> list = json.decode(value);

          // for each element of the json array, re-encode as single json object and use eventFromJson function to generate single event to be added to the suggestedEvents list
          for (int i = 0; i < list.length; i++) {
            //auth == false because don't need user_booked parameter since it is true because we are fetching events to which the user subscribed
            _bookedEvents.add(eventFromJson(json.encode(list[i]), false));
          }
        });
      } else {
        print(response.reasonPhrase);
      }

      //_items = loadedEvents;
      notifyListeners();
    } catch (error) {
      rethrow;
    }

    return _events;
  }

  Event eventFromJson(String value, bool auth) {
    if (auth) {
      return new Event(
          id: json.decode(value)["id"],
          name: json.decode(value)["name"],
          adminId: json.decode(value)["admin_id"],
          averageDuration: json.decode(value)["avg_duration"],
          averageLength: json.decode(value)["avg_length"],
          averagePaceMin: json.decode(value)["avg_pace_min"],
          averagePaceSec: json.decode(value)["avg_pace_sec"],
          createdAt: DateTime.fromMillisecondsSinceEpoch(
              json.decode(value)["created_at"].toInt() * 1000),
          currentParticipants: json.decode(value)["current_participants"],
          date: DateTime.fromMillisecondsSinceEpoch(
              json.decode(value)["date"].toInt() * 1000),
          difficultyLevel: json.decode(value)["difficulty_level"],
          maxParticipants: json.decode(value)["max_participants"],
          startingPintLat:
              double.parse(json.decode(value)["starting_point_lat"]),
          startingPintLong:
              double.parse(json.decode(value)["starting_point_long"]),
          userBooked: json.decode(value)["user_booked"]);
    } else {
      return new Event(
        id: json.decode(value)["id"],
        name: json.decode(value)["name"],
        adminId: json.decode(value)["admin_id"],
        averageDuration: json.decode(value)["avg_duration"],
        averageLength: json.decode(value)["avg_length"],
        averagePaceMin: json.decode(value)["avg_pace_min"],
        averagePaceSec: json.decode(value)["avg_pace_sec"],
        createdAt: DateTime.fromMillisecondsSinceEpoch(
            json.decode(value)["created_at"].toInt() * 1000),
        currentParticipants: json.decode(value)["current_participants"],
        date: DateTime.fromMillisecondsSinceEpoch(
            json.decode(value)["date"].toInt() * 1000),
        difficultyLevel: json.decode(value)["difficulty_level"],
        maxParticipants: json.decode(value)["max_participants"],
        startingPintLat: double.parse(json.decode(value)["starting_point_lat"]),
        startingPintLong:
            double.parse(json.decode(value)["starting_point_long"]),
        // always true beacause it is used by get events by user_id so it has made booking for it
        userBooked: true,
      );
    }
  }

  Future<Event> fetchEventById(int eventId) async {
    Event event = new Event(
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
        'GET', Uri.parse(Config.baseUrl + '/event/auth/' + eventId.toString()));

    String? jwt = await secureStorage.read(key: 'jwt');
    if (jwt != null) {
      var headers = {'Authorization': 'Bearer ' + jwt};
      request.headers.addAll(headers);
    }

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // generate an Event from the reply
      final stream = await response.stream.bytesToString().then((value) {
        print("200 OK, populating event with the receivded json");
        print("received json: " + value);
        event = eventFromJson(value, true);
      });
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
