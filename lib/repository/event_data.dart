import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_data.freezed.dart';

@freezed
class EditEventDataState with _$EditEventDataState {
  const factory EditEventDataState({
    @Default(false)bool isUpdated,
    required EventData editEventData,
  }) = _EditEventDataState;
}

@freezed
class AddEventDataState with _$AddEventDataState{
  const factory AddEventDataState({
    required EventData? addEventData,
}) = _AddEventDataState;
}



@freezed
class EventData with _$EventData {
  const factory EventData({
    required String id,
    required DateTime selectedDate,
    required String title,
    required bool isAllDay,
    required DateTime startTime,
    required DateTime endTime,
    required String comment,
  }) = _EventData;
}
