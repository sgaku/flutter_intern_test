import 'package:flutter/material.dart';

class ScheduleTextField extends StatelessWidget {
  const ScheduleTextField(
      {Key? key,
      required this.hintText,
      required this.onChanged,
      required this.maxLine,
      required this.initialValue})
      : super(key: key);

  final String hintText;
  final ValueChanged<String>? onChanged;
  final int? maxLine;
  final String initialValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextFormField(
        autofocus: true,
        maxLines: maxLine,
        initialValue: initialValue,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white)),
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          border: const OutlineInputBorder(),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
