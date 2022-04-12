class Project {
  final String id;
  final String name;

  const Project({
    required this.id,
    required this.name,
  });

  Project.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'],
          name: json['name'],
        );
}
