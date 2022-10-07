// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_db.dart';

// **************************************************************************
// DriftDatabaseGenerator
// **************************************************************************

// ignore_for_file: type=lint
class Event extends DataClass implements Insertable<Event> {
  final DateTime selectedDate;
  final String title;
  final bool isAllDay;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final String comment;
  const Event(
      {required this.selectedDate,
      required this.title,
      required this.isAllDay,
      required this.startDateTime,
      required this.endDateTime,
      required this.comment});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['selected_date'] = Variable<DateTime>(selectedDate);
    map['title'] = Variable<String>(title);
    map['is_all_day'] = Variable<bool>(isAllDay);
    map['start_date_time'] = Variable<DateTime>(startDateTime);
    map['end_date_time'] = Variable<DateTime>(endDateTime);
    map['comment'] = Variable<String>(comment);
    return map;
  }

  EventsCompanion toCompanion(bool nullToAbsent) {
    return EventsCompanion(
      selectedDate: Value(selectedDate),
      title: Value(title),
      isAllDay: Value(isAllDay),
      startDateTime: Value(startDateTime),
      endDateTime: Value(endDateTime),
      comment: Value(comment),
    );
  }

  factory Event.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Event(
      selectedDate: serializer.fromJson<DateTime>(json['selectedDate']),
      title: serializer.fromJson<String>(json['title']),
      isAllDay: serializer.fromJson<bool>(json['isAllDay']),
      startDateTime: serializer.fromJson<DateTime>(json['startDateTime']),
      endDateTime: serializer.fromJson<DateTime>(json['endDateTime']),
      comment: serializer.fromJson<String>(json['comment']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'selectedDate': serializer.toJson<DateTime>(selectedDate),
      'title': serializer.toJson<String>(title),
      'isAllDay': serializer.toJson<bool>(isAllDay),
      'startDateTime': serializer.toJson<DateTime>(startDateTime),
      'endDateTime': serializer.toJson<DateTime>(endDateTime),
      'comment': serializer.toJson<String>(comment),
    };
  }

  Event copyWith(
          {DateTime? selectedDate,
          String? title,
          bool? isAllDay,
          DateTime? startDateTime,
          DateTime? endDateTime,
          String? comment}) =>
      Event(
        selectedDate: selectedDate ?? this.selectedDate,
        title: title ?? this.title,
        isAllDay: isAllDay ?? this.isAllDay,
        startDateTime: startDateTime ?? this.startDateTime,
        endDateTime: endDateTime ?? this.endDateTime,
        comment: comment ?? this.comment,
      );
  @override
  String toString() {
    return (StringBuffer('Event(')
          ..write('selectedDate: $selectedDate, ')
          ..write('title: $title, ')
          ..write('isAllDay: $isAllDay, ')
          ..write('startDateTime: $startDateTime, ')
          ..write('endDateTime: $endDateTime, ')
          ..write('comment: $comment')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      selectedDate, title, isAllDay, startDateTime, endDateTime, comment);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Event &&
          other.selectedDate == this.selectedDate &&
          other.title == this.title &&
          other.isAllDay == this.isAllDay &&
          other.startDateTime == this.startDateTime &&
          other.endDateTime == this.endDateTime &&
          other.comment == this.comment);
}

class EventsCompanion extends UpdateCompanion<Event> {
  final Value<DateTime> selectedDate;
  final Value<String> title;
  final Value<bool> isAllDay;
  final Value<DateTime> startDateTime;
  final Value<DateTime> endDateTime;
  final Value<String> comment;
  const EventsCompanion({
    this.selectedDate = const Value.absent(),
    this.title = const Value.absent(),
    this.isAllDay = const Value.absent(),
    this.startDateTime = const Value.absent(),
    this.endDateTime = const Value.absent(),
    this.comment = const Value.absent(),
  });
  EventsCompanion.insert({
    required DateTime selectedDate,
    required String title,
    required bool isAllDay,
    required DateTime startDateTime,
    required DateTime endDateTime,
    required String comment,
  })  : selectedDate = Value(selectedDate),
        title = Value(title),
        isAllDay = Value(isAllDay),
        startDateTime = Value(startDateTime),
        endDateTime = Value(endDateTime),
        comment = Value(comment);
  static Insertable<Event> custom({
    Expression<DateTime>? selectedDate,
    Expression<String>? title,
    Expression<bool>? isAllDay,
    Expression<DateTime>? startDateTime,
    Expression<DateTime>? endDateTime,
    Expression<String>? comment,
  }) {
    return RawValuesInsertable({
      if (selectedDate != null) 'selected_date': selectedDate,
      if (title != null) 'title': title,
      if (isAllDay != null) 'is_all_day': isAllDay,
      if (startDateTime != null) 'start_date_time': startDateTime,
      if (endDateTime != null) 'end_date_time': endDateTime,
      if (comment != null) 'comment': comment,
    });
  }

  EventsCompanion copyWith(
      {Value<DateTime>? selectedDate,
      Value<String>? title,
      Value<bool>? isAllDay,
      Value<DateTime>? startDateTime,
      Value<DateTime>? endDateTime,
      Value<String>? comment}) {
    return EventsCompanion(
      selectedDate: selectedDate ?? this.selectedDate,
      title: title ?? this.title,
      isAllDay: isAllDay ?? this.isAllDay,
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      comment: comment ?? this.comment,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (selectedDate.present) {
      map['selected_date'] = Variable<DateTime>(selectedDate.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (isAllDay.present) {
      map['is_all_day'] = Variable<bool>(isAllDay.value);
    }
    if (startDateTime.present) {
      map['start_date_time'] = Variable<DateTime>(startDateTime.value);
    }
    if (endDateTime.present) {
      map['end_date_time'] = Variable<DateTime>(endDateTime.value);
    }
    if (comment.present) {
      map['comment'] = Variable<String>(comment.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventsCompanion(')
          ..write('selectedDate: $selectedDate, ')
          ..write('title: $title, ')
          ..write('isAllDay: $isAllDay, ')
          ..write('startDateTime: $startDateTime, ')
          ..write('endDateTime: $endDateTime, ')
          ..write('comment: $comment')
          ..write(')'))
        .toString();
  }
}

class $EventsTable extends Events with TableInfo<$EventsTable, Event> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EventsTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _selectedDateMeta =
      const VerificationMeta('selectedDate');
  @override
  late final GeneratedColumn<DateTime> selectedDate = GeneratedColumn<DateTime>(
      'selected_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  final VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  final VerificationMeta _isAllDayMeta = const VerificationMeta('isAllDay');
  @override
  late final GeneratedColumn<bool> isAllDay = GeneratedColumn<bool>(
      'is_all_day', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: 'CHECK (is_all_day IN (0, 1))');
  final VerificationMeta _startDateTimeMeta =
      const VerificationMeta('startDateTime');
  @override
  late final GeneratedColumn<DateTime> startDateTime =
      GeneratedColumn<DateTime>('start_date_time', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  final VerificationMeta _endDateTimeMeta =
      const VerificationMeta('endDateTime');
  @override
  late final GeneratedColumn<DateTime> endDateTime = GeneratedColumn<DateTime>(
      'end_date_time', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  final VerificationMeta _commentMeta = const VerificationMeta('comment');
  @override
  late final GeneratedColumn<String> comment = GeneratedColumn<String>(
      'comment', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [selectedDate, title, isAllDay, startDateTime, endDateTime, comment];
  @override
  String get aliasedName => _alias ?? 'events';
  @override
  String get actualTableName => 'events';
  @override
  VerificationContext validateIntegrity(Insertable<Event> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('selected_date')) {
      context.handle(
          _selectedDateMeta,
          selectedDate.isAcceptableOrUnknown(
              data['selected_date']!, _selectedDateMeta));
    } else if (isInserting) {
      context.missing(_selectedDateMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('is_all_day')) {
      context.handle(_isAllDayMeta,
          isAllDay.isAcceptableOrUnknown(data['is_all_day']!, _isAllDayMeta));
    } else if (isInserting) {
      context.missing(_isAllDayMeta);
    }
    if (data.containsKey('start_date_time')) {
      context.handle(
          _startDateTimeMeta,
          startDateTime.isAcceptableOrUnknown(
              data['start_date_time']!, _startDateTimeMeta));
    } else if (isInserting) {
      context.missing(_startDateTimeMeta);
    }
    if (data.containsKey('end_date_time')) {
      context.handle(
          _endDateTimeMeta,
          endDateTime.isAcceptableOrUnknown(
              data['end_date_time']!, _endDateTimeMeta));
    } else if (isInserting) {
      context.missing(_endDateTimeMeta);
    }
    if (data.containsKey('comment')) {
      context.handle(_commentMeta,
          comment.isAcceptableOrUnknown(data['comment']!, _commentMeta));
    } else if (isInserting) {
      context.missing(_commentMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
  @override
  Event map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Event(
      selectedDate: attachedDatabase.options.types.read(
          DriftSqlType.dateTime, data['${effectivePrefix}selected_date'])!,
      title: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      isAllDay: attachedDatabase.options.types
          .read(DriftSqlType.bool, data['${effectivePrefix}is_all_day'])!,
      startDateTime: attachedDatabase.options.types.read(
          DriftSqlType.dateTime, data['${effectivePrefix}start_date_time'])!,
      endDateTime: attachedDatabase.options.types.read(
          DriftSqlType.dateTime, data['${effectivePrefix}end_date_time'])!,
      comment: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}comment'])!,
    );
  }

  @override
  $EventsTable createAlias(String alias) {
    return $EventsTable(attachedDatabase, alias);
  }
}

abstract class _$MyDatabase extends GeneratedDatabase {
  _$MyDatabase(QueryExecutor e) : super(e);
  late final $EventsTable events = $EventsTable(this);
  @override
  Iterable<TableInfo<Table, dynamic>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [events];
}
