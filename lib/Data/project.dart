class Project {
  final String id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;

  const Project(
      {required this.id,
      required this.name,
      required this.startDate,
      required this.endDate});

  Project.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'],
          name: json['name'],
          startDate: DateTime.parse(json['start_date']),
          endDate: DateTime.parse(json['end_date']),
        );
}
