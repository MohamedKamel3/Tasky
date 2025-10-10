import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String showDate(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final tomorrow = today.add(const Duration(days: 1));

  final formattedMonth = DateFormat('MMM').format(date);

  if (DateUtils.isSameDay(date, today)) {
    return "Today";
  } else if (DateUtils.isSameDay(date, tomorrow)) {
    return "Tomorrow";
  } else if (date.year == now.year) {
    return "${date.day} $formattedMonth";
  } else {
    return "${date.day} $formattedMonth ${date.year}";
  }
}
