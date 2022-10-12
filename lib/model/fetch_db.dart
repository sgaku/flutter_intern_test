import 'package:calendar_sample/common/main.dart';
import 'package:calendar_sample/repository/event_data.dart';

import 'package:flutter/widgets.dart';

class FetchDateBase extends ChangeNotifier {
  //startDatetimeをkeyにする
  Map<DateTime, List<EventData>> dataMap = {};
  List<EventData> eventData = [];

  Future<void> fetchDataList() async {
    //driftのデータを全取得して、listに格納する
    final events = await dataBase.allEventsData;
    for (int i = 0; i < events.length; i++) {
      eventData.add(EventData(
          id: events[i].id,
          selectedDate: events[i].selectedDate,
          title: events[i].title,
          isAllDay: events[i].isAllDay,
          startTime: events[i].startDateTime,
          endTime: events[i].endDateTime,
          comment: events[i].comment));
    }
    dataMap = {};
    for (final e in eventData) {
      if (dataMap[e.selectedDate] == null) {
        dataMap[e.selectedDate] = [e];
      } else {
        dataMap[e.selectedDate]!.add(e);
      }
    }

    notifyListeners();
    events.clear();
    eventData.clear();
  }
}
