import 'package:drift/drift.dart';

class Events extends Table {
  TextColumn get id => text()();

  DateTimeColumn get selectedDate => dateTime()();

  TextColumn get title => text()();

  BoolColumn get isAllDay => boolean()();

  DateTimeColumn get startDateTime => dateTime()();

  DateTimeColumn get endDateTime => dateTime()();

  TextColumn get comment => text()();
}