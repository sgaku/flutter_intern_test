import 'package:calendar_sample/main.dart';
import 'package:calendar_sample/service/event_db.dart';

import 'package:flutter/widgets.dart';

class FetchDateBase extends ChangeNotifier {
  //startDatetimeをkeyにする
  Map<DateTime, List<Event>> dataMap = {};
  List<Event> events = [];

  Future<void> fetchDataList() async {
    //driftのデータを全取得して、listに格納する
    events = await dataBase.allEventsData;
    //新しいデータのみをdataMapに追加したいので、eventsの最後の要素をdataMapに格納する
      if (dataMap.containsKey(events[events.length-1].selectedDate)) {
        dataMap[events[events.length-1].selectedDate]!.add(events[events.length-1]);
      } else {
       dataMap[events[events.length-1].selectedDate] = events[events.length-1] as List<Event>;
      }

    notifyListeners();
    events.clear();
  }
}
