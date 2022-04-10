import 'package:swat_poc/Data/assignment.dart';
import 'package:swat_poc/Data/calendar.dart';
import 'package:swat_poc/Data/project.dart';
import 'package:swat_poc/Repositories/calendars/repository.dart';

class InMemoryCalendarRepository extends CalendarRepository {
  Calendar calendar;

  InMemoryCalendarRepository()
      : calendar = Calendar(
          id: "1",
          projects: [
            Project(
              id: "1",
              name: "Flutter is better than react native",
              startDate: DateTime(2022, 4, 6, 9, 0),
              endDate: DateTime(2022, 4, 13, 9, 0),
            )
          ],
          assignments: [
            Assignment(
              id: "1",
              projectId: "1",
              resourceId: "mister",
              date: DateTime.parse("2022-06-13"),
              hours: 3,
            )
          ],
          weekOfYear: 24,
        );

  @override
  Future<Calendar> fetchCalendar() async {
    return await Future.delayed(const Duration(seconds: 1), () => calendar);
  }

  @override
  Future<Assignment> assign(
      Calendar _, Project project, int dayOfWeek, int hours) async {
    var assignment = Assignment(
      id: "id",
      projectId: project.id,
      resourceId: "mister",
      date: _resolveDate(dayOfWeek),
      hours: hours,
    );
    calendar = Calendar(
      id: calendar.id,
      projects: calendar.projects,
      assignments: [...calendar.assignments, assignment],
      weekOfYear: calendar.weekOfYear,
    );
    return await Future.delayed(const Duration(seconds: 1), () => assignment);
  }

  DateTime _resolveDate(int dayOfWeek) {
    print("Reolving date for day $dayOfWeek of week ${calendar.weekOfYear}");
    return DateTime.parse("2022-04-11");
  }
}
