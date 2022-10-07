import 'package:calendar_sample/service/event_db.dart';

import 'package:flutter/widgets.dart';

class FetchDateBase extends ChangeNotifier{

  Map<DateTime,List<Event>> dataMap = {};
  List<Event> events = [];
  
 // final map = Map.fromIterables(events.map((e) => e.startDateTime).toList(),events.map((e) => e.copyWith()))
  

}