import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:swat_poc/Data/calendar_day.dart';

class CalendarDayView extends HookConsumerWidget {
  final CalendarDay calendarDay;

  const CalendarDayView({Key? key, required this.calendarDay})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: Text("${calendarDay.date}"),
      ),
      body: const Text('Calendar day'),
    );
  }
}
