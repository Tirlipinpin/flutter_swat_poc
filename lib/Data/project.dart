class Project {
  String? id;
  String? name;
  DateTime? startDate;
  DateTime? endDate;

  Project(
      {required this.id,
      required this.name,
      required this.startDate,
      required this.endDate});

  Project.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    startDate = DateTime.parse(json['start_date']);
    endDate = DateTime.parse(json['end_date']);
  }
}
