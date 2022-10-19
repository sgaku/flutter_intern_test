import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../common/text_color.dart';
import '../event_state_notifier.dart';
import 'calendar_view.dart';

class ScheduleDialog extends ConsumerStatefulWidget {
  const ScheduleDialog(this.calendarController, {super.key});

  final PageController calendarController;

  @override
  ScheduleDialogState createState() => ScheduleDialogState();
}

class ScheduleDialogState extends ConsumerState<ScheduleDialog> {
  late final PageController controller;
  final firstDay = DateTime(2018);
  final lastDay = DateTime(2024);
  late int previousPage;

  @override
  void initState() {
    final selectedDayState = ref.read(selectedDayProvider);
    final initialPageCount = _getPageCount(firstDay, selectedDayState);
    previousPage = initialPageCount;
    controller = PageController(initialPage: initialPageCount,viewportFraction: 0.85);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateFormat time = DateFormat.Hm();
    final dateFormatForDayOfWeek = DateFormat.E('ja');
    DateFormat dateFormatForDate = DateFormat('yyyy/MM/dd');
    final selectedValue = ref.watch(selectedDayProvider);

    ///選択した日付のイベントを取得
    final selectedEvents = ref.watch(eventStateProvider
        .select((value) => value.eventDataMap[selectedValue]));
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          height: 600,
          child: PageView.builder(
            controller: controller,
            itemCount: _getPageCount(firstDay, lastDay),
            onPageChanged: (int page) {
              if (page > previousPage) {
                ref
                    .read(selectedDayProvider.notifier)
                    .update((state) => selectedValue.add(const Duration(days: 1)));
              } else {
                ref
                    .read(selectedDayProvider.notifier)
                    .update((state) => selectedValue.add(const Duration(days: -1)));
              }
              previousPage = page;
              var distance = _getMonthDiffer();
              if (distance != 0) {
                widget.calendarController.animateToPage(
                    widget.calendarController.page!.round() + distance,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut);
              }
            },
            itemBuilder: (context, index) {
              return AlertDialog(
                insetPadding: const EdgeInsets.all(8),
                content: SizedBox(
                  width: 250,
                  height: 510,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                              text: TextSpan(
                                  style: TextStyle(
                                      color: textColor(selectedValue),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17),
                                  children: <TextSpan>[
                                TextSpan(
                                    text: dateFormatForDate.format(selectedValue)),
                                TextSpan(
                                    text:
                                        " (${dateFormatForDayOfWeek.format(selectedValue)})",
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
                        Expanded(
                          child: Column(
                            children: const [
                              Divider(
                                height: 1,
                              ),
                              Expanded(child: Center(child: Text("予定がありません。"))),
                            ],
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
                                        padding:
                                            const EdgeInsets.symmetric(vertical: 4),
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
                                                            time.format(currentEvent
                                                                .startTime),
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
                                            Navigator.pushNamed(
                                                context, 'editSchedule',
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
            },
          ),
        ),
      ],
    );
  }

  int _getPageCount(DateTime first, DateTime last) {
    return last.difference(first).inDays;
  }

  int _getMonthDiffer() {
    final focusedDayValue = ref.watch(focusedDayProvider);
    final selectedValue = ref.watch(selectedDayProvider);

    ///年が同じで月が違う時
    if (selectedValue.year == focusedDayValue.year &&
        selectedValue.month != focusedDayValue.month) {
      return selectedValue.month.toInt() - focusedDayValue.month.toInt();

      ///月が同じで年が違う時
    } else if (selectedValue.month == focusedDayValue.month &&
        selectedValue.year != focusedDayValue.year) {
      return (selectedValue.year.toInt() - focusedDayValue.year.toInt()) * 12;

      ///年と月両方違う時
    } else if (selectedValue.year != focusedDayValue.year &&
        selectedValue.month != focusedDayValue.month) {
      var disY = selectedValue.year.toInt() - focusedDayValue.year.toInt();
      return (selectedValue.month.toInt() - focusedDayValue.month.toInt()) +
          disY * 12;
    }
    return 0;
  }
}
