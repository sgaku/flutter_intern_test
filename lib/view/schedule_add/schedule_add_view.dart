import 'package:calendar_sample/view/calendar/calendar_view.dart';
import 'package:calendar_sample/common/schedule_text_field.dart';
import 'package:calendar_sample/view/event_state_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../common/schedule_app_bar.dart';
import '../../common/schedule_body.dart';
import '../../common/schedule_config_cell.dart';
import 'add_event_state_notifier.dart';
import '../../model/event_data.dart';

class AddScheduleView extends ConsumerStatefulWidget {
  const AddScheduleView({super.key});

  @override
  AddScheduleState createState() => AddScheduleState();
}

class AddScheduleState extends ConsumerState<AddScheduleView> {
  late FocusNode myFocusNode;

  ///代入するデータのパラメータ（stateNotifierに入れるための変数）
  String title = "";
  bool isAllDay = false;
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();
  String comment = "";

  DateFormat dateFormatForDateAndTime = DateFormat('yyyy-MM-dd HH:mm');
  DateFormat dateFormatForDate = DateFormat('yyyy-MM-dd');
  var uuid = const Uuid();

  @override
  void initState() {
    final selectedDayValue = ref.read(selectedDayProvider);
    startTime = DateTime(selectedDayValue.year, selectedDayValue.month,
        selectedDayValue.day, startTime.hour, startTime.minute);
    startTime = _timeFormat(startTime);

    endTime = DateTime(selectedDayValue.year, selectedDayValue.month,
        selectedDayValue.day, endTime.hour, endTime.minute);
    endTime = _timeFormat(endTime);
    myFocusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final selectedValue = ref.watch(selectedDayProvider);

    return Focus(
      focusNode: myFocusNode,
      child: GestureDetector(
        onTap: myFocusNode.requestFocus,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: const Color.fromARGB(255, 240, 238, 237),
          appBar: ScheduleAppBar(
            title: const Text('予定の追加'),
            onPressedIcon: () {
              Navigator.popUntil(context, ModalRoute.withName("/"));
            },
            onPressedElevated:

                ///タイトルとコメントに何も入力されていなかったら（デフォルトで""が入っている）非活性に
                title.isEmpty || comment.isEmpty
                    ? null
                    : () async {
                        ///EventDataクラスで状態管理しているため、そのクラスに格納する形でdriftに追加
                        final data = EventData(
                            id: uuid.v1(),
                            selectedDate: selectedValue,
                            title: title,
                            isAllDay: isAllDay,
                            startTime: startTime,
                            endTime: endTime,
                            comment: comment);
                        await ref
                            .read(addEventStateProvider.notifier)
                            .addEvents(data);

                        ///eventLoaderに表示するデータを更新
                        await ref
                            .read(eventStateProvider.notifier)
                            .fetchEventDataMap();
                        Navigator.popUntil(context, ModalRoute.withName("/"));
                      },
          ),
          body: ScheduleBody(
            titleTextField: ScheduleTextField(
                initialValue: "",
                hintText: 'タイトルを入力してください',
                onChanged: (text) {
                  setState(() {
                    title = text;
                  });
                },
                maxLine: 1),
            isAllDayConfigCell: ScheduleConfigCell(
                leading: const Text("終日"),
                trailing: Switch(
                    value: isAllDay,
                    onChanged: (value) {
                      setState(() {
                        isAllDay = value;
                      });
                    })),
            startTimeConfigCell: ScheduleConfigCell(
                leading: const Text("開始"),
                trailing: TextButton(
                  style: TextButton.styleFrom(foregroundColor: Colors.black),
                  child: Text(

                      ///終日だったら日付のみ、そうでなければ日付と時間を表示
                      isAllDay
                          ? dateFormatForDate.format(startTime)
                          : dateFormatForDateAndTime.format(startTime)),
                  onPressed: () {
                    int initialMinute = startTime.minute;
                    if (initialMinute % 15 != 0) {
                      initialMinute = initialMinute - initialMinute % 15 + 15;
                    }
                    _showCupertinoPicker(
                      CupertinoDatePicker(
                        minuteInterval: 15,
                        initialDateTime: DateTime(
                            startTime.year,
                            startTime.month,
                            startTime.day,
                            startTime.hour,
                            initialMinute),
                        mode:

                            ///終日だったら日付のみ、そうでなければ日付と時間を表示
                            isAllDay
                                ? CupertinoDatePickerMode.date
                                : CupertinoDatePickerMode.dateAndTime,
                        use24hFormat: true,
                        onDateTimeChanged: (dateTime) {
                          setState(() {
                            startTime = dateTime;
                          });
                        },
                      ),
                    );
                  },
                )),
            endTimeConfigCell: ScheduleConfigCell(
                leading: const Text("終了"),
                trailing: TextButton(
                  style: TextButton.styleFrom(foregroundColor: Colors.black),
                  child: Text(

                      ///終日だったら日付のみ、そうでなければ日付と時間を表示
                      isAllDay
                          ? dateFormatForDate.format(endTime)
                          : dateFormatForDateAndTime.format(endTime)),
                  onPressed: () {
                    int initialMinute = endTime.minute;
                    if (initialMinute % 15 != 0) {
                      initialMinute = initialMinute - initialMinute % 15 + 15;
                    }
                    _showCupertinoPicker(
                      CupertinoDatePicker(
                        minuteInterval: 15,
                        initialDateTime: DateTime(endTime.year, endTime.month,
                            endTime.day, endTime.hour, (initialMinute)),
                        mode:

                            ///終日だったら日付のみ、そうでなければ日付と時間を表示
                            isAllDay
                                ? CupertinoDatePickerMode.date
                                : CupertinoDatePickerMode.dateAndTime,
                        use24hFormat: true,
                        onDateTimeChanged: (dateTime) {
                          setState(() {
                            endTime = dateTime;
                          });
                        },
                      ),
                    );
                  },
                )),
            commentTextField: ScheduleTextField(
                initialValue: "",
                hintText: 'コメントを入力してください',
                onChanged: (text) {
                  setState(() {
                    comment = text;
                  });
                },
                maxLine: null),
            removeContainer: Container(),
          ),
        ),
      ),
    );
  }

  DateTime _timeFormat(DateTime t) {
    int initialMinute = t.minute;
    if (initialMinute % 15 != 0) {
      initialMinute = initialMinute - initialMinute % 15 + 15;
    }
    return DateTime(t.year, t.month, t.day, t.hour, initialMinute);
  }

  void _showCupertinoPicker(Widget child) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => Container(
        height: 300,
        padding: const EdgeInsets.only(top: 6),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("キャンセル")),
                  TextButton(
                      onPressed: () {
                        final isEndTimeBefore = endTime.isBefore(startTime);
                        final isEqual = endTime.microsecondsSinceEpoch ==
                            startTime.millisecondsSinceEpoch;

                        switch (isAllDay) {
                          case true:
                            if (isEndTimeBefore || isEqual) {
                              setState(() {
                                endTime = startTime;
                              });
                            }
                            break;
                          case false:
                            if (isEndTimeBefore || isEqual) {
                              setState(() {
                                endTime =
                                    startTime.add(const Duration(hours: 1));
                              });
                            }
                            break;
                        }

                        Navigator.pop(context);
                      },
                      child: const Text("完了")),
                ],
              ),
            ),
            Expanded(child: SafeArea(top: false, child: child)),
          ],
        ),
      ),
    );
  }
}
