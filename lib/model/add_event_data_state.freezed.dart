// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'add_event_data_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$AddEventDataState {
  EventData? get addEventData => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AddEventDataStateCopyWith<AddEventDataState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddEventDataStateCopyWith<$Res> {
  factory $AddEventDataStateCopyWith(
          AddEventDataState value, $Res Function(AddEventDataState) then) =
      _$AddEventDataStateCopyWithImpl<$Res>;
  $Res call({EventData? addEventData});

  $EventDataCopyWith<$Res>? get addEventData;
}

/// @nodoc
class _$AddEventDataStateCopyWithImpl<$Res>
    implements $AddEventDataStateCopyWith<$Res> {
  _$AddEventDataStateCopyWithImpl(this._value, this._then);

  final AddEventDataState _value;
  // ignore: unused_field
  final $Res Function(AddEventDataState) _then;

  @override
  $Res call({
    Object? addEventData = freezed,
  }) {
    return _then(_value.copyWith(
      addEventData: addEventData == freezed
          ? _value.addEventData
          : addEventData // ignore: cast_nullable_to_non_nullable
              as EventData?,
    ));
  }

  @override
  $EventDataCopyWith<$Res>? get addEventData {
    if (_value.addEventData == null) {
      return null;
    }

    return $EventDataCopyWith<$Res>(_value.addEventData!, (value) {
      return _then(_value.copyWith(addEventData: value));
    });
  }
}

/// @nodoc
abstract class _$$_AddEventDataStateCopyWith<$Res>
    implements $AddEventDataStateCopyWith<$Res> {
  factory _$$_AddEventDataStateCopyWith(_$_AddEventDataState value,
          $Res Function(_$_AddEventDataState) then) =
      __$$_AddEventDataStateCopyWithImpl<$Res>;
  @override
  $Res call({EventData? addEventData});

  @override
  $EventDataCopyWith<$Res>? get addEventData;
}

/// @nodoc
class __$$_AddEventDataStateCopyWithImpl<$Res>
    extends _$AddEventDataStateCopyWithImpl<$Res>
    implements _$$_AddEventDataStateCopyWith<$Res> {
  __$$_AddEventDataStateCopyWithImpl(
      _$_AddEventDataState _value, $Res Function(_$_AddEventDataState) _then)
      : super(_value, (v) => _then(v as _$_AddEventDataState));

  @override
  _$_AddEventDataState get _value => super._value as _$_AddEventDataState;

  @override
  $Res call({
    Object? addEventData = freezed,
  }) {
    return _then(_$_AddEventDataState(
      addEventData: addEventData == freezed
          ? _value.addEventData
          : addEventData // ignore: cast_nullable_to_non_nullable
              as EventData?,
    ));
  }
}

/// @nodoc

class _$_AddEventDataState implements _AddEventDataState {
  const _$_AddEventDataState({this.addEventData});

  @override
  final EventData? addEventData;

  @override
  String toString() {
    return 'AddEventDataState(addEventData: $addEventData)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AddEventDataState &&
            const DeepCollectionEquality()
                .equals(other.addEventData, addEventData));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(addEventData));

  @JsonKey(ignore: true)
  @override
  _$$_AddEventDataStateCopyWith<_$_AddEventDataState> get copyWith =>
      __$$_AddEventDataStateCopyWithImpl<_$_AddEventDataState>(
          this, _$identity);
}

abstract class _AddEventDataState implements AddEventDataState {
  const factory _AddEventDataState({final EventData? addEventData}) =
      _$_AddEventDataState;

  @override
  EventData? get addEventData;
  @override
  @JsonKey(ignore: true)
  _$$_AddEventDataStateCopyWith<_$_AddEventDataState> get copyWith =>
      throw _privateConstructorUsedError;
}
