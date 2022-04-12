import 'package:swat_poc/Data/project.dart';
import 'package:swat_poc/Data/calendar_day.dart';

class Calendar {
  final List<Project> projects;
  final List<CalendarDay> days;

  const Calendar({
    required this.projects,
    required this.days,
  });

  const Calendar.empty() : this(projects: const [], days: const []);

  DateTime? get firstDay => days.first.date;

  Calendar.fromJson(Map<String, dynamic> json)
      : this(
          projects: (json['projects'] as List<dynamic>)
              .map((project) => Project.fromJson(project))
              .toList(),
          days: (json['days'] as List<dynamic>)
              .map((assignment) => CalendarDay.fromJson(assignment))
              .toList(),
        );

  Calendar.from(Calendar other)
      : this(
          projects: List.from(other.projects),
          days: List.from(other.days),
        );

  bool get isEmpty {
    return projects.isEmpty;
  }
}
