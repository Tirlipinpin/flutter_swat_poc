import 'package:swat_poc/Data/calendar.dart';
import 'package:swat_poc/Data/project.dart';
import 'package:swat_poc/Repositories/calendars/repository.dart';

class InMemoryCalendarRepository extends CalendarRepository {
  Calendar calendar;

  InMemoryCalendarRepository()
      : calendar = Calendar(
          projects: [
            Project(
              id: "1",
              name: "Flutter is better than react native",
              startDate: DateTime(2022, 4, 6, 9, 0),
              endDate: DateTime(2022, 4, 13, 9, 0),
            )
          ],
          assignments: [],
          weekOfYear: 24,
        );

  @override
  Future<Calendar> fetchCalendar() async {
    return Future.delayed(const Duration(seconds: 1), () => calendar);
  }
}
