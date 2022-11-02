import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:calendar_sample/common/component/schedule_text_field.dart';
import 'package:calendar_sample/view/schedule_edit/edit_event_state_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../common/constraints/app_color.dart';
import '../../common/component/schedule_app_bar.dart';
import '../../common/component/schedule_body.dart';
import '../../common/component/schedule_config_cell.dart';
import '../../model/event_data.dart';
import 'package:calendar_sample/view/event_state_notifier.dart';

import 'event_repository_provider.dart';

class EditScheduleView extends ConsumerStatefulWidget {
  const EditScheduleView({super.key});

  @override
  EditScheduleState createState() => EditScheduleState();
}

class EditScheduleState extends ConsumerState<EditScheduleView> {
  late FocusNode myFocusNode;

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

    return ProviderScope(
      overrides: [
        editEventStateProvider
            .overrideWithProvider(editEventStateProviderFamily(arg)),
      ],
      child: Consumer(
        builder: (context, ref, _) {
          final eventValue = ref.watch(editEventStateProvider);
          return Focus(
            focusNode: myFocusNode,
            child: GestureDetector(
              onTap: myFocusNode.requestFocus,
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: AppColor.backGroundColor,
                appBar: ScheduleAppBar(
                  title: const Text('予定の編集'),
                  onPressedIcon: eventValue.isUpdated
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
                            Navigator.popUntil(
                                context, ModalRoute.withName("/"));
                          }
                        }
                      : () {
                          Navigator.popUntil(context, ModalRoute.withName("/"));
                        },
                  onPressedElevated:

                      ///取得したイベントの情報が変化していなかったら非活性にする
                      !eventValue.isUpdated
                          ? null
                          : () async {
                              ///更新したイベントをdriftに追加
                              ref
                                  .read(eventRepositoryProvider)
                                  .updateEvent(eventValue.editEventData);

                              ///eventLoaderに表示するデータを更新
                              await ref
                                  .read(eventStateProvider.notifier)
                                  .fetchEventDataMap();
                              Navigator.popUntil(
                                  context, ModalRoute.withName("/"));
                            },
                ),
                body: ScheduleBody(
                  titleTextField: ScheduleTextField(
                      initialValue: eventValue.editEventData.title,
                      hintText: "タイトルを入力してください",
                      onChanged: (text) {
                        ref
                            .read(editEventStateProvider.notifier)
                            .update((state) {
                          final updateTitle =
                              state.editEventData.copyWith(title: text);
                          state = state.copyWith(
                              isUpdated: true, editEventData: updateTitle);
                          return state;
                        });
                      },
                      maxLine: 1),
                  isAllDayConfigCell: ScheduleConfigCell(
                      leading: const Text("終日"),
                      trailing: Switch(
                          value: eventValue.editEventData.isAllDay,
                          onChanged: (value) {
                            ref
                                .read(editEventStateProvider.notifier)
                                .update((state) {
                              final updateIsAllDay =
                                  state.editEventData.copyWith(isAllDay: value);
                              state = state.copyWith(
                                  isUpdated: true,
                                  editEventData: updateIsAllDay);
                              return state;
                            });
                          })),
                  startTimeConfigCell: ScheduleConfigCell(
                      leading: const Text("開始"),
                      trailing: TextButton(
                        style:
                            TextButton.styleFrom(foregroundColor: Colors.black),
                        child: Text(

                            ///終日だったら日付のみ、そうでなければ日付と時間を表示
                            eventValue.editEventData.isAllDay
                                ? dateFormatForDate
                                    .format(eventValue.editEventData.startTime)
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
                                ref
                                    .read(editEventStateProvider.notifier)
                                    .update((state) {
                                  final updateStartTime = state.editEventData
                                      .copyWith(startTime: dateTime);
                                  state = state.copyWith(
                                      editEventData: updateStartTime);
                                  return state;
                                });
                              },
                            ),
                            arg,
                          );
                        },
                      )),
                  endTimeConfigCell: ScheduleConfigCell(
                      leading: const Text("終了"),
                      trailing: TextButton(
                        style:
                            TextButton.styleFrom(foregroundColor: Colors.black),
                        child: Text(

                            ///終日だったら日付のみ、そうでなければ日付と時間を表示
                            eventValue.editEventData.isAllDay
                                ? dateFormatForDate
                                    .format(eventValue.editEventData.endTime)
                                : dateFormatForDateAndTime
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
                              mode:

                                  ///終日だったら日付のみ、そうでなければ日付と時間を表示
                                  eventValue.editEventData.isAllDay
                                      ? CupertinoDatePickerMode.date
                                      : CupertinoDatePickerMode.dateAndTime,
                              use24hFormat: true,
                              onDateTimeChanged: (dateTime) {
                                ref
                                    .read(editEventStateProvider.notifier)
                                    .update((state) {
                                  final updateEndTime = state.editEventData
                                      .copyWith(endTime: dateTime);
                                  state = state.copyWith(
                                      editEventData: updateEndTime);
                                  return state;
                                });
                              },
                            ),
                            arg,
                          );
                        },
                      )),
                  commentTextField: ScheduleTextField(
                      initialValue: eventValue.editEventData.comment,
                      hintText: "コメントを入力してください",
                      onChanged: (text) {
                        ref
                            .read(editEventStateProvider.notifier)
                            .update((state) {
                          final updateComment =
                              state.editEventData.copyWith(comment: text);
                          state = state.copyWith(
                              isUpdated: true, editEventData: updateComment);
                          return state;
                        });
                      },
                      maxLine: null),
                  removeContainer: Container(
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
                            await ref
                                .read(eventStateProvider.notifier)
                                .fetchEventDataMap();
                            Navigator.popUntil(
                                context, ModalRoute.withName("/"));
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
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
                        ref
                            .read(editEventStateProvider.notifier)
                            .update((state) {
                          final cancelUpdateState = state.editEventData
                              .copyWith(
                                  startTime: data.startTime,
                                  endTime: data.endTime);

                          state =
                              state.copyWith(editEventData: cancelUpdateState);
                          return state;
                        });
                        Navigator.pop(context);
                      },
                      child: const Text("キャンセル")),
                  TextButton(
                      onPressed: () {
                        final eventValue =
                            ref.read(editEventStateProviderFamily(data));
                        final isEndTimeBefore = eventValue.editEventData.endTime
                            .isBefore(eventValue.editEventData.startTime);
                        final isEqual = eventValue
                                .editEventData.endTime.microsecondsSinceEpoch ==
                            eventValue
                                .editEventData.startTime.millisecondsSinceEpoch;

                        switch (eventValue.editEventData.isAllDay) {
                          case true:
                            if (isEndTimeBefore || isEqual) {
                              ref
                                  .read(editEventStateProvider.notifier)
                                  .update((state) {
                                final equalEndAndStart = state.editEventData
                                    .copyWith(
                                        endTime: state.editEventData.startTime);
                                state = state.copyWith(
                                    editEventData: equalEndAndStart);
                                return state;
                              });
                            }
                            break;
                          case false:
                            if (isEndTimeBefore || isEqual) {
                              ref
                                  .read(editEventStateProvider.notifier)
                                  .update((state) {
                                DateTime mutableTime =
                                    state.editEventData.startTime;
                                final equalEndAndStart = state.editEventData
                                    .copyWith(
                                        endTime: mutableTime
                                            .add(const Duration(hours: 1)));
                                state = state.copyWith(
                                    editEventData: equalEndAndStart);
                                return state;
                              });
                            }
                            break;
                        }
                        if (eventValue.editEventData.startTime !=
                                data.startTime ||
                            eventValue.editEventData.endTime != data.endTime) {
                          ref.read(editEventStateProvider.notifier).update(
                              (state) =>
                                  state = state.copyWith(isUpdated: true));
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
