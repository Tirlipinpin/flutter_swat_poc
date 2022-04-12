// import 'package:swat_poc/Data/calendar.dart';
// import 'package:swat_poc/Data/project.dart';
// import 'package:swat_poc/Data/assignment.dart';
// import 'package:swat_poc/Data/calendar_day.dart';
// import 'package:swat_poc/Repositories/calendars/repository.dart';

// class InMemoryCalendarRepository extends CalendarRepository {
//   Calendar calendar;

//   InMemoryCalendarRepository()
//       : calendar = Calendar(
//           projects: [
//             Project(
//               id: "project",
//               name: "Awesome project",
//               startDate: DateTime.parse("2022-04-12"),
//               endDate: DateTime.parse("2022-05-12"),
//             ),
//           ],
//           assignments: [],
//         );

//   @override
//   Future<CalendarDay> fetchCalendarDay(DateTime date) async {
//     // return await Future.delayed(const Duration(seconds: 1), () => calendar);
//     throw UnimplementedError();
//   }

//   @override
//   Future<Assignment> assign(
//       Calendar calendar, Project project, int hours) async {
//     // calendar.assignments!.map((e) {
//     //   if (e.key == projectName) {
//     //     return MapEntry(e.key, hours);
//     //   }
//     //   return e;
//     // }).toList();
//     // this.calendar = CalendarDay(
//     //   id: calendar.id,
//     //   date: calendar.date,
//     //   assignments: calendar.assignments,
//     // );
//     // return await Future.delayed(const Duration(seconds: 1), () => 200);
//     throw UnimplementedError();
//   }

//   @override
//   Future<Calendar> fetchCalendar() {
//     // TODO: implement fetchCalendar
//     throw UnimplementedError();
//   }
// }
