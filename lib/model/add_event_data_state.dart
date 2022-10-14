import 'package:calendar_sample/model/event_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_event_data_state.freezed.dart';

@freezed
class AddEventDataState with _$AddEventDataState {
  const factory AddEventDataState({
    EventData? addEventData,
  }) = _AddEventDataState;
}
