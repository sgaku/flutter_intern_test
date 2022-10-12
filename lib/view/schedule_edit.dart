import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:calendar_sample/common/main.dart';
import 'package:calendar_sample/model/edit_event_provider.dart';
import 'package:calendar_sample/view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../repository/event_data.dart';

//provider
final eventDataProvider = StateNotifierProvider.autoDispose
    .family<EditEventDataNotifier, EditEventDataState, EventData>(
        (ref, eventData) {
  return EditEventDataNotifier(eventData);
});

class EditSchedulePage extends ConsumerStatefulWidget {
  const EditSchedulePage({super.key});

  @override
  ScheduleDetailState createState() => ScheduleDetailState();
}

class ScheduleDetailState extends ConsumerState<EditSchedulePage> {
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
    final EventData arg =
        (ModalRoute.of(context)?.settings.arguments) as EventData;

    final eventValue = ref.watch(eventDataProvider(arg));

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
                      !eventValue.isUpdated
                          ? null
                          :

                          ///もし既にデータがある場合は、updateする
                          //TODO: アップデートの条件をなおす
                          () async {
                              dataBase.updateEvent(eventValue.editEventData);
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
            title: const Text("予定の編集"),
          ),
          body: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    initialValue: eventValue.editEventData.title,
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
                      ref
                          .read(eventDataProvider(arg).notifier)
                          .updateTitle(text);
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
                              value: eventValue.editEventData.isAllDay,
                              onChanged: (value) {
                                ref
                                    .read(eventDataProvider(arg).notifier)
                                    .updateIsAllDay(value);
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
                            child: Text(eventValue.editEventData.isAllDay
                                ? date
                                    .format(eventValue.editEventData.startTime)
                                : dateAndTime.format(
                                    eventValue.editEventData.startTime)),
                            onPressed: () {
                              int initialMinute =
                                  eventValue.editEventData.startTime.minute;
                              if (initialMinute % 15 != 0) {
                                initialMinute =
                                    initialMinute - initialMinute % 15 + 15;
                              }
                              _showCupertinoPicker(
                                CupertinoDatePicker(
                                  minuteInterval: 15,
                                  initialDateTime: DateTime(
                                      eventValue.editEventData.startTime.year,
                                      eventValue.editEventData.startTime.month,
                                      eventValue.editEventData.startTime.day,
                                      eventValue.editEventData.startTime.hour,
                                      initialMinute),
                                  mode: eventValue.editEventData.isAllDay
                                      ? CupertinoDatePickerMode.date
                                      : CupertinoDatePickerMode.dateAndTime,
                                  use24hFormat: true,
                                  onDateTimeChanged: (dateTime) {
                                    setState(() {
                                      startTime = dateTime;
                                    });
                                  },
                                ),
                                arg,
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
                            child: Text(eventValue.editEventData.isAllDay
                                ? date.format(eventValue.editEventData.endTime)
                                : dateAndTime
                                    .format(eventValue.editEventData.endTime)),
                            onPressed: () {
                              int initialMinute =
                                  eventValue.editEventData.endTime.minute;
                              if (initialMinute % 15 != 0) {
                                initialMinute =
                                    initialMinute - initialMinute % 15 + 15;
                              }
                              _showCupertinoPicker(
                                CupertinoDatePicker(
                                  minuteInterval: 15,
                                  initialDateTime: DateTime(
                                      eventValue.editEventData.endTime.year,
                                      eventValue.editEventData.endTime.month,
                                      eventValue.editEventData.endTime.day,
                                      eventValue.editEventData.endTime.hour,
                                      initialMinute),
                                  mode: eventValue.editEventData.isAllDay
                                      ? CupertinoDatePickerMode.date
                                      : CupertinoDatePickerMode.dateAndTime,
                                  use24hFormat: true,
                                  onDateTimeChanged: (dateTime) {
                                    setState(() {
                                      endTime = dateTime;
                                    });
                                  },
                                ),
                                arg,
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
                    initialValue: eventValue.editEventData.comment,
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
                          .read(eventDataProvider(arg).notifier)
                          .updateComment(text);
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
                        onPressed: () async {
                          dataBase.deleteEvent(eventValue.editEventData);
                          await fetchDataBaseValue.fetchDataList();
                          Navigator.popUntil(context, ModalRoute.withName("/"));
                          //TODO: showOkCancelAlertDialogの実装 driftでデータベースの削除
                          // showOkCancelAlertDialog(
                          //   context: (context),
                          //   title: "予定の削除",
                          //   message: "本当にこの日の予定を削除しますか？",
                          //   okLabel: "削除",
                          //   cancelLabel: "キャンセル",
                          // );
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

  void _showCupertinoPicker(Widget child, EventData data) {
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
                        final eventValue = ref.read(eventDataProvider(data));
                        final isEndTimeBefore = endTime.isBefore(startTime);
                        final isEqual = endTime.microsecondsSinceEpoch ==
                            startTime.millisecondsSinceEpoch;

                        switch (eventValue.editEventData.isAllDay) {
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
                            .read(eventDataProvider(data).notifier)
                            .updateStartTime(startTime);
                        ref
                            .read(eventDataProvider(data).notifier)
                            .updateEndTime(endTime);

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
