import 'package:calendar_sample/main.dart';
import 'package:calendar_sample/view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:calendar_sample/service/event_db.dart';

//provider
final startTimeProvider = StateProvider<DateTime>((ref) {
  final selectedValue = ref.watch(selectedDayProvider);
  // return DateTime.now();
  return DateTime.utc(selectedValue.year, selectedValue.month,
      selectedValue.day, DateTime.now().hour, DateTime.now().minute);
});

final endTimeProvider = StateProvider<DateTime>((ref) {
  final selectedValue = ref.watch(selectedDayProvider);
  // return DateTime.now();
  return DateTime.utc(selectedValue.year, selectedValue.month,
      selectedValue.day, DateTime.now().hour, DateTime.now().minute);
});


final switchProvider = StateProvider((ref) => false);
final titleProvider = StateProvider((ref) => "");
final commentProvider = StateProvider((ref) => "");

class ScheduleDetail extends ConsumerStatefulWidget {
  const ScheduleDetail({super.key});

  @override
  ScheduleDetailState createState() => ScheduleDetailState();
}

class ScheduleDetailState extends ConsumerState<ScheduleDetail> {
  late FocusNode myFocusNode;
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();
  DateFormat dateAndTime = DateFormat('yyyy-MM-dd HH:mm');
  DateFormat date = DateFormat('yyyy-MM-dd ');

  @override
  void initState() {
    myFocusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //provider.value
    final selectedValue = ref.watch(selectedDayProvider);
    final titleValue = ref.watch(titleProvider);
    final isAllDayValue = ref.watch(switchProvider);
    final startTimeValue = ref.watch(startTimeProvider);
    final endTimeValue = ref.watch(endTimeProvider);
    final commentValue = ref.watch(commentProvider);
    final fetchDataBaseValue = ref.watch(fetchDataBaseProvider);

    return Focus(
      focusNode: myFocusNode,
      child: GestureDetector(
        onTap: myFocusNode.requestFocus,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.blueGrey[50],
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: //タイトルとコメントに何も入力されていなかったら（デフォルトで""が入っている）、押せないようにする
                      titleValue.isEmpty || commentValue.isEmpty
                          ? null
                          : () async {
                              //driftにデータを追加
                              await dataBase.addEvent(Event(
                                  selectedDate: selectedValue,
                                  title: titleValue,
                                  isAllDay: isAllDayValue,
                                  startDateTime: startTimeValue,
                                  endDateTime: endTimeValue,
                                  comment: commentValue));
                              //driftのデータを更新
                              await fetchDataBaseValue.fetchDataList();
                              Navigator.pop(context);
                            },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.black,
                  ),
                  child: const Text("保存"),
                ),
              )
            ],
            title: const Text("予定の追加"),
          ),
          body: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    autofocus: true,
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "タイトルを入力してください",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (text) {
                      ref.read(titleProvider.notifier).update((state) => text);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 12, bottom: 1, left: 12, right: 12),
                  child: Container(
                    height: 40,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("終日"),
                          Switch(
                              value: isAllDayValue,
                              onChanged: (value) {
                                ref
                                    .read(switchProvider.notifier)
                                    .update((state) => value);
                              })
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
                  child: Container(
                    height: 40,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("開始"),
                          TextButton(
                            style: TextButton.styleFrom(
                                foregroundColor: Colors.black),
                            child: Text(isAllDayValue
                                ? date.format(startTimeValue)
                                : dateAndTime.format(startTimeValue)),
                            onPressed: () {
                              _showCupertinoPicker(
                                CupertinoDatePicker(
                                  initialDateTime: DateTime.now(),
                                  mode: isAllDayValue
                                      ? CupertinoDatePickerMode.date
                                      : CupertinoDatePickerMode.dateAndTime,
                                  use24hFormat: true,
                                  onDateTimeChanged: (dateTime) {
                                    setState(() {
                                      startTime = dateTime;
                                    });
                                    // startTimeController.state = dateTime;
                                  },
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
                  child: Container(
                    height: 40,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("終了"),
                          TextButton(
                            style: TextButton.styleFrom(
                                foregroundColor: Colors.black),
                            child: Text(isAllDayValue
                                ? date.format(endTimeValue)
                                : dateAndTime.format(endTimeValue)),
                            onPressed: () {
                              _showCupertinoPicker(
                                CupertinoDatePicker(
                                  initialDateTime: DateTime.now(),
                                  mode: isAllDayValue
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
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    maxLines: null,
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "コメントを入力してください",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (text) {
                      ref
                          .read(commentProvider.notifier)
                          .update((state) => text);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Container(
                    height: 50,
                    color: Colors.white,
                    child: Center(
                      child: TextButton(
                        child: const Text(
                          "この予定を削除",
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
                        final switchValue = ref.read(switchProvider);
                        final isEndTimeBefore = endTime.isBefore(startTime);
                        final isEqual = endTime.microsecondsSinceEpoch ==
                            startTime.millisecondsSinceEpoch;

                        if (isEndTimeBefore || isEqual && switchValue) {
                          endTime = startTime.add(const Duration(days: 1));
                        } else if (isEndTimeBefore || isEqual && !switchValue) {
                          endTime = startTime.add(const Duration(hours: 1));
                        }
                        ref
                            .read(startTimeProvider.notifier)
                            .update((state) => startTime);
                        ref
                            .read(endTimeProvider.notifier)
                            .update((state) => endTime);

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
