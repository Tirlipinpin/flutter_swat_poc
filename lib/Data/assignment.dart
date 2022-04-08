class Assignment {
  final String id;
  final String projectId;
  final String resourceId;
  final DateTime date;
  final int hours;

  const Assignment(
      {required this.id,
      required this.projectId,
      required this.resourceId,
      required this.date,
      required this.hours});

  Assignment.fromJson(Map<String, dynamic> json)
      : this(
            id: json['id'],
            projectId: json['project_id'],
            resourceId: json['resource_id'],
            date: DateTime.parse(json['date']),
            hours: json['hours']);
}
