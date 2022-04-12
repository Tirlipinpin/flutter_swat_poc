import 'package:swat_poc/Data/calendar.dart';
import 'package:swat_poc/Data/project.dart';

abstract class CalendarRepository {
  Future<Calendar> fetchCalendar(DateTime date);
  Future<Calendar> assign(DateTime date, Project project, int hours);
}
