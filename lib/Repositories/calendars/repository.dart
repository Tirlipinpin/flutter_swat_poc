import 'package:swat_poc/Data/calendar.dart';

abstract class CalendarRepository {
  Future<Calendar> fetchCalendar();
}
