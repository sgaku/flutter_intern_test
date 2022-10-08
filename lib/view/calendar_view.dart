import 'package:calendar_sample/common/main.dart';
import 'package:calendar_sample/service/event_db.dart';
import 'package:calendar_sample/view/schedule_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../model/fetch_db.dart';

final showMonthProvider = StateProvider<DateTime?>((ref) => null);
final focusedDayProvider = StateProvider<DateTime>((ref) => DateTime.now());
final selectedDayProvider = StateProvider<DateTime>((ref) => DateTime.now());
final fetchDataBaseProvider = ChangeNotifierProvider((ref) => FetchDateBase());

class CalendarView extends ConsumerStatefulWidget {
  const CalendarView({super.key});

  @override
  CalendarViewState createState() => CalendarViewState();
}

class CalendarViewState extends ConsumerState<CalendarView> {
  late final PageController pageController;

  @override
  void initState() {
    ///driftからイベントを取得
    Future(() async {
      final fetchDataBaseValue = ref.read(fetchDataBaseProvider);
      await fetchDataBaseValue.fetchDataList();
    });
    super.initState();
  }

  List<Event> _getEventsFromDay(DateTime date) {
    final fetchDataBaseValue = ref.watch(fetchDataBaseProvider);
    return fetchDataBaseValue.dataMap[date] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final selectedDayValue = ref.watch(selectedDayProvider);
    final focusedDayValue = ref.watch(focusedDayProvider);
    final showMonthValue = ref.watch(showMonthProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.check),
          onPressed: () async {
            final data = await dataBase.allEventsData;
            print(data);
          },
        ),
        title: const Text("カレンダー"),
        actions: [
          IconButton(
              onPressed: () async {
                final data = await dataBase.allEventsData;
                await dataBase.deleteEvent(data);
              },
              icon: const Icon(Icons.delete)),
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 40),
                  child: OutlinedButton(
                    onPressed: () {
                      ///ボタンを押したら、focusedDayがある月のページにアニメーションする
                      pageController.animateToPage(pageController.initialPage,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      shape: const StadiumBorder(),
                    ),
                    child: const Text(
                      "今日",
                      style: TextStyle(fontSize: 11),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${showMonthValue?.year ?? focusedDayValue.year}年${showMonthValue?.month ?? focusedDayValue.month}月",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      var distance = await _datePicker(context);
                      if (distance != 0) {
                        pageController.animateToPage(
                            pageController.page!.round() + distance,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut);
                      }
                    },
                    icon: const Icon(Icons.arrow_drop_down),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
          TableCalendar(
            onCalendarCreated: (PageController controller) {
              pageController = controller;
            },
            onPageChanged: (day) {
              ref.read(focusedDayProvider.notifier).update((state) => day);
              ref.read(showMonthProvider.notifier).update((state) => day);
            },
            eventLoader: _getEventsFromDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            headerVisible: false,
            firstDay: DateTime(2018),
            lastDay: DateTime(2024),
            focusedDay: focusedDayValue,
            onDaySelected: (DateTime selectDay, DateTime focusDay) {
              ref.read(focusedDayProvider.notifier).update((state) => focusDay);
              ref
                  .read(selectedDayProvider.notifier)
                  .update((state) => selectDay);
              showDialog(
                  context: context,
                  builder: (context) => Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: const [
                          DetailDialog(),
                        ],
                      ));
            },
            selectedDayPredicate: (DateTime date) {
              return isSameDay(selectedDayValue, date);
            },
            calendarBuilders: CalendarBuilders(
              dowBuilder: (_, day) {
                final text = DateFormat.E('ja').format(day);
                return Center(
                  child: Text(
                    text,
                    style: TextStyle(color: _textColor(day), fontSize: 8),
                  ),
                );
              },
              defaultBuilder: (_, day, focusedDay) {
                return Center(
                  child: Text(
                    day.day.toString(),
                    style: TextStyle(
                      color: _textColor(day),
                    ),
                  ),
                );
              },
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
                decoration: BoxDecoration(
                  color: Colors.blueGrey[50],
                ),
                weekdayStyle: const TextStyle(
                  fontSize: 7,
                ),
                weekendStyle: const TextStyle(
                  fontSize: 7,
                )),
            calendarStyle: const CalendarStyle(
                todayDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
                selectedDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                )),
          ),
          Expanded(
            child: Container(
              color: Colors.blueGrey[50],
            ),
          )
        ],
      ),
    );
  }

  Color _textColor(DateTime day) {
    const defaultTextColor = Colors.black87;
    if (day.weekday == DateTime.sunday) {
      return Colors.red;
    }
    if (day.weekday == DateTime.saturday) {
      return Colors.blue[600]!;
    }
    return defaultTextColor;
  }

  ///今表示されている日付と、datePickerで選択した日付を比べて、そこから何ページアニメーションする必要があるかをintで返す
  Future<int> _datePicker(BuildContext context) async {
    final focusedDayValue = ref.watch(focusedDayProvider);
    final showMonthValue = ref.read(showMonthProvider);

    final DateTime? datePicked = await showDatePicker(
        context: context,
        initialDate: focusedDayValue,
        firstDate: DateTime(2018),
        lastDate: DateTime(2024));

    if (datePicked == null) {
      return 0;
    }

    switch (showMonthValue) {
      case null:
        //年が同じで月が違う時
        if (datePicked.year == focusedDayValue.year &&
            datePicked.month != focusedDayValue.month) {
          var cur = datePicked.month.toInt();
          var pre = focusedDayValue.month.toInt();
          return cur - pre;
          //月が同じで年が違う時
        } else if (datePicked.month == focusedDayValue.month &&
            datePicked.year != focusedDayValue.year) {
          var cur = datePicked.year.toInt();
          var pre = focusedDayValue.year.toInt();
          return (cur - pre) * 12;
          //年と月両方違う時
        } else if (datePicked.year != focusedDayValue.year &&
            datePicked.month != focusedDayValue.month) {
          var curY = datePicked.year.toInt();
          var preY = focusedDayValue.year.toInt();
          var curM = datePicked.month.toInt();
          var preM = focusedDayValue.month.toInt();
          var disY = curY - preY;
          return (curM - preM) + disY * 12;
        }
        break;
      default:
        //年が同じで月が違う時
        if (datePicked.year == showMonthValue!.year &&
            datePicked.month != showMonthValue.month) {
          var cur = datePicked.month.toInt();
          var pre = showMonthValue.month.toInt();
          return cur - pre;
          //月が同じで年が違う時
        } else if (datePicked.month == showMonthValue.month &&
            datePicked.year != showMonthValue.year) {
          var cur = datePicked.year.toInt();
          var pre = showMonthValue.year.toInt();
          return (cur - pre) * 12;
          //年と月両方違う時
        } else if (datePicked.year != showMonthValue.year &&
            datePicked.month != showMonthValue.month) {
          var curY = datePicked.year.toInt();
          var preY = showMonthValue.year.toInt();
          var curM = datePicked.month.toInt();
          var preM = showMonthValue.month.toInt();
          var disY = curY - preY;
          return (curM - preM) + disY * 12;
        }
        break;
    }
    return 0;
  }
}

class DetailDialog extends ConsumerWidget {
  const DetailDialog({super.key, required});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateFormat time = DateFormat.Hm();
    final selectedValue = ref.watch(selectedDayProvider);
    final selectedEvents = ref.watch(
        fetchDataBaseProvider.select((value) => value.dataMap[selectedValue]));
    return AlertDialog(
      insetPadding: const EdgeInsets.all(8),
      content: SizedBox(
        width: 270,
        height: 530,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                    text: const TextSpan(
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 17),
                        children: <TextSpan>[
                      TextSpan(text: '2022/10/08'),
                      TextSpan(
                          text: '(土)',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                          ))
                    ])),
                IconButton(
                  onPressed: () {
                    ///編集ページへ遷移
                    Navigator.pushNamed(context, 'schedule');
                  },
                  icon: const Icon(Icons.add),
                  color: Colors.blue,
                )
              ],
            ),
            if (selectedEvents == null)
              const Expanded(
                child: Center(
                  child: Text("予定がありません。"),
                ),
              )
            else
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: List.generate(
                      selectedEvents.length,
                      (index) {
                        final currentEvent = selectedEvents[index];
                        return Column(
                          children: [
                            const Divider(
                              height: 1,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: ListTile(
                                leading: SizedBox(
                                  width: 50,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            time.format(
                                                currentEvent.startDateTime),
                                            style: const TextStyle(fontSize: 12),
                                          ),
                                          Text(
                                            time.format(
                                                currentEvent.endDateTime),
                                            style: const TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                      const VerticalDivider(
                                        thickness: 4,
                                        color: Colors.blue,
                                      ),
                                    ],
                                  ),
                                ),
                                title: Text(
                                  currentEvent.title,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                onTap: (){
                                  Navigator.pushNamed(context, 'schedule',arguments: currentEvent );
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    );
  }
}
