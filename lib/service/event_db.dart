import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'event_db.g.dart';

class Events extends Table {
  TextColumn get title => text()();

  BoolColumn get isAllDay => boolean()();

  DateTimeColumn get startDateTime => dateTime()();

  DateTimeColumn get endDateTime => dateTime()();

  TextColumn get comment => text()();
}

@DriftDatabase(tables: [Events])
class MyDatabase extends _$MyDatabase {
  MyDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Stream<List<Event>> watchEntries() {
    return (select(events)).watch();
  }

  Future<List<Event>> get allTodoEntries => select(events).get();

  Future<int> addEvent(Event e) {
    return into(events).insert(EventsCompanion(
      title: Value(e.title),
      isAllDay: Value(e.isAllDay),
      startDateTime: Value(e.startDateTime),
      endDateTime: Value(e.endDateTime),
      comment: Value(e.comment),
    ));
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
