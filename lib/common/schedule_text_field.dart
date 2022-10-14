import 'package:flutter/material.dart';

class ScheduleTextField extends StatelessWidget {
  const ScheduleTextField(
      {Key? key,
        required this.hintText,
        required this.onChanged,
        required this.maxLine})
      : super(key: key);

  final String hintText;
  final ValueChanged<String>? onChanged;
  final int? maxLine;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextFormField(
        maxLines: maxLine,
        initialValue: "",
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
