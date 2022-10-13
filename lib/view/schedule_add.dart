import 'package:calendar_sample/view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../model/add_event_provider.dart';
import '../repository/event_data.dart';

//provider
final eventDataProvider =
    StateNotifierProvider.autoDispose<AddEventDataNotifier, AddEventDataState>(
        (ref) {
  return AddEventDataNotifier();
});

class AddSchedulePage extends ConsumerStatefulWidget {
  const AddSchedulePage({super.key});

  @override
  ScheduleDetailState createState() => ScheduleDetailState();
}

class ScheduleDetailState extends ConsumerState<AddSchedulePage> {
  late FocusNode myFocusNode;

  ///代入するデータのパラメータ（stateNotifierに入れるための変数）
  String title = "";
  bool isAllDay = false;
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();
  String comment = "";

  DateFormat dateAndTime = DateFormat('yyyy-MM-dd HH:mm');
  DateFormat date = DateFormat('yyyy-MM-dd');
  var uuid = Uuid();

  @override
  void initState() {
    myFocusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //selectedDayのプロバイダー
    final selectedValue = ref.watch(selectedDayProvider);
    //データベースを取ってくるプロバイダー
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
                  Navigator.popUntil(context, ModalRoute.withName("/"));
                },
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed:
                        ///タイトルとコメントに何も入力されていなかったら（デフォルトで""が入っている）、押せないようにする
                        title.isEmpty || comment.isEmpty
                            ? null
                            : () async {
                                final data = EventData(
                                    id: uuid.v1(),
                                    selectedDate: selectedValue,
                                    title: title,
                                    isAllDay: isAllDay,
                                    startTime: startTime,
                                    endTime: endTime,
                                    comment: comment);
                                ref
                                    .read(eventDataProvider.notifier)
                                    .addEvents(data);

                                //driftのデータを更新
                                await fetchDataBaseValue.fetchDataList();
                                Navigator.popUntil(
                                    context, ModalRoute.withName("/"));
                              },

                    ///もし既にデータがある場合は、updateする
                    //TODO: アップデートの条件をなおす

                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.black,
                    ),
                    child: const Text("保存"),
                  ),
                )
              ],
              title: const Text("予定の追加")),
          body: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    initialValue: "",
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
                      setState(() {
                        title = text;
                      });
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
                              value: isAllDay,
                              onChanged: (value) {
                                setState(() {
                                  isAllDay = value;
                                });
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
                            child: Text(isAllDay
                                ? date.format(startTime)
                                : dateAndTime.format(startTime)),
                            onPressed: () {
                              int initialMinute = startTime.minute;
                              if (initialMinute % 15 != 0) {
                                initialMinute =
                                    initialMinute - initialMinute % 15 + 15;
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
                                  mode: isAllDay
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
                            child: Text(isAllDay
                                ? date.format(endTime)
                                : dateAndTime.format(endTime)),
                            onPressed: () {
                              int initialMinute = endTime.minute;
                              if (initialMinute % 15 != 0) {
                                initialMinute =
                                    initialMinute - initialMinute % 15 + 15;
                              }
                              _showCupertinoPicker(
                                CupertinoDatePicker(
                                  minuteInterval: 15,
                                  initialDateTime: DateTime(
                                      endTime.year,
                                      endTime.month,
                                      endTime.day,
                                      endTime.hour,
                                      (initialMinute)),
                                  mode: isAllDay
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
                  child: TextFormField(
                    initialValue: "",
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
                      setState(() {
                        comment = text;
                      });
                    },
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
