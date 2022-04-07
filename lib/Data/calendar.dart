import 'package:swat_poc/Data/project.dart';
import 'package:swat_poc/Data/assignment.dart';

class Calendar {
  List<Project>? projects;
  List<Assignment>? assignments;

  Calendar({required this.projects, required this.assignments});

  Calendar.empty()
      : projects = [],
        assignments = [];

  Calendar.fromJson(Map<String, dynamic> json) {
    projects = (json['projects'] as List<dynamic>)
        .map((project) => Project.fromJson(project))
        .toList();
    assignments = (json['assignments'] as List<dynamic>)
        .map((assignment) => Assignment.fromJson(assignment))
        .toList();
  }

  load() {
    print("loading");
  }
}
