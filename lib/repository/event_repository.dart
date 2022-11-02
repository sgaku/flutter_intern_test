import 'package:calendar_sample/service/my_database.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/event_data.dart';


class EventRepository {
  EventRepository(Ref ref) {
    dataBase = ref.read(myDataBaseProvider);
  }

  late final MyDatabase dataBase;

  Future<List<Event>> get allEventsData =>
      dataBase.select(dataBase.events).get();

  Future<int> addEvent(EventData e) {
    return dataBase.into(dataBase.events).insert(EventsCompanion(
          id: Value(e.id),
          selectedDate: Value(e.selectedDate),
          title: Value(e.title),
          isAllDay: Value(e.isAllDay),
          startDateTime: Value(e.startTime),
          endDateTime: Value(e.endTime),
          comment: Value(e.comment),
        ));
  }

  Future<int> updateEvent(EventData event) {
    return (dataBase.update(dataBase.events)
          ..where((tbl) => tbl.id.equals(event.id)))
        .write(EventsCompanion(
      id: Value(event.id),
      selectedDate: Value(event.selectedDate),
      title: Value(event.title),
      isAllDay: Value(event.isAllDay),
      startDateTime: Value(event.startTime),
      endDateTime: Value(event.endTime),
      comment: Value(event.comment),
    ));
  }

  Future<void> deleteAllEvent(List<EventData> e) {
    return (dataBase.delete(dataBase.events).go());
  }

  Future<void> deleteEvent(EventData e) {
    return (dataBase.delete(dataBase.events)
          ..where((tbl) => tbl.id.equals(e.id)))
        .go();
  }
}
