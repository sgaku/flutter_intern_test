import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'event_db.g.dart';

class Events extends Table {
  DateTimeColumn get selectedDate => dateTime()();

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
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          // we added the dueDate property in the change from version 1 to
          // version 2
          await m.addColumn(events, events.selectedDate);
        }
      },
    );
  }
  //データの読み込み
  Stream<List<Event>> watchEntries() {
    return (select(events)).watch();
  }

//データの読み込み
  Future<List<Event>> get allEventsData => select(events).get();

  //データの追加
  Future<int> addEvent(Event e) {
    return into(events).insert(EventsCompanion(
      selectedDate: Value(e.selectedDate),
      title: Value(e.title),
      isAllDay: Value(e.isAllDay),
      startDateTime: Value(e.startDateTime),
      endDateTime: Value(e.endDateTime),
      comment: Value(e.comment),
    ));
  }

  //データの全削除
  Future<void> deleteEvent(List<Event> e) {
    return (delete(events).go());
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
