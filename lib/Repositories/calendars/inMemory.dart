import 'package:swat_poc/Data/calendar.dart';
import 'package:swat_poc/Repositories/calendars/repository.dart';

class InMemoryCalendarRepository extends CalendarRepository {
  Calendar calendar;

  InMemoryCalendarRepository() : calendar = Calendar.empty();

  @override
  Future<Calendar> fetchCalendar() async {
    return Future.delayed(const Duration(seconds: 1), () => calendar);
  }
}
