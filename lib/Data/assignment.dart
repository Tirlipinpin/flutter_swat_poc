class Assignment {
  final String id;
  final String projectId;
  final int hours;

  const Assignment({
    required this.id,
    required this.projectId,
    required this.hours,
  });

  Assignment.fromJson(Map<String, dynamic> json)
      : this(
            id: json['id'],
            projectId: json['project_id'],
            hours: json['hours']);
}
