import 'package:calendar_sample/service/event_db.dart';
import 'package:calendar_sample/view/schedule_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

final showMonthProvider = StateProvider<DateTime?>((ref) => null);
final focusedDayProvider = StateProvider<DateTime>((ref) => DateTime.now());
final selectedDayProvider = StateProvider<DateTime>((ref) => DateTime.now());



class CalendarView extends ConsumerStatefulWidget {
  const CalendarView({super.key});

  @override
  CalendarViewState createState() => CalendarViewState();
}

class CalendarViewState extends ConsumerState<CalendarView> {
  late final PageController pageController;

  ///focusedDayがある月のページ番号

  DateTime? selectedDay;
  DateTime now = DateTime.now();
  DateTime focusedDay = DateTime.now();
  Map<DateTime,List<Event>> selectedEvent = {};

  @override
  void initState() {
    selectedDay = DateTime.utc(now.year, now.month, now.day);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final selectedDayValue = ref.watch(selectedDayProvider);
    final focusedDayValue = ref.watch(focusedDayProvider);
    final showMonthValue = ref.watch(showMonthProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("カレンダー"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: () {
                    ///ボタンを押したら、focusedDayがある月のページにアニメーションしたい
                    pageController.animateToPage(pageController.initialPage,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut);
                  },
                  style: OutlinedButton.styleFrom(
                    primary: Colors.black,
                    shape: const StadiumBorder(),
                  ),
                  child: const Text("今日"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${showMonthValue?.year ?? focusedDayValue.year}年${showMonthValue?.month ?? focusedDayValue.month}月",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
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
          ),
          TableCalendar(
            onCalendarCreated: (PageController controller) {
              pageController = controller;
            },
            onPageChanged: (day) {
              ref.read(focusedDayProvider.notifier).update((state) => day);
              ref.read(showMonthProvider.notifier).update((state) => day);
            },

            startingDayOfWeek: StartingDayOfWeek.monday,
            headerVisible: false,
            firstDay: DateTime.utc(2018),
            lastDay: DateTime.utc(2024),
            focusedDay: focusedDayValue,
            onDaySelected: (DateTime selectDay, DateTime focusDay) {
              ref.read(focusedDayProvider.notifier).update((state) => focusDay);
              ref
                  .read(selectedDayProvider.notifier)
                  .update((state) => selectDay);
              showDialog(
                  context: context, builder: (context) => const DetailDialog());
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
  const DetailDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      icon: IconButton(
        icon: const Icon(Icons.add),
        onPressed: () {
          //編集ページへ遷移
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ScheduleDetail()),
          );
        },
      ),
      title: const Text("sample"),
      shape: const StadiumBorder(),
    );
  }
}
