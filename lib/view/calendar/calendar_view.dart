import 'package:calendar_sample/model/event_data.dart';
import 'package:calendar_sample/view/calendar/schedule_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../common/text_color.dart';
import '../event_state_notifier.dart';

final focusedDayProvider = StateProvider<DateTime>((ref) => DateTime.now());
final selectedDayProvider = StateProvider<DateTime>((ref) => DateTime.now());

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

    ///eventLoaderに表示するデータを更新
    Future(() async {
      await ref.read(eventStateProvider.notifier).fetchEventDataMap();
    });
    super.initState();
  }

  List<EventData> _getEventsFromDay(DateTime date) {
    final fetchEventValue = ref.watch(eventStateProvider);
    return fetchEventValue.eventDataMap[date] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final selectedDayValue = ref.watch(selectedDayProvider);
    final focusedDayValue = ref.watch(focusedDayProvider);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 238, 237),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          title: const Text("カレンダー"),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 40),
                      child: OutlinedButton(
                        onPressed: () {
                          ///ボタンを押したら、初期ページにアニメーションする
                          pageController.animateToPage(
                              pageController.initialPage,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut);

                          ///今日の日付が選択されているようにする
                          ref
                              .read(selectedDayProvider.notifier)
                              .update((state) => DateTime.now());
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
                          "${focusedDayValue.year}年${focusedDayValue.month}月",
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
            ),
            Container(
              color: Colors.white,
              child: TableCalendar(
                onCalendarCreated: (PageController controller) {
                  pageController = controller;
                },
                onPageChanged: (day) {
                  ref.read(focusedDayProvider.notifier).update((state) => day);
                },
                eventLoader: _getEventsFromDay,
                startingDayOfWeek: StartingDayOfWeek.monday,
                headerVisible: false,
                firstDay: DateTime(2018),
                lastDay: DateTime(2024),
                focusedDay: focusedDayValue,
                onDaySelected: (DateTime selectDay, DateTime focusDay) {
                  ref
                      .read(focusedDayProvider.notifier)
                      .update((state) => focusDay);
                  ref
                      .read(selectedDayProvider.notifier)
                      .update((state) => selectDay);
                  showDialog(
                      context: context,
                      builder: (context) => ScheduleDialog(pageController));
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
                        style: TextStyle(color: textColor(day), fontSize: 8),
                      ),
                    );
                  },
                  outsideBuilder: (_, day, focusedDay) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: EdgeInsets.zero,
                      alignment: Alignment.center,
                      child: Text(
                        day.day.toString(),
                        style: const TextStyle(
                          color: Color(0xFFAEAEAE),
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
                          color: textColor(day),
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
                          color: _selectedDayColor(day, focusedDay),
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
                daysOfWeekStyle: const DaysOfWeekStyle(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 240, 238, 237),
                    ),
                    weekdayStyle: TextStyle(
                      fontSize: 7,
                    ),
                    weekendStyle: TextStyle(
                      fontSize: 7,
                    )),
                calendarStyle: const CalendarStyle(
                    markersMaxCount: 1,
                    markerMargin: EdgeInsets.only(top: 3),
                    markerSize: 7,
                    todayDecoration: BoxDecoration(
                      color: Colors.transparent,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.white,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _selectedDayColor(DateTime day, DateTime focusedDay) {
    var now = DateTime.now();
    const defaultTextColor = Colors.black87;
    if (DateTime(day.year, day.month, day.day) ==
        DateTime(now.year, now.month, now.day)) {
      return Colors.white;
    }
    if (day.month != focusedDay.month) {
      return const Color(0xFFAEAEAE);
    }

    if (day.weekday == DateTime.sunday) {
      return Colors.red;
    }
    if (day.weekday == DateTime.saturday) {
      return Colors.blue[600]!;
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

  ///今表示されている日付と、datePickerで選択した日付の月の差分を計算して、そこから何ページアニメーションする必要があるかをintで返す
  Future<int> _datePicker(BuildContext context) async {
    final focusedDayValue = ref.watch(focusedDayProvider);
    final DateTime? datePicked = await showDatePicker(
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        context: context,
        initialDate: focusedDayValue,
        firstDate: DateTime(2018),
        lastDate: DateTime(2024));

    if (datePicked == null) {
      return 0;
    }

    ///年が同じで月が違う時
    if (datePicked.year == focusedDayValue.year &&
        datePicked.month != focusedDayValue.month) {
      return datePicked.month.toInt() - focusedDayValue.month.toInt();

      ///月が同じで年が違う時
    } else if (datePicked.month == focusedDayValue.month &&
        datePicked.year != focusedDayValue.year) {
      return (datePicked.year.toInt() - focusedDayValue.year.toInt()) * 12;

      ///年と月両方違う時
    } else if (datePicked.year != focusedDayValue.year &&
        datePicked.month != focusedDayValue.month) {
      var disY = datePicked.year.toInt() - focusedDayValue.year.toInt();
      return (datePicked.month.toInt() - focusedDayValue.month.toInt()) +
          disY * 12;
    }
    return 0;
  }
}
