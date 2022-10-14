// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'edit_event_data_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$EditEventDataState {
  bool get isUpdated => throw _privateConstructorUsedError;
  EventData get editEventData => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $EditEventDataStateCopyWith<EditEventDataState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EditEventDataStateCopyWith<$Res> {
  factory $EditEventDataStateCopyWith(
          EditEventDataState value, $Res Function(EditEventDataState) then) =
      _$EditEventDataStateCopyWithImpl<$Res>;
  $Res call({bool isUpdated, EventData editEventData});

  $EventDataCopyWith<$Res> get editEventData;
}

/// @nodoc
class _$EditEventDataStateCopyWithImpl<$Res>
    implements $EditEventDataStateCopyWith<$Res> {
  _$EditEventDataStateCopyWithImpl(this._value, this._then);

  final EditEventDataState _value;
  // ignore: unused_field
  final $Res Function(EditEventDataState) _then;

  @override
  $Res call({
    Object? isUpdated = freezed,
    Object? editEventData = freezed,
  }) {
    return _then(_value.copyWith(
      isUpdated: isUpdated == freezed
          ? _value.isUpdated
          : isUpdated // ignore: cast_nullable_to_non_nullable
              as bool,
      editEventData: editEventData == freezed
          ? _value.editEventData
          : editEventData // ignore: cast_nullable_to_non_nullable
              as EventData,
    ));
  }

  @override
  $EventDataCopyWith<$Res> get editEventData {
    return $EventDataCopyWith<$Res>(_value.editEventData, (value) {
      return _then(_value.copyWith(editEventData: value));
    });
  }
}

/// @nodoc
abstract class _$$_EditEventDataStateCopyWith<$Res>
    implements $EditEventDataStateCopyWith<$Res> {
  factory _$$_EditEventDataStateCopyWith(_$_EditEventDataState value,
          $Res Function(_$_EditEventDataState) then) =
      __$$_EditEventDataStateCopyWithImpl<$Res>;
  @override
  $Res call({bool isUpdated, EventData editEventData});

  @override
  $EventDataCopyWith<$Res> get editEventData;
}

/// @nodoc
class __$$_EditEventDataStateCopyWithImpl<$Res>
    extends _$EditEventDataStateCopyWithImpl<$Res>
    implements _$$_EditEventDataStateCopyWith<$Res> {
  __$$_EditEventDataStateCopyWithImpl(
      _$_EditEventDataState _value, $Res Function(_$_EditEventDataState) _then)
      : super(_value, (v) => _then(v as _$_EditEventDataState));

  @override
  _$_EditEventDataState get _value => super._value as _$_EditEventDataState;

  @override
  $Res call({
    Object? isUpdated = freezed,
    Object? editEventData = freezed,
  }) {
    return _then(_$_EditEventDataState(
      isUpdated: isUpdated == freezed
          ? _value.isUpdated
          : isUpdated // ignore: cast_nullable_to_non_nullable
              as bool,
      editEventData: editEventData == freezed
          ? _value.editEventData
          : editEventData // ignore: cast_nullable_to_non_nullable
              as EventData,
    ));
  }
}

/// @nodoc

class _$_EditEventDataState implements _EditEventDataState {
  const _$_EditEventDataState(
      {this.isUpdated = false, required this.editEventData});

  @override
  @JsonKey()
  final bool isUpdated;
  @override
  final EventData editEventData;

  @override
  String toString() {
    return 'EditEventDataState(isUpdated: $isUpdated, editEventData: $editEventData)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_EditEventDataState &&
            const DeepCollectionEquality().equals(other.isUpdated, isUpdated) &&
            const DeepCollectionEquality()
                .equals(other.editEventData, editEventData));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(isUpdated),
      const DeepCollectionEquality().hash(editEventData));

  @JsonKey(ignore: true)
  @override
  _$$_EditEventDataStateCopyWith<_$_EditEventDataState> get copyWith =>
      __$$_EditEventDataStateCopyWithImpl<_$_EditEventDataState>(
          this, _$identity);
}

abstract class _EditEventDataState implements EditEventDataState {
  const factory _EditEventDataState(
      {final bool isUpdated,
      required final EventData editEventData}) = _$_EditEventDataState;

  @override
  bool get isUpdated;
  @override
  EventData get editEventData;
  @override
  @JsonKey(ignore: true)
  _$$_EditEventDataStateCopyWith<_$_EditEventDataState> get copyWith =>
      throw _privateConstructorUsedError;
}
