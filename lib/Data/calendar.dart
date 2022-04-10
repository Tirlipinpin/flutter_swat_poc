import 'package:swat_poc/Data/project.dart';
import 'package:swat_poc/Data/assignment.dart';

class Calendar {
  final String id;
  final int weekOfYear;
  final List<Project> projects;
  final List<Assignment> assignments;

  const Calendar({
    required this.id,
    required this.projects,
    required this.assignments,
    required this.weekOfYear,
  });

  const Calendar.empty()
      : this(id: "", projects: const [], assignments: const [], weekOfYear: -1);

  Calendar.fromJson(Map<String, dynamic> json)
      : this(
            id: json['id'],
            projects: (json['projects'] as List<dynamic>)
                .map((project) => Project.fromJson(project))
                .toList(),
            assignments: (json['assignments'] as List<dynamic>)
                .map((assignment) => Assignment.fromJson(assignment))
                .toList(),
            weekOfYear: json['week']);
}
