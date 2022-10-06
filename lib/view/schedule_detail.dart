import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final startTimeProvider = StateProvider<DateTime?>((ref) => null);
final endTimeProvider = StateProvider<DateTime?>((ref) => null);


class ScheduleDetail extends ConsumerStatefulWidget {
  const ScheduleDetail({super.key});

  @override
  ScheduleDetailState createState() => ScheduleDetailState();
}

class ScheduleDetailState extends ConsumerState<ScheduleDetail> {
  late FocusNode myFocusNode;
  var now = DateTime.now();
  DateTime? startTime;
  DateTime? endTime;
  DateFormat dateAndTime = DateFormat('yyyy-MM-dd HH:mm');

  @override
  void initState() {
    startTime = now;
    endTime = now;
    myFocusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final startTimeValue = ref.watch(startTimeProvider);
    final endTimeValue = ref.watch(endTimeProvider);

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
                  onPressed: () {},
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
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: TextField(
                    autofocus: true,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "タイトルを入力してください",
                      border: OutlineInputBorder(),
                    ),
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
                          Switch(value: true, onChanged: (value) {})
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
                            child:
                                Text(dateAndTime.format(startTimeValue ?? now)),
                            onPressed: () {
                              _showCupertinoPicker(
                                CupertinoDatePicker(
                                  initialDateTime: DateTime.now(),
                                  mode: CupertinoDatePickerMode.dateAndTime,
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
                            child:
                                Text(dateAndTime.format(endTimeValue ?? now)),
                            onPressed: () {
                              _showCupertinoPicker(
                                CupertinoDatePicker(
                                  initialDateTime: DateTime.now(),
                                  mode: CupertinoDatePickerMode.dateAndTime,
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
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: TextField(
                    maxLines: null,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      // focusedBorder: OutlineInputBorder(
                      //     borderSide: BorderSide(color: Colors.white)),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "コメントを入力してください",
                      border: OutlineInputBorder(),
                    ),
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
