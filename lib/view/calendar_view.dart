import 'package:calendar_sample/common/main.dart';
import 'package:calendar_sample/repository/event_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
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
    initializeDateFormatting('ja');

    ///driftからイベントを取得
    Future(() async {
      final fetchDataBaseValue = ref.read(fetchDataBaseProvider);
      await fetchDataBaseValue.fetchDataList();
    });
    super.initState();
  }

  List<EventData> _getEventsFromDay(DateTime date) {
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
                final List<EventData> eventData = [];
                for (int i = 0; i < data.length; i++) {
                  eventData.add(EventData(
                      id: data[i].id,
                      selectedDate: data[i].selectedDate,
                      title: data[i].title,
                      isAllDay: data[i].isAllDay,
                      startTime: data[i].startDateTime,
                      endTime: data[i].endDateTime,
                      comment: data[i].comment));
                }
                await dataBase.deleteAllEvent(eventData);
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
              outsideBuilder:  (_, day, focusedDay) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: EdgeInsets.zero,
                  alignment: Alignment.center,
                  child: Text(
                    day.day.toString(),
                    style: const TextStyle(
                      color : Color(0xFFAEAEAE),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
              defaultBuilder: (_, day, focusedDay) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: EdgeInsets.zero,
                  alignment: Alignment.center,
                  child: Text(
                    day.day.toString(),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: _textColor(day),
                    ),
                  ),
                );
              },
              selectedBuilder: (_, day, focusedDay) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.all(9),
                  alignment: Alignment.center,
                  decoration: _decorationColor(day),
                  child: Text(
                    day.day.toString(),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: _textColor(day),
                    ),
                  ),
                );
              },
              todayBuilder: (_, day, focusedDay) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.all(9),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                  child: Text(
                    day.day.toString(),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
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
              markersMaxCount: 1,
              markerMargin:EdgeInsets.only(top: 3) ,
              markerSize: 7,
              todayDecoration: BoxDecoration(
                color: Colors.transparent,
              ),
            ),
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
    if (day.day == DateTime.now().day) {
      return Colors.white;
    }
    return defaultTextColor;
  }

  BoxDecoration _decorationColor(DateTime day) {
    if (day.day == DateTime.now().day) {
      return const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue,
      );
    }
    return const BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.transparent,
    );
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
          return datePicked.month.toInt() - focusedDayValue.month.toInt();
          //月が同じで年が違う時
        } else if (datePicked.month == focusedDayValue.month &&
            datePicked.year != focusedDayValue.year) {
          return (datePicked.year.toInt() - focusedDayValue.year.toInt()) * 12;
          //年と月両方違う時
        } else if (datePicked.year != focusedDayValue.year &&
            datePicked.month != focusedDayValue.month) {
          var disY = datePicked.year.toInt() - focusedDayValue.year.toInt();
          return (datePicked.month.toInt() - focusedDayValue.month.toInt()) +
              disY * 12;
        }
        break;
      default:
        //年が同じで月が違う時
        if (datePicked.year == showMonthValue!.year &&
            datePicked.month != showMonthValue.month) {
          return datePicked.month.toInt() - showMonthValue.month.toInt();
          //月が同じで年が違う時
        } else if (datePicked.month == showMonthValue.month &&
            datePicked.year != showMonthValue.year) {
          return (datePicked.year.toInt() - showMonthValue.year.toInt()) * 12;
          //年と月両方違う時
        } else if (datePicked.year != showMonthValue.year &&
            datePicked.month != showMonthValue.month) {
          var disY = datePicked.year.toInt() - showMonthValue.year.toInt();
          return (datePicked.month.toInt() - showMonthValue.month.toInt()) +
              disY * 12;
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
    final dateFormatForDayOfWeek = DateFormat.E('ja');
    DateFormat formatDayTitle = DateFormat('yyyy/MM/dd');
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
                    text: TextSpan(
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 17),
                        children: <TextSpan>[
                      TextSpan(text: formatDayTitle.format(selectedValue)),
                      TextSpan(
                          text: dateFormatForDayOfWeek.format(selectedValue),
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                          ))
                    ])),
                IconButton(
                  onPressed: () {
                    ///編集ページへ遷移
                    Navigator.pushNamed(context, 'addSchedule');
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
                                      currentEvent.isAllDay
                                          ? const Center(child: Text("終日"))
                                          : Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  time.format(
                                                      currentEvent.startTime),
                                                  style: const TextStyle(
                                                      fontSize: 12),
                                                ),
                                                Text(
                                                  time.format(
                                                      currentEvent.endTime),
                                                  style: const TextStyle(
                                                      fontSize: 12),
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
                                onTap: () {
                                  Navigator.pushNamed(context, 'editSchedule',
                                      arguments: currentEvent);
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
