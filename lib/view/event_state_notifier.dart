import 'package:calendar_sample/model/event_data.dart';
import 'package:calendar_sample/repository/event_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/event_state.dart';

final eventStateProvider =
    StateNotifierProvider<EventStateNotifier, EventState>((ref) {
  return EventStateNotifier(ref);
});

class EventStateNotifier extends StateNotifier<EventState> {
  EventStateNotifier(this.ref) : super(const EventState());

  final Ref ref;

  Future<void> fetchEventDataMap() async {
    ///driftのデータを全取得して、listに格納する
    final events = await ref.read(eventRepositoryProvider).allEventsData;
    final Map<DateTime, List<EventData>> mutableDataMap = {};

    ///Event -> EventData型に変換して代入
    final eventData = List.generate(
        events.length,
        (index) => EventData(
            id: events[index].id,
            selectedDate: events[index].selectedDate,
            title: events[index].title,
            isAllDay: events[index].isAllDay,
            startTime: events[index].startDateTime,
            endTime: events[index].endDateTime,
            comment: events[index].comment));

    for (final e in eventData) {
      ///開始日と終了日の日の差を計算したいので、時間単位を省く
      final startDay =
          DateTime(e.startTime.year, e.startTime.month, e.startTime.day);
      final endDay = DateTime(e.endTime.year, e.endTime.month, e.endTime.day);

      ///開始日と終了日の差を計算
      var differ = endDay.difference(startDay).inDays;

      ///終了日と開始日の差からイベントを追加する回数を決める
      for (int i = 0; i <= differ; i++) {
        final date =
            DateTime(e.startTime.year, e.startTime.month, e.startTime.day + i);

        if (state.eventDataMap[date.add(date.timeZoneOffset).toUtc()] == null) {
          mutableDataMap[date.add(date.timeZoneOffset).toUtc()] = [e];
          state = state.copyWith(eventDataMap: mutableDataMap);
        } else {
          if (mutableDataMap[date.add(date.timeZoneOffset).toUtc()] == null) {
            mutableDataMap[date.add(date.timeZoneOffset).toUtc()] = [e];
            state = state.copyWith(eventDataMap: mutableDataMap);
          } else {
            mutableDataMap[date.add(date.timeZoneOffset).toUtc()]!.add(e);
            state = state.copyWith(eventDataMap: mutableDataMap);
          }
        }
      }
    }
  }
}
