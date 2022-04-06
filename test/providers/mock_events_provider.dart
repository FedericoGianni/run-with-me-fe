import 'package:mockito/mockito.dart';
import 'package:runwithme/providers/event.dart';
import 'package:runwithme/providers/events.dart';
import 'package:runwithme/models/dummy_events.dart';

class MockEventsProvider extends Mock implements Events {
  List<Event> dummyEvents = dummy;
  @override
  List<Event> bookedEvents = [];

  @override
  Future<void> fetchAndSetResultEvents(
      double lat, double long, int max_dist_km, bool isLoggedIn) async {
    bookedEvents.addAll(dummyEvents);
  }

  @override
  Future<void> fetchAndSetSuggestedEvents(
      double lat, double long, int max_dist_km, bool isLoggedIn) async {
    suggestedEvents.addAll(dummyEvents);
  }

  @override
  Future<List<Event>> fetchAndSetBookedEvents(int userId) async {
    bookedEvents.addAll(dummyEvents);
    return dummyEvents;
  }

  @override
  Future<void> fetchAndSetEvents(double lat, double long, int max_dist_km,
      List<Event> events, bool auth) async {
    events.addAll(dummyEvents);
  }

  @override
  Future<bool> addBookingToEvent(int eventId) async {
    return true;
  }

  @override
  Future<int> addEvent(Event event) async {
    dummyEvents.add(event);
    return dummyEvents.length;
  }

  @override
  Future<Event> fetchEventById(int eventId, bool auth) async {
    return dummyEvents.first;
  }
}
