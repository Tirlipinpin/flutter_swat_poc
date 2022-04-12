import 'package:swat_poc/Data/calendar.dart';

abstract class CalendarRepository {
  Future<Calendar> fetchCalendar(DateTime date);
  Future<int> assign(Calendar calendar, String projectName, int hours);
}
