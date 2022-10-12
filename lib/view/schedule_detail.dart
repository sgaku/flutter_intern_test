import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:calendar_sample/common/main.dart';
import 'package:calendar_sample/service/event_db.dart';
import 'package:calendar_sample/view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

//provider
final startTimeProvider = StateProvider.autoDispose<DateTime>((ref) {
  final selectedValue = ref.watch(selectedDayProvider);
  return DateTime(selectedValue.year, selectedValue.month, selectedValue.day,
      DateTime.now().hour, DateTime.now().minute);
});

final endTimeProvider = StateProvider.autoDispose<DateTime>((ref) {
  final selectedValue = ref.watch(selectedDayProvider);
  return DateTime(selectedValue.year, selectedValue.month, selectedValue.day,
      DateTime.now().hour, DateTime.now().minute);
});

final switchProvider = StateProvider.autoDispose((ref) => false);
final titleProvider = StateProvider.autoDispose((ref) => "");
final commentProvider = StateProvider.autoDispose((ref) => "");

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
  DateFormat date = DateFormat('yyyy-MM-dd');
  var uuid = Uuid();

  @override
  void initState() {
    myFocusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Event? arg = (ModalRoute.of(context)?.settings.arguments) as Event?;
    //selectedDayのプロバイダー
    final selectedValue = ref.watch(selectedDayProvider);
    //autoDisposeされるプロバイダー
    final titleValue = ref.watch(titleProvider);
    final isAllDayValue = ref.watch(switchProvider);
    final startTimeValue = ref.watch(startTimeProvider);
    final endTimeValue = ref.watch(endTimeProvider);
    final commentValue = ref.watch(commentProvider);
    //データベースを取ってくるプロバイダー
    final fetchDataBaseValue = ref.watch(fetchDataBaseProvider);
    final selectedEvents = ref.watch(
        fetchDataBaseProvider.select((value) => value.dataMap[selectedValue]));

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
                //TODO: showModalActionSheetの実装
                Navigator.popUntil(context, ModalRoute.withName("/"));
                // showModalActionSheet(
                //    context: (context),
                //    message: "編集を破棄",
                //    title: "編集を破棄",
                //    cancelLabel: "キャンセル",
                //  );
              },
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed:
                      //タイトルとコメントに何も入力されていなかったら（デフォルトで""が入っている）、押せないようにする
                      arg == null
                          ? titleValue.isEmpty || commentValue.isEmpty
                              ? null
                              : () async {
                                  await dataBase.addEvent(Event(
                                      id: uuid.v1(),
                                      selectedDate: selectedValue,
                                      title: titleValue,
                                      isAllDay: isAllDayValue,
                                      startDateTime: startTimeValue,
                                      endDateTime: endTimeValue,
                                      comment: commentValue));
                                  //driftのデータを更新
                                  await fetchDataBaseValue.fetchDataList();
                                  Navigator.popUntil(
                                      context, ModalRoute.withName("/"));
                                }

                          ///もし既にデータがある場合は、updateする
                          //TODO: アップデートの条件をなおす
                          : () async {
                              await dataBase.updateEvent(Event(
                                  id: arg.id,
                                  selectedDate: arg.selectedDate,
                                  title: titleValue.isEmpty
                                      ? arg.title
                                      : titleValue,
                                  isAllDay: isAllDayValue,
                                  startDateTime: arg.startDateTime,
                                  endDateTime: arg.endDateTime,
                                  comment: commentValue.isEmpty
                                      ? arg.comment
                                      : commentValue));
                              //driftのデータを更新
                              await fetchDataBaseValue.fetchDataList();
                              Navigator.popUntil(
                                  context, ModalRoute.withName("/"));
                            },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.black,
                  ),
                  child: const Text("保存"),
                ),
              )
            ],
            title: selectedEvents == null
                ? const Text("予定の追加")
                : const Text("予定の編集"),
          ),
          body: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    initialValue: arg == null ? "" : arg.title,
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
                              value: arg == null ? isAllDayValue : arg.isAllDay,
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
                            child: Text(arg == null
                                ? isAllDayValue
                                    ? date.format(startTimeValue)
                                    : dateAndTime.format(startTimeValue)
                                : isAllDayValue
                                    ? date.format(arg.startDateTime)
                                    : dateAndTime.format(arg.startDateTime)),
                            onPressed: () {
                              int initialMinute = startTimeValue.minute;
                              if (initialMinute % 15 != 0) {
                                initialMinute =
                                    initialMinute - initialMinute % 15 + 15;
                              }
                              _showCupertinoPicker(
                                CupertinoDatePicker(
                                  minuteInterval: 15,
                                  initialDateTime: DateTime(
                                      startTimeValue.year,
                                      startTimeValue.month,
                                      startTimeValue.day,
                                      startTimeValue.hour,
                                      initialMinute),
                                  mode: isAllDayValue
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
                            child: Text(arg == null
                                ? isAllDayValue
                                    ? date.format(endTimeValue)
                                    : dateAndTime.format(endTimeValue)
                                : isAllDayValue
                                    ? date.format(arg.endDateTime)
                                    : dateAndTime.format(arg.endDateTime)),
                            onPressed: () {
                              int initialMinute = endTimeValue.minute;
                              if (initialMinute % 15 != 0) {
                                initialMinute =
                                    initialMinute - initialMinute % 15 + 15;
                              }
                              _showCupertinoPicker(
                                CupertinoDatePicker(
                                  minuteInterval: 15,
                                  initialDateTime: DateTime(
                                      startTimeValue.year,
                                      endTimeValue.month,
                                      endTimeValue.day,
                                      endTimeValue.hour,
                                      (initialMinute)),
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
                  child: TextFormField(
                    initialValue: arg == null ? "" : arg.comment,
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
                        onPressed: () {
                          //TODO: showOkCancelAlertDialogの実装 driftでデータベースの削除
                          showOkCancelAlertDialog(
                            context: (context),
                            title: "予定の削除",
                            message: "本当にこの日の予定を削除しますか？",
                            okLabel: "削除",
                            cancelLabel: "キャンセル",
                          );
                        },
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

                        switch (switchValue) {
                          case true:
                            if (isEndTimeBefore || isEqual) {
                              endTime = startTime.add(const Duration(days: 1));
                            }
                            break;
                          case false:
                            if (isEndTimeBefore || isEqual) {
                              endTime = startTime.add(const Duration(hours: 1));
                            }
                            break;
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
