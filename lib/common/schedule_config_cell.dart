import 'package:flutter/material.dart';

class ScheduleConfigCell extends StatelessWidget {
  const ScheduleConfigCell(
      {Key? key, required this.leading, required this.trailing})
      : super(key: key);

  final Widget leading;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            leading,
            trailing,
          ],
        ),
      ),
    );
  }
}
