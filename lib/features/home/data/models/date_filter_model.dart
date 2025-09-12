import 'dart:collection';
import 'package:flutter/material.dart';

typedef DateFilterEntry = DropdownMenuEntry<DateFilterModel>;

enum DateFilterModel {
  all(label: "All", durationInDays: 0),
  day(label: "Day", durationInDays: 1),
  week(label: "Week", durationInDays: 7),
  month(label: "Month", durationInDays: 30);

  final String label;
  final int durationInDays;

  const DateFilterModel({required this.label, required this.durationInDays});

  static final List<DateFilterEntry> entries =
      UnmodifiableListView<DateFilterEntry>(
        values.map<DateFilterEntry>(
          (DateFilterModel date) =>
              DateFilterEntry(value: date, label: date.label, enabled: true),
        ),
      );
}
