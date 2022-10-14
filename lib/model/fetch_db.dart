import 'package:calendar_sample/common/main.dart';
import 'package:calendar_sample/repository/event_data.dart';

import 'package:flutter/widgets.dart';

class FetchDateBase extends ChangeNotifier {

  Map<DateTime, List<EventData>> dataMap = {};
  List<EventData> eventData = [];

  Future<void> fetchDataList() async {
    ///driftのデータを全取得して、listに格納する
    final events = await dataBase.allEventsData;

    ///Event -> EventData型に変換して代入
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

    ///dataMapの初期化
    dataMap = {};
    for (final e in eventData) {
      ///開始日と終了日の日の差を計算したいので、時間単位を省く
        final startDay =
            DateTime(e.startTime.year, e.startTime.month, e.startTime.day);
        final endDay = DateTime(e.endTime.year, e.endTime.month, e.endTime.day);

        ///開始日と終了日の差を計算
        var differ = endDay.difference(startDay).inDays;

        ///終了日と開始日の差からイベントを追加する回数を決める
        for (int i = 0; i <= differ; i++) {
          final date = DateTime(
              e.startTime.year, e.startTime.month, e.startTime.day + i);
          if (dataMap[date.add(date.timeZoneOffset).toUtc()] == null) {
            dataMap[date.add(date.timeZoneOffset).toUtc()] = [e];
          } else {
            dataMap[date.add(date.timeZoneOffset).toUtc()]!.add(e);
          }
        }
    }

    notifyListeners();
    eventData.clear();
  }
}
