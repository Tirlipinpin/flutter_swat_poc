class Assignment {
  String? id;
  String? projectId;
  String? resourceId;
  String? date;
  int? hours;

  Assignment(
      {required this.id,
      required this.projectId,
      required this.resourceId,
      required this.date,
      required this.hours});

  Assignment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    projectId = json['project_id'];
    resourceId = json['resource_id'];
    date = json['date'];
    hours = json['hours'];
  }
}
