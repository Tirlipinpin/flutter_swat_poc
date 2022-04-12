import 'package:swat_poc/Data/calendar.dart';
import 'package:swat_poc/Repositories/calendars/repository.dart';

class InMemoryCalendarRepository extends CalendarRepository {
  Calendar calendar;

  InMemoryCalendarRepository()
      : calendar = Calendar(
          id: "1",
          date: DateTime.parse("2022-04-12"),
          assignments: {
            "Awesome project": 12,
            "Boring...": 2,
          }.entries.toList(),
        );

  @override
  Future<Calendar> fetchCalendar(DateTime date) async {
    return await Future.delayed(const Duration(seconds: 1), () => calendar);
  }

  @override
  Future<int> assign(Calendar calendar, String projectName, int hours) async {
    calendar.assignments!.map((e) {
      if (e.key == projectName) {
        return MapEntry(e.key, hours);
      }
      return e;
    }).toList();
    this.calendar = Calendar(
      id: calendar.id,
      date: calendar.date,
      assignments: calendar.assignments,
    );
    return await Future.delayed(const Duration(seconds: 1), () => 200);
  }
}
