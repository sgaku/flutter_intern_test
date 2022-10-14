import 'package:calendar_sample/model/event_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_state.freezed.dart';

@freezed
class EventState with _$EventState {
  const factory EventState({
    @Default({}) Map<DateTime, List<EventData>> eventDataMap,
  }) = _EventState;
}
