// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'event_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$EventData {
  String get id => throw _privateConstructorUsedError;
  DateTime get selectedDate => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  bool get isAllDay => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  DateTime get endTime => throw _privateConstructorUsedError;
  String get comment => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $EventDataCopyWith<EventData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventDataCopyWith<$Res> {
  factory $EventDataCopyWith(EventData value, $Res Function(EventData) then) =
      _$EventDataCopyWithImpl<$Res>;
  $Res call(
      {String id,
      DateTime selectedDate,
      String title,
      bool isAllDay,
      DateTime startTime,
      DateTime endTime,
      String comment});
}

/// @nodoc
class _$EventDataCopyWithImpl<$Res> implements $EventDataCopyWith<$Res> {
  _$EventDataCopyWithImpl(this._value, this._then);

  final EventData _value;
  // ignore: unused_field
  final $Res Function(EventData) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? selectedDate = freezed,
    Object? title = freezed,
    Object? isAllDay = freezed,
    Object? startTime = freezed,
    Object? endTime = freezed,
    Object? comment = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      selectedDate: selectedDate == freezed
          ? _value.selectedDate
          : selectedDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      isAllDay: isAllDay == freezed
          ? _value.isAllDay
          : isAllDay // ignore: cast_nullable_to_non_nullable
              as bool,
      startTime: startTime == freezed
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: endTime == freezed
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      comment: comment == freezed
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$$_EventDataCopyWith<$Res> implements $EventDataCopyWith<$Res> {
  factory _$$_EventDataCopyWith(
          _$_EventData value, $Res Function(_$_EventData) then) =
      __$$_EventDataCopyWithImpl<$Res>;
  @override
  $Res call(
      {String id,
      DateTime selectedDate,
      String title,
      bool isAllDay,
      DateTime startTime,
      DateTime endTime,
      String comment});
}

/// @nodoc
class __$$_EventDataCopyWithImpl<$Res> extends _$EventDataCopyWithImpl<$Res>
    implements _$$_EventDataCopyWith<$Res> {
  __$$_EventDataCopyWithImpl(
      _$_EventData _value, $Res Function(_$_EventData) _then)
      : super(_value, (v) => _then(v as _$_EventData));

  @override
  _$_EventData get _value => super._value as _$_EventData;

  @override
  $Res call({
    Object? id = freezed,
    Object? selectedDate = freezed,
    Object? title = freezed,
    Object? isAllDay = freezed,
    Object? startTime = freezed,
    Object? endTime = freezed,
    Object? comment = freezed,
  }) {
    return _then(_$_EventData(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      selectedDate: selectedDate == freezed
          ? _value.selectedDate
          : selectedDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      isAllDay: isAllDay == freezed
          ? _value.isAllDay
          : isAllDay // ignore: cast_nullable_to_non_nullable
              as bool,
      startTime: startTime == freezed
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: endTime == freezed
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      comment: comment == freezed
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_EventData implements _EventData {
  const _$_EventData(
      {required this.id,
      required this.selectedDate,
      required this.title,
      required this.isAllDay,
      required this.startTime,
      required this.endTime,
      required this.comment});

  @override
  final String id;
  @override
  final DateTime selectedDate;
  @override
  final String title;
  @override
  final bool isAllDay;
  @override
  final DateTime startTime;
  @override
  final DateTime endTime;
  @override
  final String comment;

  @override
  String toString() {
    return 'EventData(id: $id, selectedDate: $selectedDate, title: $title, isAllDay: $isAllDay, startTime: $startTime, endTime: $endTime, comment: $comment)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_EventData &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality()
                .equals(other.selectedDate, selectedDate) &&
            const DeepCollectionEquality().equals(other.title, title) &&
            const DeepCollectionEquality().equals(other.isAllDay, isAllDay) &&
            const DeepCollectionEquality().equals(other.startTime, startTime) &&
            const DeepCollectionEquality().equals(other.endTime, endTime) &&
            const DeepCollectionEquality().equals(other.comment, comment));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(selectedDate),
      const DeepCollectionEquality().hash(title),
      const DeepCollectionEquality().hash(isAllDay),
      const DeepCollectionEquality().hash(startTime),
      const DeepCollectionEquality().hash(endTime),
      const DeepCollectionEquality().hash(comment));

  @JsonKey(ignore: true)
  @override
  _$$_EventDataCopyWith<_$_EventData> get copyWith =>
      __$$_EventDataCopyWithImpl<_$_EventData>(this, _$identity);
}

abstract class _EventData implements EventData {
  const factory _EventData(
      {required final String id,
      required final DateTime selectedDate,
      required final String title,
      required final bool isAllDay,
      required final DateTime startTime,
      required final DateTime endTime,
      required final String comment}) = _$_EventData;

  @override
  String get id;
  @override
  DateTime get selectedDate;
  @override
  String get title;
  @override
  bool get isAllDay;
  @override
  DateTime get startTime;
  @override
  DateTime get endTime;
  @override
  String get comment;
  @override
  @JsonKey(ignore: true)
  _$$_EventDataCopyWith<_$_EventData> get copyWith =>
      throw _privateConstructorUsedError;
}
