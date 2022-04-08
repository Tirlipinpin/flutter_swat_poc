import 'package:swat_poc/Data/project.dart';
import 'package:swat_poc/Data/assignment.dart';

class Calendar {
  final List<Project> projects;
  final List<Assignment> assignments;

  const Calendar({required this.projects, required this.assignments});

  const Calendar.empty() : this(projects: const [], assignments: const []);

  Calendar.fromJson(Map<String, dynamic> json)
      : this(
            projects: (json['projects'] as List<dynamic>)
                .map((project) => Project.fromJson(project))
                .toList(),
            assignments: (json['assignments'] as List<dynamic>)
                .map((assignment) => Assignment.fromJson(assignment))
                .toList());
}
