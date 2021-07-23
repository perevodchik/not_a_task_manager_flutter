class Task {
  int? id;
  final String description;
  final DateTime time;
  final DateTime date;

  Task(this.id, this.description, this.time, this.date);

  Map<String, dynamic> toJson() => {
    "id": id,
    "description": description,
    "time": time,
    "date": date
  };

  @override
  String toString() => toJson().toString();
}