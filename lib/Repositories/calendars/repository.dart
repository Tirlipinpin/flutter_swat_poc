import 'package:swat_poc/Data/assignment.dart';
import 'package:swat_poc/Data/calendar.dart';
import 'package:swat_poc/Data/project.dart';

abstract class CalendarRepository {
  Future<Calendar> fetchCalendar();
  Future<Assignment> assign(
      Calendar calendar, Project project, int dayOfWeek, int hours);
}
