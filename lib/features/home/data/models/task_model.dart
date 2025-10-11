class TaskModel {
  String? id;
  String? title;
  String? titleLowerCase;
  String? description;
  DateTime? date;
  int? priority;
  bool isDone;

  TaskModel({
    this.id,
    this.title,
    this.titleLowerCase,
    this.description,
    this.date,
    this.priority,
    this.isDone = false,
  }) {
    titleLowerCase = title?.toLowerCase();
  }

  TaskModel.fromJson(Map<String, dynamic> json)
    : this(
        id: json['id'],
        title: json['title'],
        titleLowerCase: json['titleLowerCase'],
        description: json['description'],
        date: DateTime.fromMillisecondsSinceEpoch(json['date']),
        priority: json['priority'],
        isDone: json['isDone'],
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'titleLowerCase': titleLowerCase,
    'description': description,
    'date': date == null
        ? null
        : DateTime(date!.year, date!.month, date!.day).millisecondsSinceEpoch,
    'priority': priority,
    'isDone': isDone,
  };
}
