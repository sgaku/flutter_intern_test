import 'package:calendar_sample/repository/event_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EventDataNotifier extends StateNotifier<EventDataState> {
  EventDataNotifier() : super(const EventDataState());

  ///値の追加
  void addEvents(EventData data) {
    final list = List<EventData>.from(state.eventDataList);
    list.add(data);
    state = state.copyWith(eventDataList: list);
    //TODO:driftにデータを追加
  }

  ///値の更新
  void updateTitle(String title) {
    final list = List<EventData>.from(state.eventDataList);
    for(var e in list){
      e.title = title;
    }
    state = state.copyWith(eventDataList: list);
  }

  void updateIsAllDay(bool isAllDay) {}

  void updateStartTime(DateTime startTime) {}

  void updateEndTime(DateTime endTime) {}

  void updateComment(String comment) {}
}
