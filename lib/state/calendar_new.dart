import 'dart:async';

import 'package:swat_poc/Data/calendar.dart';
import 'package:swat_poc/Repositories/calendars/repository.dart';
import 'package:swat_poc/state/calendar.dart';
import 'dart:developer' as developer;

class CalendarService {
  final CalendarRepository calendarRepository;
  final StreamController<CalendarState> _controller;
  Calendar current;

  CalendarService({required this.calendarRepository})
      : _controller = StreamController(),
        current = const Calendar.empty();

  Future<void> load(DateTime date) async {
    developer.log("CalendarService > loading assigments of $date");
    _controller.add(const CalendarState.loading());
    final calendar = await calendarRepository.fetchCalendar(date);
    current = calendar;
    _controller.add(CalendarState(isLoading: false, calendar: calendar));
    developer.log("CalendarService > assignemnts of $date loaded");
  }

  Future<void> setAssignment(String project, int hours) async {
    developer.log("CalendarService > setting $hours for project $project");
    _controller.add(const CalendarState.loading());
    final statusCode = await calendarRepository.assign(current, project, hours);
    developer.log('setAssignment > status code: $statusCode');

    List<MapEntry<String, int>> newAssignments =
        List.from(current.assignments!).map(
      (e) {
        final entry = e as MapEntry<String, int>;
        if (entry.key == project) {
          return MapEntry(entry.key, hours);
        }
        return entry;
      },
    ).toList();

    final calendar = Calendar(
      id: current.id,
      date: current.date,
      assignments: newAssignments,
    );
    _controller.add(CalendarState(isLoading: false, calendar: calendar));
  }
}
