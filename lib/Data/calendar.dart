class Calendar {
  final String? id;
  final DateTime? date;
  final List<MapEntry<String, int>>? assignments;

  const Calendar({
    required this.id,
    required this.date,
    required this.assignments,
  });

  const Calendar.empty() : this(id: null, date: null, assignments: null);

  Calendar.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'],
          date: json['date'],
          assignments:
              (json['assignments'] as Map<String, int>).entries.toList(),
        );

  Calendar.from(Calendar other)
      : this(
            id: other.id,
            date: other.date,
            assignments: List.from(other.assignments!));

  bool get isEmpty {
    return id == null;
  }
}
