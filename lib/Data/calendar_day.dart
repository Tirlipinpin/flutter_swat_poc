import 'package:swat_poc/Data/assignment.dart';

class CalendarDay {
  final DateTime date;
  final List<Assignment>? assignments;

  const CalendarDay({
    required this.date,
    required this.assignments,
  });

  CalendarDay.empty() : this(date: DateTime.now(), assignments: null);

  CalendarDay.fromJson(Map<String, dynamic> json)
      : this(
          date: DateTime.parse(json['date']),
          assignments: (json['assignments'] as List<dynamic>)
              .map((a) => Assignment.fromJson(a))
              .toList(),
        );

  CalendarDay.from(CalendarDay other)
      : this(date: other.date, assignments: List.from(other.assignments!));

  bool get isEmpty {
    return assignments == null;
  }
}
