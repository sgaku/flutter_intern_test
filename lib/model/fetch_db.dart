import 'package:calendar_sample/common/main.dart';
import 'package:calendar_sample/service/event_db.dart';

import 'package:flutter/widgets.dart';

class FetchDateBase extends ChangeNotifier {
  //startDatetimeをkeyにする
  Map<DateTime, List<Event>> dataMap = {};
  List<Event> events = [];

  Future<void> fetchDataList() async {
    //driftのデータを全取得して、listに格納する
    events = await dataBase.allEventsData;
    dataMap = {};
    for (final e in events) {
      if (dataMap[e.selectedDate] == null) {
        dataMap[e.selectedDate] = [e];
      } else {
        dataMap[e.selectedDate]!.add(e);
      }
    }

    notifyListeners();
    events.clear();
  }
}
