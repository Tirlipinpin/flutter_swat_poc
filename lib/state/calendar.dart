import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:swat_poc/Data/assignment.dart';
import 'package:swat_poc/Data/calendar.dart';
import 'package:swat_poc/Data/project.dart';
import 'package:swat_poc/Repositories/calendars/repository.dart';

class CalendarState {
  final bool isLoading;
  final Calendar calendar;

  const CalendarState({required this.isLoading, required this.calendar});

  String get id => calendar.id;
  int get weekOfYear => calendar.weekOfYear;
  List<Project> get projects => calendar.projects;
  List<Assignment> get assignments => calendar.assignments;
}

class CalendarStateNotifier extends StateNotifier<CalendarState> {
  final CalendarRepository calendarRepository;

  CalendarStateNotifier({required this.calendarRepository})
      : super(
            const CalendarState(isLoading: false, calendar: Calendar.empty()));

  void load() async {
    state = CalendarState(isLoading: true, calendar: state.calendar);
    final calendar = await calendarRepository.fetchCalendar();
    state = CalendarState(isLoading: false, calendar: calendar);
  }

  void setAssignment(Project project, int dayOfWeek, int hours) async {
    state = CalendarState(isLoading: true, calendar: state.calendar);
    final assignment = await calendarRepository.assign(
        state.calendar, project, dayOfWeek, hours);
    var calendar = Calendar(
      id: state.calendar.id,
      projects: state.calendar.projects,
      assignments: [...state.calendar.assignments, assignment],
      weekOfYear: state.calendar.weekOfYear,
    );
    state = CalendarState(isLoading: false, calendar: calendar);
  }
}
