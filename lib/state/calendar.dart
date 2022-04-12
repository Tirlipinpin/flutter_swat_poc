// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:swat_poc/Data/calendar.dart';
// import 'package:swat_poc/Data/calendar_day.dart';
// import 'package:swat_poc/Data/project.dart';
// import 'package:swat_poc/Data/assignment.dart';
// import 'package:swat_poc/Repositories/calendars/repository.dart';
// import 'dart:developer' as developer;

// class CalendarState {
//   final bool isLoading;
//   final Calendar calendar;

//   const CalendarState({required this.isLoading, required this.calendar});

//   const CalendarState.loading()
//       : this(isLoading: true, calendar: const Calendar.empty());

//   List<Project>? get projects => calendar.projects;
//   List<CalendarDay>? get assignments => calendar.days;
//   bool get isEmpty => calendar.isEmpty;
// }

// class CalendarStateNotifier extends StateNotifier<AsyncValue<CalendarState>> {
//   final CalendarRepository calendarRepository;

//   CalendarStateNotifier({required this.calendarRepository})
//       : super(const AsyncValue.loading());

//   Future<void> load(DateTime date) async {
//     // state = const AsyncValue.loading();
//     final calendar = await calendarRepository.fetchCalendarDay(date);
//     state =
//         AsyncValue.data(CalendarState(isLoading: false, calendar: calendar));
//     return;
//   }

//   Future<void> setAssignment(String project, int hours) async {
//     // state = const AsyncValue.loading();
//     final statusCode =
//         await calendarRepository.assign(state.value!.calendar, project, hours);
//     developer.log('setAssignment > status code: $statusCode');

//     List<MapEntry<String, int>> newAssignments =
//         List.from(state.value!.assignments!).map(
//       (e) {
//         final entry = e as MapEntry<String, int>;
//         if (entry.key == project) {
//           return MapEntry(entry.key, hours);
//         }
//         return entry;
//       },
//     ).toList();

//     final calendar = CalendarDay(
//       id: state.value!.id,
//       date: state.value!.date,
//       assignments: newAssignments,
//     );
//     state =
//         AsyncValue.data(CalendarState(isLoading: false, calendar: calendar));
//   }
// }
