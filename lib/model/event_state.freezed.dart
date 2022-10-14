// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'event_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$EventState {
  Map<DateTime, List<EventData>> get eventDataMap =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $EventStateCopyWith<EventState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventStateCopyWith<$Res> {
  factory $EventStateCopyWith(
          EventState value, $Res Function(EventState) then) =
      _$EventStateCopyWithImpl<$Res>;
  $Res call({Map<DateTime, List<EventData>> eventDataMap});
}

/// @nodoc
class _$EventStateCopyWithImpl<$Res> implements $EventStateCopyWith<$Res> {
  _$EventStateCopyWithImpl(this._value, this._then);

  final EventState _value;
  // ignore: unused_field
  final $Res Function(EventState) _then;

  @override
  $Res call({
    Object? eventDataMap = freezed,
  }) {
    return _then(_value.copyWith(
      eventDataMap: eventDataMap == freezed
          ? _value.eventDataMap
          : eventDataMap // ignore: cast_nullable_to_non_nullable
              as Map<DateTime, List<EventData>>,
    ));
  }
}

/// @nodoc
abstract class _$$_EventStateCopyWith<$Res>
    implements $EventStateCopyWith<$Res> {
  factory _$$_EventStateCopyWith(
          _$_EventState value, $Res Function(_$_EventState) then) =
      __$$_EventStateCopyWithImpl<$Res>;
  @override
  $Res call({Map<DateTime, List<EventData>> eventDataMap});
}

/// @nodoc
class __$$_EventStateCopyWithImpl<$Res> extends _$EventStateCopyWithImpl<$Res>
    implements _$$_EventStateCopyWith<$Res> {
  __$$_EventStateCopyWithImpl(
      _$_EventState _value, $Res Function(_$_EventState) _then)
      : super(_value, (v) => _then(v as _$_EventState));

  @override
  _$_EventState get _value => super._value as _$_EventState;

  @override
  $Res call({
    Object? eventDataMap = freezed,
  }) {
    return _then(_$_EventState(
      eventDataMap: eventDataMap == freezed
          ? _value._eventDataMap
          : eventDataMap // ignore: cast_nullable_to_non_nullable
              as Map<DateTime, List<EventData>>,
    ));
  }
}

/// @nodoc

class _$_EventState implements _EventState {
  const _$_EventState(
      {final Map<DateTime, List<EventData>> eventDataMap = const {}})
      : _eventDataMap = eventDataMap;

  final Map<DateTime, List<EventData>> _eventDataMap;
  @override
  @JsonKey()
  Map<DateTime, List<EventData>> get eventDataMap {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_eventDataMap);
  }

  @override
  String toString() {
    return 'EventState(eventDataMap: $eventDataMap)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_EventState &&
            const DeepCollectionEquality()
                .equals(other._eventDataMap, _eventDataMap));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_eventDataMap));

  @JsonKey(ignore: true)
  @override
  _$$_EventStateCopyWith<_$_EventState> get copyWith =>
      __$$_EventStateCopyWithImpl<_$_EventState>(this, _$identity);
}

abstract class _EventState implements EventState {
  const factory _EventState(
      {final Map<DateTime, List<EventData>> eventDataMap}) = _$_EventState;

  @override
  Map<DateTime, List<EventData>> get eventDataMap;
  @override
  @JsonKey(ignore: true)
  _$$_EventStateCopyWith<_$_EventState> get copyWith =>
      throw _privateConstructorUsedError;
}
