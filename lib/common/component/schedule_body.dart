import 'package:flutter/material.dart';

class ScheduleBody extends StatelessWidget {
  const ScheduleBody(
      {Key? key,
      required this.titleTextField,
      required this.commentTextField,
      required this.isAllDayConfigCell,
      required this.startTimeConfigCell,
      required this.endTimeConfigCell,
      required this.removeContainer})
      : super(key: key);

  final Widget titleTextField;
  final Widget commentTextField;
  final Widget isAllDayConfigCell;
  final Widget startTimeConfigCell;
  final Widget endTimeConfigCell;
  final Widget removeContainer;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          titleTextField,
          Padding(
              padding: const EdgeInsets.only(
                  top: 12, bottom: 1, left: 12, right: 12),
              child: isAllDayConfigCell),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
            child: startTimeConfigCell,
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
              child: endTimeConfigCell),
          commentTextField,
          Padding(
            padding: const EdgeInsets.all(12),
            child: removeContainer,
          )
        ],
      ),
    );
  }
}
