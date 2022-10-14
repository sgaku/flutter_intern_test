import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_data.freezed.dart';

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
