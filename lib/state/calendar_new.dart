import 'dart:async';

import 'package:swat_poc/Data/calendar_day.dart';
import 'package:swat_poc/Data/calendar.dart';
import 'package:swat_poc/Data/project.dart';
import 'package:swat_poc/Repositories/calendars/repository.dart';
import 'dart:developer' as developer;

class CalendarState {
  final bool isLoading;
  final Calendar calendar;

  const CalendarState({required this.isLoading, required this.calendar});

  const CalendarState.loading()
      : this(isLoading: true, calendar: const Calendar.empty());

  List<Project>? get projects => calendar.projects;
  List<CalendarDay>? get days => calendar.days;
  bool get isEmpty => calendar.isEmpty;
  DateTime? get firstDay => calendar.firstDay;
}

class CalendarService {
  final CalendarRepository calendarRepository;
  final StreamController<CalendarState> _controller;
  Calendar current;

  CalendarService({required this.calendarRepository})
      : _controller = StreamController(),
        current = const Calendar.empty();

  Stream<CalendarState> get stream => _controller.stream;

  Future<void> load(DateTime date) async {
    developer.log("CalendarService > loading calendar");
    _controller.add(const CalendarState.loading());
    final calendar = await calendarRepository.fetchCalendar(date);
    current = Calendar.from(calendar);
    _controller.add(CalendarState(isLoading: false, calendar: calendar));
    developer.log("CalendarService > calendar loaded");
  }

  Future<void> setAssignment(DateTime date, Project project, int hours) async {
    developer.log("CalendarService > setting $hours for project ${project.id}");
    _controller.add(const CalendarState.loading());
    final newCalendar = await calendarRepository.assign(date, project, hours);

    current = Calendar.from(newCalendar);
    _controller.add(CalendarState(isLoading: false, calendar: newCalendar));
  }
}
