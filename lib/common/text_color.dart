import 'package:flutter/material.dart';

Color textColor(DateTime day) {
  const defaultTextColor = Colors.black87;
  if (day.weekday == DateTime.sunday) {
    return Colors.red;
  }
  if (day.weekday == DateTime.saturday) {
    return Colors.blue[600]!;
  }
  return defaultTextColor;
}
