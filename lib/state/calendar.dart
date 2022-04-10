import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:swat_poc/Data/calendar.dart';
import 'package:swat_poc/Data/project.dart';
import 'package:swat_poc/Repositories/calendars/repository.dart';

class CalendarState extends StateNotifier<Calendar> {
  final CalendarRepository calendarRepository;

  CalendarState({required this.calendarRepository})
      : super(const Calendar.empty());

  void load() async {
    state = await calendarRepository.fetchCalendar();
  }

  void setAssignment(Project project, int dayOfWeek, int hours) async {
    final assignment =
        await calendarRepository.assign(state, project, dayOfWeek, hours);
    state = Calendar(
      id: state.id,
      projects: state.projects,
      assignments: [...state.assignments, assignment],
      weekOfYear: state.weekOfYear,
    );
  }
}
