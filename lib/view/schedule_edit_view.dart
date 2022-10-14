import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:calendar_sample/main.dart';
import 'package:calendar_sample/repository/event_repository.dart';
import 'package:calendar_sample/view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../common/schedule_config_cell.dart';
import '../model/event_data.dart';
import 'edit_event_state_notifier.dart';

///イベントを編集する際に使うプロバイダー
final eventStateProvider = StateNotifierProvider.autoDispose
    .family<EditEventStateNotifier, EditEventDataState, EventData>(
        (ref, eventData) {
  return EditEventStateNotifier(eventData);
});

class EditScheduleView extends ConsumerStatefulWidget {
  const EditScheduleView({super.key});

  @override
  ScheduleDetailState createState() => ScheduleDetailState();
}

class ScheduleDetailState extends ConsumerState<EditScheduleView> {
  late FocusNode myFocusNode;

  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();
  DateFormat dateFormatForDateAndTime = DateFormat('yyyy-MM-dd HH:mm');
  DateFormat dateFormatForDate = DateFormat('yyyy-MM-dd');
  var uuid = Uuid();

  @override
  void initState() {
    myFocusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ///日別予定一覧から選択したイベントを格納する変数
    final EventData arg =
        (ModalRoute.of(context)?.settings.arguments) as EventData;

    final eventValue = ref.watch(eventStateProvider(arg));
    final fetchDataBaseValue = ref.watch(fetchDataBaseProvider);

    return Focus(
      focusNode: myFocusNode,
      child: GestureDetector(
        onTap: myFocusNode.requestFocus,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: const Color.fromARGB(255, 240, 238, 237),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: eventValue.isUpdated
                    ? () async {
                        final result = await showModalActionSheet<String>(
                          context: context,
                          actions: [
                            const SheetAction(
                              label: '編集を破棄',
                              key: 'dispose',
                            ),
                          ],
                        );
                        if (result == 'dispose') {
                          Navigator.popUntil(context, ModalRoute.withName("/"));
                        }
                      }
                    : () {
                        Navigator.popUntil(context, ModalRoute.withName("/"));
                      }),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed:

                      ///取得したイベントの情報が変化していなかったら非活性にする
                      !eventValue.isUpdated
                          ? null
                          : () async {
                              ///更新したイベントをdriftに追加
                              ref
                                  .read(eventRepositoryProvider)
                                  .updateEvent(eventValue.editEventData);

                              ///eventLoaderに表示するデータを更新
                              await fetchDataBaseValue.fetchDataList();
                              Navigator.popUntil(
                                  context, ModalRoute.withName("/"));
                            },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.disabled)) {
                          return Colors.white;
                        }
                        return Colors.white;
                      },
                    ),
                    foregroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.disabled)) {
                          return const Color(0xFFAEAEAE);
                        }
                        return Colors.black;
                      },
                    ),
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
                          .read(eventStateProvider(arg).notifier)
                          .update((state) {
                        final updateTitle =
                            state.editEventData.copyWith(title: text);
                        state = state.copyWith(
                            isUpdated: true, editEventData: updateTitle);
                        return state;
                      });
                    },
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(
                        top: 12, bottom: 1, left: 12, right: 12),
                    child: ScheduleConfigCell(
                        leading: const Text("終日"),
                        trailing: Switch(
                            value: eventValue.editEventData.isAllDay,
                            onChanged: (value) {
                              ref
                                  .read(eventStateProvider(arg).notifier)
                                  .update((state) {
                                final updateIsAllDay = state.editEventData
                                    .copyWith(isAllDay: value);
                                state = state.copyWith(
                                    isUpdated: true,
                                    editEventData: updateIsAllDay);
                                return state;
                              });
                            }))
                    // const Text("終日"),

                    ),
                Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
                    child: ScheduleConfigCell(
                        leading: const Text("開始"),
                        trailing: TextButton(
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.black),
                          child: Text(

                              ///終日だったら日付のみ、そうでなければ日付と時間を表示
                              eventValue.editEventData.isAllDay
                                  ? dateFormatForDate.format(
                                      eventValue.editEventData.startTime)
                                  : dateFormatForDateAndTime.format(
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
                                mode:

                                    ///終日だったら日付のみ、そうでなければ日付と時間を表示
                                    eventValue.editEventData.isAllDay
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
                        ))
                    // const Text("開始"),

                    ),
                Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
                    child: ScheduleConfigCell(
                        leading: const Text("終了"),
                        trailing: TextButton(
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.black),
                          child: Text(

                              ///終日だったら日付のみ、そうでなければ日付と時間を表示
                              eventValue.editEventData.isAllDay
                                  ? dateFormatForDate
                                      .format(eventValue.editEventData.endTime)
                                  : dateFormatForDateAndTime.format(
                                      eventValue.editEventData.endTime)),
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
                                mode:

                                    ///終日だったら日付のみ、そうでなければ日付と時間を表示
                                    eventValue.editEventData.isAllDay
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
                        ))
                    // const Text("終了"),

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
                          .read(eventStateProvider(arg).notifier)
                          .update((state) {
                        final updateComment =
                            state.editEventData.copyWith(comment: text);
                        state = state.copyWith(
                            isUpdated: true, editEventData: updateComment);
                        return state;
                      });
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
                          final result = await showOkCancelAlertDialog(
                            context: (context),
                            title: "予定の削除",
                            message: "本当にこの日の予定を削除しますか？",
                            okLabel: "削除",
                            cancelLabel: "キャンセル",
                          );
                          if (result == OkCancelResult.ok) {
                            ///指定されているデータの削除
                            ref
                                .read(eventRepositoryProvider)
                                .deleteEvent(eventValue.editEventData);

                            ///データの更新
                            await fetchDataBaseValue.fetchDataList();
                            Navigator.popUntil(
                                context, ModalRoute.withName("/"));
                          }
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
                        final eventValue = ref.read(eventStateProvider(data));
                        final isEndTimeBefore = endTime.isBefore(startTime);
                        final isEqual = endTime.microsecondsSinceEpoch ==
                            startTime.millisecondsSinceEpoch;

                        switch (eventValue.editEventData.isAllDay) {
                          case true:
                            if (isEndTimeBefore || isEqual) {
                              endTime = startTime;
                            }
                            break;
                          case false:
                            if (isEndTimeBefore || isEqual) {
                              endTime = startTime.add(const Duration(hours: 1));
                            }
                            break;
                        }

                        ref
                            .read(eventStateProvider(data).notifier)
                            .update((state) {
                          final updateStartTime = state.editEventData
                              .copyWith(startTime: startTime);
                          state = state.copyWith(
                              isUpdated: true, editEventData: updateStartTime);
                          return state;
                        });
                        ref
                            .read(eventStateProvider(data).notifier)
                            .update((state) {
                          final updateEndTime =
                              state.editEventData.copyWith(endTime: endTime);
                          state = state.copyWith(
                              isUpdated: true, editEventData: updateEndTime);
                          return state;
                        });

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
